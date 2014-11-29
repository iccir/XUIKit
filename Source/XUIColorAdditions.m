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

#import <XUIKit/XUIColorAdditions.h>
#import <objc/runtime.h>

#define INIT_METHOD __attribute__((objc_method_family(init)))


#pragma mark - NSColor

@implementation NSColor (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSColor class];
    
    XUISwizzleMethod(cls, '+', @selector(xui_colorWithCIColor:), @selector(colorWithCIColor:));

    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_8) {
        XUIAliasMethod(cls, '+', @selector(xui_colorWithWhite:alpha:),                     @selector(colorWithWhite:alpha:));
        XUIAliasMethod(cls, '+', @selector(xui_colorWithRed:green:blue:alpha:),            @selector(colorWithRed:green:blue:alpha:));
        XUIAliasMethod(cls, '+', @selector(xui_colorWithHue:saturation:brightness:alpha:), @selector(colorWithHue:saturation:brightness:alpha:));
    }

    XUIAliasMethod(cls, '-', @selector(xui_initWithWhite:alpha:),                      @selector(initWithWhite:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_initWithHue:saturation:brightness:alpha:),  @selector(initWithHue:saturation:brightness:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_initWithRed:green:blue:alpha:),             @selector(initWithRed:green:blue:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_initWithCGColor:),                          @selector(initWithCGColor:));
    XUIAliasMethod(cls, '-', @selector(xui_initWithPatternImage:),                     @selector(initWithPatternImage:));
    XUIAliasMethod(cls, '-', @selector(xui_initWithCIColor:),                          @selector(initWithCIColor:));
    XUIAliasMethod(cls, '-', @selector(xui_CIColor),                                   @selector(CIColor));
}


+ (NSColor *) xui_colorWithCIColor:(CIColor *)color
{
    NSColor *result = [self xui_colorWithCIColor:color];
    objc_setAssociatedObject(result, "XUIKit_CIColor", color, OBJC_ASSOCIATION_RETAIN);
    return result;
}


+ (NSColor *) xui_colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha
{
    return [NSColor colorWithGenericGamma22White:white alpha:alpha];
}


+ (NSColor *) xui_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha];
}


+ (NSColor *) xui_colorWithHue: (CGFloat) hue
                    saturation: (CGFloat) saturation
                    brightness: (CGFloat) brightness
                         alpha: (CGFloat) alpha
{
    float r = 0.0;
    float g = 0.0;
    float b = 0.0;

    if (saturation == 0.0) {
        r = g = b = brightness;

    } else {
        if (hue >= 1.0) hue -= 1.0;

        float sectorAsFloat = hue * 6;
        int   sectorAsInt   = (int)(sectorAsFloat);

        float f = sectorAsFloat - sectorAsInt;			// factorial part of h
        float p = brightness * ( 1 - saturation );
        float q = brightness * ( 1 - saturation * f );
        float t = brightness * ( 1 - saturation * ( 1 - f ) );
        float v = brightness;

        switch (sectorAsInt) {
        case 0:  r = v; g = t; b = p;  break;
        case 1:  r = q; g = v; b = p;  break;
        case 2:  r = p; g = v; b = t;  break;
        case 3:  r = p; g = q; b = v;  break;
        case 4:  r = t; g = p; b = v;  break;
        case 5:  r = v; g = p; b = q;  break;
        }
    }

    return [NSColor colorWithSRGBRed:r green:g blue:b alpha:alpha];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"

- (id) xui_initWithWhite:(CGFloat)white alpha:(CGFloat)alpha INIT_METHOD
{
    self = [NSColor colorWithWhite:white alpha:alpha];
    return self;
}


- (id) xui_initWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha INIT_METHOD;
{
    self = [NSColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    return self;
}


- (id) xui_initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha INIT_METHOD
{
    self = [NSColor colorWithRed:red green:green blue:blue alpha:alpha];
    return self;
}


- (id) xui_initWithCGColor:(CGColorRef)ref INIT_METHOD
{
    self = [NSColor colorWithCGColor:ref];
    return self;
}


- (id) xui_initWithPatternImage:(NSImage *)patternImage INIT_METHOD
{
    self = [NSColor colorWithPatternImage:patternImage];
    return self;
}


- (id) xui_initWithCIColor:(CIColor *)ciColor INIT_METHOD
{
    self = [NSColor colorWithCIColor:ciColor];
    return self;
}

#pragma clang diagnostic pop


- (CIColor *) xui_CIColor
{
    CIColor *result = objc_getAssociatedObject(self, "XUIKit_CIColor");
    return result;
}


@end

