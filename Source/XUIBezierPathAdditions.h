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


@interface NSBezierPath (XUIKitAdditions)

+ (NSBezierPath *) bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (NSBezierPath *) bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(XUIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
+ (NSBezierPath *) bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
+ (NSBezierPath *) bezierPathWithCGPath:(CGPathRef)CGPath;

- (void) addLineToPoint:(CGPoint)point;
- (void) addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
- (void) addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;
- (void) addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void) appendPath:(NSBezierPath *)bezierPath;
- (void) applyTransform:(CGAffineTransform)transform;

- (void) fillWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void) strokeWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

@property (nonatomic) CGPathRef CGPath;
- (CGPathRef) CGPath NS_RETURNS_INNER_POINTER;

@property (nonatomic) BOOL usesEvenOddFillRule; // Default is NO. When YES, the even-odd fill rule is used for drawing, clipping, and hit testing.

@end
