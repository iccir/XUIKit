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

#import <XUIKit/XUITypes.h>
#import <Foundation/Foundation.h>


@class CIImage;

@interface NSImage (XUIKitAdditions)

+ (instancetype) imageWithContentsOfFile:(NSString *)path;
+ (instancetype) imageWithData:(NSData *)data;
+ (instancetype) imageWithData:(NSData *)data scale:(CGFloat)scale;
+ (instancetype) imageWithCGImage:(CGImageRef)cgImage;
+ (instancetype) imageWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation;
+ (instancetype) imageWithCIImage:(CIImage *)ciImage;
+ (instancetype) imageWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation;

- (id) initWithData:(NSData *)data scale:(CGFloat)scale;

- (id) initWithCGImage:(CGImageRef)cgImage;
- (id) initWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation;

- (id) initWithCIImage:(CIImage *)ciImage;
- (id) initWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(XUIImageOrientation)orientation;



@property (nonatomic, assign,    readonly) CGSize     size;
@property (nonatomic, /*strong*/ readonly) CGImageRef CGImage;
@property (nonatomic,            readonly) CIImage   *CIImage;
@property (nonatomic, assign,    readonly) CGFloat    scale;

- (void) drawAtPoint:(CGPoint)point;
- (void) drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void) drawInRect:(CGRect)rect;
- (void) drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

- (void) drawAsPatternInRect:(CGRect)rect;

@end
