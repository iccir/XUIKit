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

#import <Cocoa/Cocoa.h>
#import <XUIKit/XUIBase.h>

@class NSImage;


XUIKIT_EXTERN CGContextRef XUIGraphicsGetCurrentContext(void);
XUIKIT_EXTERN void XUIGraphicsPushContext(CGContextRef context);
XUIKIT_EXTERN void XUIGraphicsPopContext(void);

XUIKIT_EXTERN void XUIRectFillUsingBlendMode(CGRect rect, CGBlendMode blendMode);
XUIKIT_EXTERN void XUIRectFill(CGRect rect);

XUIKIT_EXTERN void XUIRectFrameUsingBlendMode(CGRect rect, CGBlendMode blendMode);
XUIKIT_EXTERN void XUIRectFrame(CGRect rect);

XUIKIT_EXTERN void XUIRectClip(CGRect rect);


// Image context
//
XUIKIT_EXTERN void XUIGraphicsBeginImageContext(CGSize size);
XUIKIT_EXTERN void XUIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
XUIKIT_EXTERN NSImage *XUIGraphicsGetImageFromCurrentImageContext(void);
XUIKIT_EXTERN void XUIGraphicsEndImageContext(void);
