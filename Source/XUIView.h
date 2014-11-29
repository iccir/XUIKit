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
#import <XUIKit/XUIGeometry.h>
#import <AppKit/NSView.h>


@class CALayer;


@interface XUIView : NSView

// If nil (the default), uses an NSView layer-backed layer.
// If specified, uses the class as a layer-hosted layer.
+ (Class) layerClass;

- (id) initWithFrame:(CGRect)frame;

- (CGSize) sizeThatFits:(CGSize)size;
- (void) sizeToFit;

- (void) willMoveToSuperview:(NSView *)newSuperview;
- (void) didMoveToSuperview;

- (void) willMoveToWindow:(NSWindow *)newWindow;
- (void) didMoveToWindow;

- (void) layoutIfNeeded;
- (void) layoutSubviews;

@property (atomic, readwrite) NSInteger tag;

@property (nonatomic)       CGPoint            center;
@property (nonatomic)       CGAffineTransform  transform;
@property (nonatomic)       BOOL               clipsToBounds;
@property (nonatomic, copy) NSColor           *backgroundColor;
@property (nonatomic)       CGFloat            alpha;
@property (nonatomic)       CGRect             contentStretch;
@property (nonatomic)       CGFloat            contentScaleFactor;

// Defaults to YES
@property (atomic, readwrite, getter=isFlipped) BOOL flipped;

@end

