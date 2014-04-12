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

#import <XUIKit/XUIGeometry.h>

#define kXUIEdgeInsetsFormat     "{%lf, %lf, %lf, %lf}"
#define kXUIOffsetFormat         "{%lf, %lf}"
#define kCGAffineTransformFormat "[%lf, %lf, %lf, %lf, %lf, %lf]"

const XUIEdgeInsets XUIEdgeInsetsZero = { 0 };
const XUIOffset XUIOffsetZero = { 0 };


CGPoint XUI_CGPointFromString(NSString *string)
{
    return NSPointToCGPoint(NSPointFromString(string));
}


CGSize XUI_CGSizeFromString(NSString *string)
{
    return NSSizeToCGSize(NSSizeFromString(string));
}


CGRect XUI_CGRectFromString(NSString *string)
{
    return NSRectToCGRect(NSRectFromString(string));
}


CGAffineTransform XUI_CGAffineTransformFromString(NSString *string)
{
    CGAffineTransform result = CGAffineTransformIdentity;
    if (string) sscanf([string UTF8String], kCGAffineTransformFormat, &result.a, &result.b, &result.c, &result.d, &result.tx, &result.ty);
    return result;
}


XUIEdgeInsets XUIEdgeInsetsFromString(NSString *string)
{
    XUIEdgeInsets result = XUIEdgeInsetsZero;
    if (string) sscanf([string UTF8String], kXUIEdgeInsetsFormat, &result.top, &result.left, &result.bottom, &result.right);
    return result;
}


XUIOffset XUIOffsetFromString(NSString *string)
{
    XUIOffset result = XUIOffsetZero;
    if (string) sscanf([string UTF8String], kXUIOffsetFormat, &result.horizontal, &result.vertical);
    return result;
}


NSString *XUI_NSStringFromCGPoint(CGPoint point)
{
    return NSStringFromPoint(NSPointFromCGPoint(point));
}


NSString *XUI_NSStringFromCGSize(CGSize size)
{
    return NSStringFromSize(NSSizeFromCGSize(size));
}


NSString *XUI_NSStringFromCGRect(CGRect rect)
{
    return NSStringFromRect(NSRectFromCGRect(rect));
}


NSString *XUI_NSStringFromCGAffineTransform(CGAffineTransform transform)
{
    return [NSString stringWithFormat:@kCGAffineTransformFormat, transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty];
}


NSString *XUI_NSStringFromXUIEdgeInsets(XUIEdgeInsets insets)
{
    return [NSString stringWithFormat:@kXUIEdgeInsetsFormat, (double)insets.top, (double)insets.left, (double)insets.bottom, (double)insets.right];
}


NSString *XUI_NSStringFromXUIOffset(XUIOffset offset)
{
    return [NSString stringWithFormat:@kXUIOffsetFormat, offset.horizontal, offset.vertical];
}

