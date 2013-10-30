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

// We do not own the CG* or NS* namespaces, these need to be
// preprocessor defines in XUICompatibility
// 
XUIKIT_EXTERN CGPoint           XUI_CGPointFromString(NSString *string);
XUIKIT_EXTERN CGSize            XUI_CGSizeFromString(NSString *string);
XUIKIT_EXTERN CGRect            XUI_CGRectFromString(NSString *string);
XUIKIT_EXTERN CGAffineTransform XUI_CGAffineTransformFromString(NSString *string);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGPoint(CGPoint point);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGSize(CGSize size);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGRect(CGRect rect);
XUIKIT_EXTERN NSString         *XUI_NSStringFromCGAffineTransform(CGAffineTransform transform);
