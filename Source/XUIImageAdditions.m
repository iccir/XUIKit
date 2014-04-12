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

#define INIT_METHOD __attribute__((objc_method_family(init)))

@implementation NSImage (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSImage class];

    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_8) {
        XUIAliasMethod(cls, '-', @selector(xui_drawInRect:), @selector(drawInRect:));
    }

    XUIAliasMethod(cls, '+', @selector(xui_imageWithCGImage:scale:orientation:), @selector(imageWithCGImage:scale:orientation:));
    XUIAliasMethod(cls, '-', @selector(xui_initWithCGImage:scale:orientation:),  @selector(initWithCGImage:scale:orientation:));
}


+ (instancetype) xui_imageWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation
{
    return [[self alloc] initWithCGImage:cgImage scale:scale orientation:orientation];
}


- (id) xui_initWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation INIT_METHOD
{
    if (!cgImage) {
        self = nil;
        return nil;
    }
    
    if (!scale) scale = 1;

    NSSize size = NSMakeSize(
        CGImageGetWidth(cgImage)  / scale,
        CGImageGetHeight(cgImage) / scale
    );
    

    if ((self = [self initWithSize:size])) {
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
        [self addRepresentation:rep];
    }

    return self;
}


- (void) xui_drawInRect:(CGRect)rect
{
    [self drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
}


@end
