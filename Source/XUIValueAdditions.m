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

#import <XUIKit/XUIValueAdditions.h>


@implementation NSValue (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSValue class];
    
    XUIAliasMethod(cls, '+', @selector(xui_valueWithCGPoint:),           @selector(valueWithCGPoint:));
    XUIAliasMethod(cls, '+', @selector(xui_valueWithCGSize:),            @selector(valueWithCGSize:));
    XUIAliasMethod(cls, '+', @selector(xui_valueWithCGRect:),            @selector(valueWithCGRect:));
    XUIAliasMethod(cls, '+', @selector(xui_valueWithCGAffineTransform:), @selector(valueWithCGAffineTransform:));
    XUIAliasMethod(cls, '+', @selector(xui_valueWithXUIEdgeInsets:),     @selector(valueWithXUIEdgeInsets:));
    XUIAliasMethod(cls, '+', @selector(xui_valueWithXUIOffset:),         @selector(valueWithXUIOffset:));

    XUIAliasMethod(cls, '-', @selector(xui_CGPointValue),            @selector(CGPointValue));
    XUIAliasMethod(cls, '-', @selector(xui_CGSizeValue),             @selector(CGSizeValue));
    XUIAliasMethod(cls, '-', @selector(xui_CGRectValue),             @selector(CGRectValue));
    XUIAliasMethod(cls, '-', @selector(xui_CGAffineTransformValue),  @selector(CGAffineTransformValue));
    XUIAliasMethod(cls, '-', @selector(xui_XUIEdgeInsetsValue),      @selector(XUIEdgeInsetsValue));
    XUIAliasMethod(cls, '-', @selector(xui_XUIOffsetValue),          @selector(XUIOffsetValue));
}


+ (NSValue *) xui_valueWithCGPoint:(CGPoint)point
{
    return [NSValue valueWithPoint:NSPointFromCGPoint(point)];
}


+ (NSValue *) xui_valueWithCGSize:(CGSize)size
{
    return [NSValue valueWithSize:NSSizeFromCGSize(size)];
}


+ (NSValue *) xui_valueWithCGRect:(CGRect)rect
{
    return [NSValue valueWithRect:NSRectFromCGRect(rect)];
}


+ (NSValue *) xui_valueWithCGAffineTransform:(CGAffineTransform)transform
{
    return [NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)];
}


+ (NSValue *) xui_valueWithXUIEdgeInsets:(XUIEdgeInsets)insets
{
    return [NSValue valueWithBytes:&insets objCType:@encode(XUIEdgeInsets)];
}


+ (NSValue *) xui_valueWithXUIOffset:(XUIOffset)offset
{
    return [NSValue valueWithBytes:&offset objCType:@encode(XUIOffset)];
}


- (CGPoint) xui_CGPointValue
{
    return NSPointToCGPoint([self pointValue]);
}


- (CGSize) xui_CGSizeValue
{
    return NSSizeToCGSize([self sizeValue]);
}


- (CGRect) xui_CGRectValue
{
    return NSRectToCGRect([self rectValue]);
}


- (CGAffineTransform) xui_CGAffineTransformValue
{
    CGAffineTransform result = CGAffineTransformIdentity;

    if (strcmp([self objCType], @encode(CGAffineTransform)) == 0) {
        [self getValue:&result];
    }

    return result;
}


- (XUIEdgeInsets) xui_XUIEdgeInsetsValue
{
    XUIEdgeInsets result = XUIEdgeInsetsZero;

    if (strcmp([self objCType], @encode(XUIEdgeInsets)) == 0) {
        [self getValue:&result];
    }

    return result;
}


- (XUIOffset) xui_XUIOffsetValue
{
    XUIOffset result = XUIOffsetZero;

    if (strcmp([self objCType], @encode(XUIOffset)) == 0) {
        [self getValue:&result];
    }

    return result;
}


@end

