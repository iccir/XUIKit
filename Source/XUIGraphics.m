/*
    Copyright (c) 2012-2013, Ricci Adams.  All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following condition is met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL RICCI ADAMS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <XUIKit/XUIGraphics.h>

#import <XUIKit/XUITypes.h>
#import <XUIKit/XUIBase.h>
#import <XUIKit/XUIImageAdditions.h>
#import <AppKit/NSGraphicsContext.h>
#import <ApplicationServices/ApplicationServices.h>

#import <dlfcn.h>

static NSGraphicsContext *sOriginalContext   = nil;
static NSMutableArray    *sContextStateStack = nil;

typedef NS_ENUM(NSInteger, XUIGraphicsContextStateType) {
    XUIGraphicsContextStateTypeUnknown,
    XUIGraphicsContextStateTypeImage,
    XUIGraphicsContextStateTypePDF
};


@interface XUIGraphicsContextState : NSObject
@property (nonatomic, strong) NSGraphicsContext *context;
@property (nonatomic, assign) XUIGraphicsContextStateType type;
@property (nonatomic, assign) CGAffineTransform baseCTM;
@property (nonatomic, readonly) CGContextRef CGContext;

// For image contexts
@property (nonatomic, assign) CGFloat scale;

// For PDF contexts
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGRect mediaBox;
@property (nonatomic, assign) BOOL needsEndPage;

@end


static void sSetBaseCTM(CGAffineTransform transform)
{
    static void (*CGContextSetBaseCTM)(CGAffineTransform) = NULL;

    // Sigh,
    // <rdar://10221932> CGContextSetBaseCTM() and CGContextGetBaseCTM() should be public API
    //
#if PRIVATE_API_USAGE_OK
    if (!CGContextSetBaseCTM) {
        char s[32];
        strcpy(s, "CGContext");
        strcat(s, "SetBaseCTM");
        CGContextSetBaseCTM = dlsym(NULL, s);
    }
#endif
    
    if (CGContextSetBaseCTM) {
        CGContextSetBaseCTM(transform);
    }
}


@implementation XUIGraphicsContextState

- (CGContextRef) CGContext
{
    return [_context graphicsPort];
}

@end


static void sPushContext(CGContextRef cgContext)
{
    if (!sContextStateStack) {
        sContextStateStack = [[NSMutableArray alloc] init];
    }
    
    if ([sContextStateStack count] == 0) {
        sOriginalContext = [NSGraphicsContext currentContext];
    }

    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)cgContext flipped:YES];
    XUIGraphicsContextState *state = [[XUIGraphicsContextState alloc] init];
    [state setContext:context];

    [NSGraphicsContext setCurrentContext:context];

    [sContextStateStack addObject:state];
}


#pragma mark -
#pragma mark Public functions

CGContextRef XUIGraphicsGetCurrentContext()
{
    return [[NSGraphicsContext currentContext] graphicsPort];
}


void XUIGraphicsPushContext(CGContextRef ctx)
{
    sPushContext(ctx);
}


void XUIGraphicsPopContext()
{
    NSUInteger count = [sContextStateStack count];

    [sContextStateStack removeLastObject];

    if (count > 1) {
        XUIGraphicsContextState *state = [sContextStateStack lastObject];
        [NSGraphicsContext setCurrentContext:[state context]];

    } else if (count == 1) {
        [NSGraphicsContext setCurrentContext:sOriginalContext];
        sOriginalContext = nil;
    }
}


void XUIRectFillUsingBlendMode(CGRect rect, CGBlendMode blendMode)
{
    CGContextRef c = XUIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    CGContextSetBlendMode(c, blendMode);
    CGContextFillRect(c, rect);
    CGContextRestoreGState(c);
}


void XUIRectFill(CGRect rect)
{
    XUIRectFillUsingBlendMode(rect, kCGBlendModeCopy);
}


void XUIRectFrameUsingBlendMode(CGRect rect, CGBlendMode blendMode)
{
    CGContextRef c = XUIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetBlendMode(c, blendMode);
    XUIRectFrame(rect);
    CGContextRestoreGState(c);
}


void XUIRectFrame(CGRect rect)
{
    CGContextStrokeRect(XUIGraphicsGetCurrentContext(), rect);
}


void XUIRectClip(CGRect rect)
{
    CGContextClipToRect(XUIGraphicsGetCurrentContext(), rect);
}


#pragma mark -
#pragma mark Image context

void XUIGraphicsBeginImageContext(CGSize size)
{
    XUIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
}


void XUIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
{
    // If 0 is passed in, we have no way of knowing which screen we will draw to.  Use mainScreen
    if (scale == 0.0) {
        NSScreen *mainScreen = [NSScreen mainScreen];

        if ([mainScreen respondsToSelector:@selector(backingScaleFactor)]) {
            scale = [mainScreen backingScaleFactor];
        } else {
            scale = 1.0;
        }
    }
    
    const size_t width  = size.width  * scale;
    const size_t height = size.height * scale;
    
    if (width > 0 && height > 0) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = (opaque? kCGImageAlphaNoneSkipFirst : kCGImageAlphaPremultipliedFirst);
        
        CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, bitmapInfo);
        CGContextConcatCTM(ctx, CGAffineTransformMake(1, 0, 0, -1, 0, height));
        CGContextScaleCTM(ctx, 1.0/scale, 1.0/scale);

        sPushContext(ctx);

        // At this point, UIKit makes a call equivalent to:
        // CGContextSetBaseCTM(CGContextGetCTM(ctx));
        //
        // This is needed to draw shadows in the correct direction.  Shadows use
        // the base-space transform (CGContextSetBaseCTM/CGContextGetBaseCTM)
        // rather than the user-space transform (CGContextGetCTM)
        //
        // Sadly, the calls to set/get the base transform are private API, with no 
        // public equivalents.  I filed rdar://10221932 to request that these be 
        // made public ( http://www.openradar.me/radar?id=1570415 ).
        //
        sSetBaseCTM(CGContextGetCTM(ctx));

        CGColorSpaceRelease(colorSpace);

        XUIGraphicsContextState *state = [sContextStateStack lastObject];
        [state setScale:scale];
        [state setType:XUIGraphicsContextStateTypeImage];
        
        CGContextRelease(ctx);
    }
}


NSImage *XUIGraphicsGetImageFromCurrentImageContext()
{
    XUIGraphicsContextState *state = [sContextStateStack lastObject];
    NSImage *result = nil;

    if ([state type] == XUIGraphicsContextStateTypeImage) {
        CGImageRef theCGImage = CGBitmapContextCreateImage([state CGContext]);
        result = [NSImage imageWithCGImage:theCGImage scale:[state scale] orientation:XUIImageOrientationUp];
        CGImageRelease(theCGImage);
    }

    return result;
}


void XUIGraphicsEndImageContext()
{
    XUIGraphicsContextState *state = [sContextStateStack lastObject];
    
    if ([state type] == XUIGraphicsContextStateTypeImage) {
        XUIGraphicsPopContext();
    }
}

