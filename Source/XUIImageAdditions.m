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

#import <XUIKit/XUIImageAdditions.h>
#import <XUIKit/XUIGraphics.h>

#if 0
#import <AppKit/NSImage.h>

@interface XUIImage ()
@end


@implementation XUIImage {
    NSImage *_image;
    CGFloat  _explicitScale;
}


+ (XUIImage *) imageNamed:(NSString *)name
{
    NSImage *image = [NSImage imageNamed:name];
    return [[self alloc] _initWithNSImage:image scale:0 orientation:0]; 
}


+ (XUIImage *) imageWithData:(NSData *)data
{
    return [[self alloc] initWithData:data];
}


+ (XUIImage *) imageWithData:(NSData *)data scale:(CGFloat)scale
{
    return [[self alloc] initWithData:data scale:scale];
}


+ (XUIImage *) imageWithContentsOfFile:(NSString *)path
{
    return [[self alloc] initWithContentsOfFile:path];
}


+ (XUIImage *) imageWithCGImage:(CGImageRef)imageRef
{
    return [[self alloc] initWithCGImage:imageRef scale:0 orientation:0];
}


+ (XUIImage *) imageWithCGImage:(CGImageRef)imageRef scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation
{
    return [[self alloc] initWithCGImage:imageRef scale:scale orientation:orientation];
}


+ (XUIImage *) imageWithCIImage:(CIImage *)ciImage
{
    return [[self alloc] initWithCIImage:ciImage];
}


+ (XUIImage *) imageWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation
{
    return [[self alloc] initWithCIImage:ciImage scale:scale orientation:orientation];
}


- (id) _initWithNSImage:(NSImage *)image scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation
{
    if (!image) {
        self = nil;
        return nil;
    }
    
    if ((self = [super init])) {
        _image = image;
        
        for (NSBitmapImageRep *rep in [_image representations]) {
            CGSize  size   = [rep size];
            CGFloat height = [rep pixelsHigh];
            CGFloat width  = [rep pixelsWide];

            // NSImage tries to account for image dpi, which can result in size being a non-integral 
            // scale factor of pixelsWide/pixelsHeight due to some graphic editors saving 
            // not-quite-72-dpi images
            //
            // Correct this to only allow 1x and 2x
            //
            size.width  = round((size.width  / width)  * 2) * width  / 2;
            size.height = round((size.height / height) * 2) * height / 2;

            [rep setSize:size];
        }
        
        
        if (scale > 0) {
            _explicitScale = scale;
        }
    }
    
    return self;
}


- (id) initWithData:(NSData *)data
{
    NSImage *image = [[NSImage alloc] initWithData:data];
    return [self _initWithNSImage:image scale:0 orientation:0];
}


- (id) initWithData:(NSData *)data scale:(CGFloat)scale
{
    NSImage *image = [[NSImage alloc] initWithData:data];
    return [self _initWithNSImage:image scale:scale orientation:0];
}


- (id) initWithContentsOfFile:(NSString *)path
{
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    return [self _initWithNSImage:image scale:0 orientation:XUIImageOrientationUp];
}


- (id) initWithCGImage:(CGImageRef)image
{
    return [self initWithCGImage:image scale:0 orientation:XUIImageOrientationUp];
}


- (id) initWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation
{
    CGFloat scaleToUse = scale;
    if (scaleToUse < 1) {
        scaleToUse = [[NSScreen mainScreen] backingScaleFactor];
    }

    NSSize size = NSMakeSize(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    size.width  /= scaleToUse;
    size.height /= scaleToUse;
    
    NSImage *nsImage = [[NSImage alloc] initWithCGImage:cgImage size:size];
    return [self _initWithNSImage:nsImage scale:scale orientation:orientation];
}


- (id) initWithCIImage:(CIImage *)ciImage
{
    //!i: IMPLEMENT
    return nil;
}


- (id) initWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation
{
    //!i: IMPLEMENT
    return nil;
}




#pragma mark -
#pragma mark Private Methods

- (void) _drawImage:(CGImageRef)image rect:(CGRect)rect context:(CGContextRef)context
{
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, image);
}


#pragma mark -
#pragma mark Public Methods

