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

#import <XUIKit/XUIViewAdditions.h>


@implementation NSView (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSView class];

    XUIAliasMethod(cls, '-', @selector(xui_bringSubviewToFront:),                       @selector(bringSubviewToFront:));
    XUIAliasMethod(cls, '-', @selector(xui_sendSubviewToBack:),                         @selector(sendSubviewToBack:));
    XUIAliasMethod(cls, '-', @selector(xui_insertSubview:atIndex:),                     @selector(insertSubview:atIndex:));
    XUIAliasMethod(cls, '-', @selector(xui_insertSubview:belowSubview:),                @selector(insertSubview:belowSubview:));
    XUIAliasMethod(cls, '-', @selector(xui_insertSubview:aboveSubview:),                @selector(insertSubview:aboveSubview:));
    XUIAliasMethod(cls, '-', @selector(xui_exchangeSubviewAtIndex:withSubviewAtIndex:), @selector(exchangeSubviewAtIndex:withSubviewAtIndex:));
    XUIAliasMethod(cls, '-', @selector(xui_isDescendantOfView:),                        @selector(isDescendantOfView:));
    XUIAliasMethod(cls, '-', @selector(xui_setNeedsDisplay),                            @selector(setNeedsDisplay));
    XUIAliasMethod(cls, '-', @selector(xui_setNeedsLayout),                             @selector(setNeedsLayout));
}


- (void) xui_bringSubviewToFront:(NSView *)view
{
    [view removeFromSuperview];
    [self addSubview:view];  
}


- (void) xui_sendSubviewToBack:(NSView *)view
{
    [view removeFromSuperview];
    
    NSArray *subviews = [self subviews];
    if ([subviews count]) {
        NSView *firstSubview = [subviews objectAtIndex:0];
        [self addSubview:view positioned:NSWindowBelow relativeTo:firstSubview];
    } else {
        [self addSubview:view];
    }
}


- (void) xui_insertSubview:(NSView *)view atIndex:(NSInteger)index
{
    [view removeFromSuperview];
    
    NSMutableArray *subviews = [[self subviews] mutableCopy];
    [subviews insertObject:view atIndex:index];
    [self setSubviews:subviews];
}


- (void) xui_insertSubview:(NSView *)view belowSubview:(NSView *)siblingSubview
{
    [self addSubview:view positioned:NSWindowBelow relativeTo:siblingSubview];
}


- (void) xui_insertSubview:(NSView *)view aboveSubview:(NSView *)siblingSubview
{
    [self addSubview:view positioned:NSWindowAbove relativeTo:siblingSubview];
}


- (void) xui_exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    NSMutableArray *subviews = [[self subviews] mutableCopy];
    [subviews exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    [self setSubviews:subviews];
}


- (BOOL) xui_isDescendantOfView:(NSView *)view
{
    return [self isDescendantOf:view];
}


- (void) xui_setNeedsDisplay
{
    [self setNeedsDisplay:YES];
}


- (void) xui_setNeedsLayout
{
    [self setNeedsLayout:YES];
}

@end

