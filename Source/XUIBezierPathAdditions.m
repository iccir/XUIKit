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

#import <XUIKit/XUIBezierPathAdditions.h>

#import <objc/objc-runtime.h>


@implementation NSBezierPath (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSBezierPath class];
    
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithRoundedRect:cornerRadius:),                        @selector(bezierPathWithRoundedRect:cornerRadius:));
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:),       @selector(bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:));
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:),  @selector(bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:));
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithCGPath:),                                          @selector(bezierPathWithCGPath:));

    XUIAliasMethod(cls, '-', @selector(xui_addQuadCurveToPoint:controlPoint:),                              @selector(addQuadCurveToPoint:controlPoint:));
    XUIAliasMethod(cls, '-', @selector(xui_addArcWithCenter:radius:startAngle:endAngle:clockwise:),         @selector(addArcWithCenter:radius:startAngle:endAngle:clockwise:));
    XUIAliasMethod(cls, '-', @selector(xui_applyTransform:),                                                @selector(applyTransform:));
    XUIAliasMethod(cls, '-', @selector(xui_fillWithBlendMode:alpha:),                                       @selector(fillWithBlendMode:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_strokeWithBlendMode:alpha:),                                     @selector(strokeWithBlendMode:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_setCGPath:),                                                     @selector(setCGPath:));
    XUIAliasMethod(cls, '-', @selector(xui_setUsesEvenOddFillRule:),                                        @selector(setUsesEvenOddFillRule:));
    XUIAliasMethod(cls, '-', @selector(xui_usesEvenOddFillRule),                                            @selector(usesEvenOddFillRule));

    XUIAliasMethod(cls, '-', @selector(lineToPoint:),                                                       @selector(addLineToPoint:));
    XUIAliasMethod(cls, '-', @selector(curveToPoint:controlPoint1:controlPoint2:),                          @selector(addCurveToPoint:controlPoint1:controlPoint2:));
    XUIAliasMethod(cls, '-', @selector(appendBezierPath:),                                                  @selector(appendPath:));

    // -[NSBezierPath CGPath] is in 10.10, but as private API.  Avoid runtime warning.
    // <rdar://19094891> -[NSBezierPath CGPath] should be public API
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
        XUIAliasMethod(cls, '-', @selector(xui_CGPath), @selector(CGPath));
    }
}


+ (NSBezierPath *) xui_bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:cornerRadius yRadius:cornerRadius];
}


+ (NSBezierPath *) xui_bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(XUIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    const CGPoint topLeft = rect.origin;
    const CGPoint topRight = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    const CGPoint bottomRight = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    const CGPoint bottomLeft = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    if (corners & XUIRectCornerTopLeft) {
        CGPathMoveToPoint(path, NULL, topLeft.x+cornerRadii.width, topLeft.y);
    } else {
        CGPathMoveToPoint(path, NULL, topLeft.x, topLeft.y);
    }
    
    if (corners & XUIRectCornerTopRight) {
        CGPathAddLineToPoint(path, NULL, topRight.x-cornerRadii.width, topRight.y);
        CGPathAddCurveToPoint(path, NULL, topRight.x, topRight.y, topRight.x, topRight.y+cornerRadii.height, topRight.x, topRight.y+cornerRadii.height);
    } else {
        CGPathAddLineToPoint(path, NULL, topRight.x, topRight.y);
    }
    
    if (corners & XUIRectCornerBottomRight) {
        CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y-cornerRadii.height);
        CGPathAddCurveToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomRight.x-cornerRadii.width, bottomRight.y, bottomRight.x-cornerRadii.width, bottomRight.y);
    } else {
        CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y);
    }
    
    if (corners & XUIRectCornerBottomLeft) {
        CGPathAddLineToPoint(path, NULL, bottomLeft.x+cornerRadii.width, bottomLeft.y);
        CGPathAddCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y, bottomLeft.x, bottomLeft.y-cornerRadii.height, bottomLeft.x, bottomLeft.y-cornerRadii.height);
    } else {
        CGPathAddLineToPoint(path, NULL, bottomLeft.x, bottomLeft.y);
    }
    
    if (corners & XUIRectCornerTopLeft) {
        CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y+cornerRadii.height);
        CGPathAddCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x+cornerRadii.width, topLeft.y, topLeft.x+cornerRadii.width, topLeft.y);
    } else {
        CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y);
    }
    
    CGPathCloseSubpath(path);

    NSBezierPath *result = [NSBezierPath bezierPath];
    [result setCGPath:path];
    CGPathRelease(path);
    
    return result;
}


+ (NSBezierPath *) xui_bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return path;
}


+ (NSBezierPath *) xui_bezierPathWithCGPath:(CGPathRef)inPath
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setCGPath:inPath];
    return path;
}


