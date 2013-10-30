/*
    XUITypes.h
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


typedef NS_OPTIONS(NSUInteger, XUIRectCorner) {
    XUIRectCornerTopLeft     = 1 << 0,
    XUIRectCornerTopRight    = 1 << 1,
    XUIRectCornerBottomLeft  = 1 << 2,
    XUIRectCornerBottomRight = 1 << 3,
    XUIRectCornerAllCorners  = ~0
};


typedef NS_ENUM(NSInteger, XUIViewContentMode) {
    XUIViewContentModeScaleToFill,
    XUIViewContentModeScaleAspectFit,
    XUIViewContentModeScaleAspectFill,
    XUIViewContentModeRedraw,
    XUIViewContentModeCenter,
    XUIViewContentModeTop,
    XUIViewContentModeBottom,
    XUIViewContentModeLeft,
    XUIViewContentModeRight,
    XUIViewContentModeTopLeft,
    XUIViewContentModeTopRight,
    XUIViewContentModeBottomLeft,
    XUIViewContentModeBottomRight,
};


typedef NS_ENUM(NSInteger, XUIViewAnimationCurve) {
    XUIViewAnimationCurveEaseInOut,
    XUIViewAnimationCurveEaseIn,
    XUIViewAnimationCurveEaseOut,
    XUIViewAnimationCurveLinear
};


typedef NS_ENUM(NSInteger, XUIViewAnimationTransition) {
    XUIViewAnimationTransitionNone,
    XUIViewAnimationTransitionFlipFromLeft,
    XUIViewAnimationTransitionFlipFromRight,
    XUIViewAnimationTransitionCurlUp,
    XUIViewAnimationTransitionCurlDown,
    XUIViewAnimationTransitionCrossDissolve,
    XUIViewAnimationTransitionFlipFromTop,
    XUIViewAnimationTransitionFlipFromBottom
};


typedef NS_OPTIONS(NSInteger, XUIViewAnimationOptions) {
    XUIViewAnimationOptionLayoutSubviews            = 1 <<  0,
    XUIViewAnimationOptionAllowUserInteraction      = 1 <<  1,
    XUIViewAnimationOptionBeginFromCurrentState     = 1 <<  2,
    XUIViewAnimationOptionRepeat                    = 1 <<  3,
    XUIViewAnimationOptionAutoreverse               = 1 <<  4,
    XUIViewAnimationOptionOverrideInheritedDuration = 1 <<  5,
    XUIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6,
    XUIViewAnimationOptionAllowAnimatedContent      = 1 <<  7,
    XUIViewAnimationOptionShowHideTransitionViews   = 1 <<  8,
    
    XUIViewAnimationOptionCurveEaseInOut            = 0 << 16,
    XUIViewAnimationOptionCurveEaseIn               = 1 << 16,
    XUIViewAnimationOptionCurveEaseOut              = 2 << 16,
    XUIViewAnimationOptionCurveLinear               = 3 << 16,
    
    XUIViewAnimationOptionTransitionNone            = 0 << 20,		// not currently supported
    XUIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,		// not currently supported
    XUIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,		// not currently supported
    XUIViewAnimationOptionTransitionCurlUp          = 3 << 20,		// not currently supported
    XUIViewAnimationOptionTransitionCurlDown        = 4 << 20,		// not currently supported
    XUIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,       // not currently supported
    XUIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,       // not currently supported
    XUIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,       // not currently supported
};


typedef NS_ENUM(NSInteger, XUIImageOrientation) {
    XUIImageOrientationUp,
};

