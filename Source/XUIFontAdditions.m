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

#import <XUIKit/XUIFontAdditions.h>

#import <objc/objc-runtime.h>


@implementation NSFont (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSFont class];
    
    XUIAliasMethod(cls, '+', @selector(xui_familyNames),             @selector(familyNames));
    XUIAliasMethod(cls, '+', @selector(xui_fontNamesForFamilyName:), @selector(fontNamesForFamilyName:));
    XUIAliasMethod(cls, '+', @selector(xui_italicSystemFontOfSize:), @selector(italicSystemFontOfSize:));

    XUIAliasMethod(cls, '-', @selector(xui_lineHeight),              @selector(lineHeight));

    // -[NSFont fontWithSize:] is in 10.10, but as private API.  Avoid runtime warning.
    // <rdar://19094897> -[NSFont fontWithSize:] should be public API
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
        XUIAliasMethod(cls, '-', @selector(xui_fontWithSize:), @selector(fontWithSize:));
    }
}


+ (NSArray *) xui_familyNames
{
    return [[NSFontManager sharedFontManager] availableFontFamilies];
}


+ (NSArray *) xui_fontNamesForFamilyName:(NSString *)familyName
{
    NSArray *members = [[NSFontManager sharedFontManager] availableMembersOfFontFamily:familyName];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[members count]];
    
    for (NSArray *array in members) {
        if ([array isKindOfClass:[NSArray class]] && [array count]) {
            [result addObject:[array objectAtIndex:0]];
        }
    }

    return result;
}


+ (NSFont *) xui_italicSystemFontOfSize:(CGFloat)fontSize
{
    NSFont *normalFont = [NSFont systemFontOfSize:fontSize];
    return [[NSFontManager sharedFontManager] convertFont:normalFont toHaveTrait:NSItalicFontMask];
}


- (NSFont *) xui_fontWithSize:(CGFloat)fontSize
{
    return [NSFont fontWithName:[self fontName] size:fontSize];
}


- (CGFloat) xui_lineHeight
{
    // UIKit does the equivalent of:
    // return GSFontGetLineSpacing(_gsFont);
    //
    // Searching for GSFontGetLineSpacing() on Google leads to:
    // http://opensource.apple.com/source/WebCore/WebCore-1298/platform/graphics/mac/SimpleFontDataMac.mm
    //
    // which does the following: ( with CGFont...() renamed to CTFont...() )
    //
    CTFontRef ctFont    = (__bridge CTFontRef)self; // toll-free bridged
    CGFloat   pointSize = [self pointSize];

    int unitsPerEm = CTFontGetUnitsPerEm(ctFont);

    long ascent  = lroundf( (     CTFontGetAscent( ctFont)  /  unitsPerEm) * pointSize);
    long descent = lroundf(-(-abs(CTFontGetDescent(ctFont)) /  unitsPerEm) * pointSize);
    long lineGap = lroundf( (     CTFontGetLeading(ctFont)  /  unitsPerEm) * pointSize);
    
    return ascent + descent + lineGap;
}


@end


@interface XUIFont : NSFont
@end


@implementation XUIFont : NSFont
- (NSFont *) fontWithSize:(CGFloat)fontSize { return [self xui_fontWithSize:fontSize]; }
@end
