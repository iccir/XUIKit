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

#import <XUIKit/XUIView.h>

#import <XUIKit/XUIGeometry.h>
#import <XUIKit/XUIGraphics.h>

#import <XUIKit/XUIBase.h>

#import <QuartzCore/QuartzCore.h>

#import <objc/runtime.h>


/* Uncomment when implementing -[XUIView setContentMode:] and -[XUIView contentMode]

static const NSInteger sModeToPlacementMapCount = 12;

static const struct {
    XUIViewContentMode mode;
    NSViewLayerContentsPlacement placement;
} sModeToPlacementMap[sModeToPlacementMapCount] = {
    { XUIViewContentModeScaleToFill,     NSViewLayerContentsPlacementScaleAxesIndependently     },
    { XUIViewContentModeScaleAspectFit,  NSViewLayerContentsPlacementScaleProportionallyToFit  },
    { XUIViewContentModeScaleAspectFill, NSViewLayerContentsPlacementScaleProportionallyToFill },
    { XUIViewContentModeCenter,          NSViewLayerContentsPlacementCenter                    },
    { XUIViewContentModeTop,             NSViewLayerContentsPlacementTop                       },
    { XUIViewContentModeBottom,          NSViewLayerContentsPlacementBottom                    },
    { XUIViewContentModeLeft,            NSViewLayerContentsPlacementLeft                      },
    { XUIViewContentModeRight,           NSViewLayerContentsPlacementRight                     },
    { XUIViewContentModeTopLeft,         NSViewLayerContentsPlacementTopLeft                   },
    { XUIViewContentModeTopRight,        NSViewLayerContentsPlacementTopRight                  },
    { XUIViewContentModeBottomLeft,      NSViewLayerContentsPlacementBottomLeft                },
    { XUIViewContentModeBottomRight,     NSViewLayerContentsPlacementBottomRight               }
};
*/


@implementation XUIView {
    BOOL _implementsDrawRect;
}

@synthesize tag = _tag, flipped = _flipped;


static IMP sXUIView_drawRect = NULL;

+ (void) initialize
{
    if (self == [XUIView class]) {
        sXUIView_drawRect   = [self instanceMethodForSelector:@selector(drawRect:)];
    }
}


+ (Class) layerClass
{
    return nil;
}


#pragma mark -
#pragma mark Lifecycle / Superclass Overrides

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setFlipped:YES];

        IMP selfDrawRect = [[self class] instanceMethodForSelector:@selector(drawRect:)];
        _implementsDrawRect = (selfDrawRect != sXUIView_drawRect);
        [self setLayerContentsRedrawPolicy:[self _defaultLayerContentsRedrawPolicy]];
        
        Class layerClass = [[self class] layerClass];
        if (layerClass) {
            CALayer *layer = [[layerClass alloc] init];

            [layer setFrame:frame];
            [layer setDelegate:self];
            [layer setOpacity:1.0];
            [layer setOpaque:NO];

            [self setLayer:layer];
        }

        [self setWantsLayer:YES];

        if (_implementsDrawRect) {
            [[self layer] setNeedsDisplay];
        }
        
        [self setClipsToBounds:NO];
    }

    return self;
}


- (void) dealloc
{
    [[self layer] setDelegate:nil];
}


#pragma mark -
#pragma mark Private Methods

- (BOOL) wantsUpdateLayer
{
    return !_implementsDrawRect;
}


- (NSViewLayerContentsRedrawPolicy) _defaultLayerContentsRedrawPolicy
{
    if (_implementsDrawRect) {
        return NSViewLayerContentsRedrawOnSetNeedsDisplay;
    } else {
        return NSViewLayerContentsRedrawNever;
    }
}


#pragma mark -
#pragma mark Geometry

- (void) sizeToFit
{
    CGRect frame = [self frame];
    frame.size = [self sizeThatFits:frame.size];
    [self setFrame:frame];
}


- (CGSize) sizeThatFits:(CGSize)size
{
    return size;
}


#pragma mark -
#pragma mark Hierarchy

- (void) viewWillMoveToSuperview:(NSView *)newSuperview
{
    [self willMoveToSuperview:newSuperview];
    [super viewWillMoveToSuperview:newSuperview];
}
- (void) willMoveToSuperview:(NSView *)superview { }


- (void) viewDidMoveToSuperview
{
    [self didMoveToSuperview];
    [super viewDidMoveToSuperview];
}
- (void) didMoveToSuperview { }


- (void) viewWillMoveToWindow:(NSWindow *)newWindow
{
    [self willMoveToWindow:newWindow];
    [super viewWillMoveToWindow:newWindow];
}
- (void) willMoveToWindow:(NSWindow *)window { }


- (void) viewDidMoveToWindow
{
    [self didMoveToWindow];
    [super viewDidMoveToWindow];
}
- (void) didMoveToWindow { }



- (void) layout
{
    [self layoutSubviews];
    [super layout];
}
- (void) layoutSubviews { }


- (void) layoutIfNeeded
{
    [self layoutSubtreeIfNeeded];
}

- (void) drawRect:(CGRect)rect { }


#pragma mark - Accessors

@dynamic center, transform, contentStretch, clipsToBounds, alpha, contentScaleFactor;

- (void) setBackgroundColor:(NSColor *)backgroundColor
{
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        [[self layer] setBackgroundColor:[backgroundColor CGColor]];
    }
}

- (void) setCenter:(CGPoint)center                   { [[self layer] setPosition:center];               }
- (CGPoint) center                                   { return [[self layer] position];                  }
- (void) setTransform:(CGAffineTransform)transform   { [[self layer] setAffineTransform:transform];     }
- (CGAffineTransform) transform                      { return [[self layer] affineTransform];           }
- (void)    setContentStretch:(CGRect)contentStretch { [[self layer] setContentsCenter:contentStretch]; }
- (CGRect)  contentStretch                           { return [[self layer] contentsCenter];            }
- (void)    setClipsToBounds:(BOOL)clipsToBounds     { [[self layer] setMasksToBounds:clipsToBounds];   }
- (BOOL)    clipsToBounds                            { return [[self layer] masksToBounds];             }
- (void)    setAlpha:(CGFloat)alpha                  { [[self layer] setOpacity:alpha];                 }
- (CGFloat) alpha                                    { return [[self layer] opacity];                   }
- (void)    setContentScaleFactor:(CGFloat)scale     { [[self layer] setContentsScale:scale];           }
- (CGFloat) contentScaleFactor                       { return [[self layer] contentsScale];             }

- (void)    setAlphaValue:(CGFloat)alpha             { [[self layer] setOpacity:alpha];                 }
- (CGFloat) alphaValue                               { return [[self layer] opacity];                   }



@end

