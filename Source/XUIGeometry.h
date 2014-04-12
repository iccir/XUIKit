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

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>


// We do not own the CG* or NS* namespaces, use XUI_ prefix and
// use #defines to prevent future binary compatibility issues
// 
#define CGPointFromString             XUI_CGPointFromString
#define CGSizeFromString              XUI_CGSizeFromString
#define CGRectFromString              XUI_CGRectFromString
#define CGAffineTransformFromString   XUI_CGAffineTransformFromString

#define NSStringFromCGPoint           XUI_NSStringFromCGPoint
#define NSStringFromCGSize            XUI_NSStringFromCGSize
#define NSStringFromCGRect            XUI_NSStringFromCGRect
#define NSStringFromCGAffineTransform XUI_NSStringFromCGAffineTransform
#define NSStringFromXUIEdgeInsets     XUI_NSStringFromXUIEdgeInsets
#define NSStringFromXUIOffset         XUI_NSStringFromXUIOffset


typedef struct XUIEdgeInsets {
    CGFloat top, left, bottom, right;
} XUIEdgeInsets;

typedef struct XUIOffset {
    CGFloat horizontal, vertical;
} XUIOffset;


XUIKIT_STATIC_INLINE XUIEdgeInsets XUIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    XUIEdgeInsets insets = { top, left, bottom, right };
    return insets;
}


XUIKIT_STATIC_INLINE CGRect XUIEdgeInsetsInsetRect(CGRect rect, XUIEdgeInsets insets)
{
    rect.origin.x    += insets.left;
    rect.origin.y    += insets.top;
    rect.size.width  -= (insets.left + insets.right);
    rect.size.height -= (insets.top  + insets.bottom);
    return rect;
}


XUIKIT_STATIC_INLINE XUIOffset XUIOffsetMake(CGFloat horizontal, CGFloat vertical)
{
    XUIOffset offset = {horizontal, vertical};
    return offset;
}


XUIKIT_STATIC_INLINE BOOL XUIEdgeInsetsEqualToEdgeInsets(XUIEdgeInsets insets1, XUIEdgeInsets insets2)
{
    return insets1.left == insets2.left && insets1.top == insets2.top && insets1.right == insets2.right && insets1.bottom == insets2.bottom;
}

XUIKIT_STATIC_INLINE BOOL XUIOffsetEqualToOffset(XUIOffset offset1, XUIOffset offset2)
{
    return offset1.horizontal == offset2.horizontal && offset1.vertical == offset2.vertical;
}


XUIKIT_EXTERN const XUIEdgeInsets XUIEdgeInsetsZero;
XUIKIT_EXTERN const XUIOffset XUIOffsetZero;


XUIKIT_EXTERN CGPoint           XUI_CGPointFromString(NSString *string);
XUIKIT_EXTERN CGSize            XUI_CGSizeFromString(NSString *string);
XUIKIT_EXTERN CGRect            XUI_CGRectFromString(NSString *string);
XUIKIT_EXTERN CGAffineTransform XUI_CGAffineTransformFromString(NSString *string);
XUIKIT_EXTERN XUIEdgeInsets     XUIEdgeInsetsFromString(NSString *string);
XUIKIT_EXTERN XUIOffset         XUIOffsetFromString(NSString *string);

XUIKIT_EXTERN NSString         *XUI_NSStringFromCGPoint(CGPoint point);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGSize(CGSize size);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGRect(CGRect rect);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGAffineTransform(CGAffineTransform transform);
XUIKIT_EXTERN NSString         *XUI_NSStringFromXUIEdgeInsets(XUIEdgeInsets insets);
XUIKIT_EXTERN NSString         *XUI_NSStringFromXUIOffset(XUIOffset offset);