- (void) drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    if (!_image || CGRectIsEmpty(rect)) return;
    CGContextRef context = XUIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, alpha);

    CGRect imageRect = { CGPointZero, [self size] };
    CGImageRef cgImage = [_image CGImageForProposedRect:&imageRect context:[NSGraphicsContext currentContext] hints:nil];
    [self _drawImage:cgImage rect:rect context:context];

    CGContextRestoreGState(context);
}


- (void) drawInRect:(CGRect)rect
{
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
}


- (void) drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGSize size = [self size];
    CGRect rect = { point, size };
    [self drawInRect:rect blendMode:blendMode alpha:alpha];
}


- (void) drawAtPoint:(CGPoint)point
{
    [self drawAtPoint:point blendMode:kCGBlendModeNormal alpha:1.0];
}


- (void) drawAsPatternInRect:(CGRect)rect
{
    CGContextRef context = XUIGraphicsGetCurrentContext();

    CGContextSaveGState(context);

    [[NSColor colorWithPatternImage:_image] setFill];
    CGContextFillRect(context, rect);

    CGContextRestoreGState(context);
}


- (XUIImage *) stretchableImageWithLeftCapWidth:(NSInteger)left topCapHeight:(NSInteger)top
{
    const CGSize size = [self size];
    
    CGFloat bottom = size.height - (top  + 1);
    CGFloat right  = size.width  - (left + 1);
    XUIEdgeInsets capInsets = XUIEdgeInsetsMake(top, left, bottom, right);

    XUIResizableImage *result = [[XUIResizableImage alloc] _initWithNSImage:_image scale:_explicitScale orientation:XUIImageOrientationUp];
    [result setCapInsets:capInsets];
    
    return result;
}


- (XUIImage *) resizableImageWithCapInsets:(XUIEdgeInsets)capInsets
{
    XUIResizableImage *result = [[XUIResizableImage alloc] _initWithNSImage:_image scale:_explicitScale orientation:XUIImageOrientationUp];
    [result setCapInsets:capInsets];
    return result;
}


- (XUIImage *) resizableImageWithCapInsets:(XUIEdgeInsets)capInsets resizingMode:(XUIImageResizingMode)resizingMode
{
    XUIResizableImage *result = [[XUIResizableImage alloc] _initWithNSImage:_image scale:_explicitScale orientation:XUIImageOrientationUp];
    [result setCapInsets:capInsets];
    [result setResizingMode:resizingMode];
    return result;
}


- (XUIImage *) imageWithAlignmentRectInsets:(XUIEdgeInsets)alignmentInsets
{
    //!i: IMPLEMENT
    return nil;
}


#pragma mark -
#pragma mark Accessors

- (NSImage *) NSImage
{
    return _image;
}


- (CGSize) size
{
    return [_image size];
}


- (XUIEdgeInsets) capInsets
{
    return XUIEdgeInsetsZero;
}


- (NSInteger) leftCapWidth
{
    return [self capInsets].left;
}


- (NSInteger) topCapHeight
{
    return [self capInsets].top;
}


- (CGFloat) scale
{
    if (_explicitScale) {
        return _explicitScale;
    } else {
        return [[NSScreen mainScreen] backingScaleFactor];
    }
}


- (CGImageRef) CGImage
{
    NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
    NSRect imageRect = { NSZeroPoint, [self size] };

    return [_image CGImageForProposedRect:&imageRect context:currentContext hints:nil];
}


@end


static NSData *sGetRepresentation(XUIImage *image, NSBitmapImageFileType fileType, NSDictionary *properties)
{
    NSImage *nsImage = [image NSImage];
    
    NSRect imageRect = { NSZeroPoint, [image size] };
    NSImageRep *representation = [nsImage bestRepresentationForRect:imageRect context:nil hints:nil];

    if ([representation isKindOfClass:[NSBitmapImageRep class]]) {
        return [(NSBitmapImageRep *)representation representationUsingType:fileType properties:properties];
    }
    
    return nil;
}


NSData *XUIImageJPEGRepresentation(XUIImage *image, CGFloat compressionQuality)
{
    NSNumber *compressionQualityNumber = [NSNumber numberWithDouble:compressionQuality];
    NSDictionary *properties = [NSDictionary dictionaryWithObject:compressionQualityNumber forKey:NSImageCompressionFactor];
    return sGetRepresentation(image, NSJPEGFileType, properties);
}


NSData *XUIImagePNGRepresentation(XUIImage *image)
{
    return sGetRepresentation(image, NSPNGFileType, nil);
}
#endif