- (void) xui_addQuadCurveToPoint:(CGPoint)QP2 controlPoint:(CGPoint)QP1
{
    // See http://fontforge.sourceforge.net/bezier.html

    CGPoint QP0 = [self currentPoint];
    CGPoint CP3 = QP2;

    CGPoint CP1 = CGPointMake(
    //  QP0   +   2   / 3    * (QP1   - QP0  )
        QP0.x + ((2.0 / 3.0) * (QP1.x - QP0.x)),
        QP0.y + ((2.0 / 3.0) * (QP1.y - QP0.y))
    );

    CGPoint CP2 = CGPointMake(
    //  QP2   +  2   / 3    * (QP1   - QP2)
        QP2.x + (2.0 / 3.0) * (QP1.x - QP2.x),
        QP2.y + (2.0 / 3.0) * (QP1.y - QP2.y)
    );
    
    [self curveToPoint:CP3 controlPoint1:CP1 controlPoint2:CP2];
}


- (void) xui_addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    [self appendBezierPathWithArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}


- (void) xui_applyTransform:(CGAffineTransform)transform
{
    NSAffineTransform *nsTransform = [NSAffineTransform transform];
    
    NSAffineTransformStruct transformStruct = {
        transform.a,  transform.b, transform.c, transform.d,
        transform.tx, transform.ty
    };
    
    [nsTransform setTransformStruct:transformStruct];
    [self transformUsingAffineTransform:nsTransform];
}


- (void) xui_fillWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);

    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, alpha);
    
    [self fill];
    
    CGContextRestoreGState(context);
}


- (void) xui_strokeWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);

    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, alpha);
    
    [self stroke];
    
    CGContextRestoreGState(context);
}


static void sPathApplier(void *info, const CGPathElement *element)
{
    NSBezierPath *path = (__bridge NSBezierPath *)info;

    switch (element->type) {
    case kCGPathElementMoveToPoint:
        [path moveToPoint:element->points[0]];
        break;

    case kCGPathElementAddLineToPoint:
        [path lineToPoint:element->points[0]];
        break;
    
    case kCGPathElementAddQuadCurveToPoint:
        [path addQuadCurveToPoint: element->points[1]
                     controlPoint: element->points[0]];

        break;
    
    case kCGPathElementAddCurveToPoint:
        [path curveToPoint: element->points[2]
             controlPoint1: element->points[0]
             controlPoint2: element->points[1]];
         
        break;

    case kCGPathElementCloseSubpath:
        [path closePath];
        break;
    }
}


- (void) xui_setCGPath:(CGPathRef)CGPath
{
    [self removeAllPoints];
    if (CGPathIsEmpty(CGPath)) return;

    CGPathApply(CGPath, (__bridge void *)self, sPathApplier);
}


- (CGPathRef) xui_CGPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    NSPoint p[3];
    BOOL closed = NO;

    NSInteger elementCount = [self elementCount];
    for (NSInteger i = 0; i < elementCount; i++) {
        switch ([self elementAtIndex:i associatedPoints:p]) {
        case NSMoveToBezierPathElement:
            CGPathMoveToPoint(path, NULL, p[0].x, p[0].y);
            break;

        case NSLineToBezierPathElement:
            CGPathAddLineToPoint(path, NULL, p[0].x, p[0].y);
            closed = NO;
            break;

        case NSCurveToBezierPathElement:
            CGPathAddCurveToPoint(path, NULL, p[0].x, p[0].y, p[1].x, p[1].y, p[2].x, p[2].y);
            closed = NO;
            break;

        case NSClosePathBezierPathElement:
            CGPathCloseSubpath(path);
            closed = YES;
            break;
        }
    }

    if (!closed)  CGPathCloseSubpath(path);

    CGPathRef immutablePath = CGPathCreateCopy(path);
    objc_setAssociatedObject(self, "XUIKit_CGPath", (__bridge id)immutablePath, OBJC_ASSOCIATION_RETAIN);
    CGPathRelease(immutablePath);
    
    CGPathRelease(path);
    
    return (__bridge CGPathRef)objc_getAssociatedObject(self, "XUIKit_CGPath");
}


- (void) xui_setUsesEvenOddFillRule:(BOOL)yn
{
    [self setWindingRule:yn ? NSEvenOddWindingRule : NSNonZeroWindingRule];
}


- (BOOL) xui_usesEvenOddFillRule
{
    return [self windingRule] == NSEvenOddWindingRule;
}


@end


@interface XUIBezierPath : NSBezierPath
@end


@implementation XUIBezierPath : NSBezierPath
- (CGPathRef) CGPath { return [self xui_CGPath]; }
@end

