# XUIKit

## Overview

## Category Additions

    XUIKit uses categories to make NSBezierPath, NSColor, NSFont completely API compatible with their UIKit counterparts.

### NSBezierPath

    +[NSBezierPath bezierPathWithRoundedRect:cornerRadius:]
    +[NSBezierPath bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:]
    +[NSBezierPath bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:]
    +[NSBezierPath bezierPathWithCGPath:]

    -[NSBezierPath addLineToPoint:]
    -[NSBezierPath addCurveToPoint:controlPoint1:controlPoint2:]
    -[NSBezierPath addQuadCurveToPoint:controlPoint:]
    -[NSBezierPath addArcWithCenter:radius:startAngle:endAngle:clockwise:]

    -[NSBezierPath appendPath:]
    -[NSBezierPath applyTransform:]

    -[NSBezierPath fillWithBlendMode:alpha:]
    -[NSBezierPath strokeWithBlendMode:alpha:]

    -[NSBezierPath setCGPath:]
    -[NSBezierPath CGPath]

    -[NSBezierPath setUsesEvenOddFillRule:]
    -[NSBezierPath usesEvenOddFillRule]

### NSColor

    +[NSColor colorWithCIColor:]
    +[NSColor colorWithWhite:alpha:]
    +[NSColor colorWithRed:green:blue:alpha:]
    +[NSColor colorWithHue:saturation:brightness:alpha:]

    -[NSColor initWithWhite:alpha:]
    -[NSColor initWithHue:saturation:brightness:alpha:]
    -[NSColor initWithRed:green:blue:alpha:]
    -[NSColor initWithCGColor:]
    -[NSColor initWithPatternImage:]
    -[NSColor initWithCIColor:]
    -[NSColor CIColor]
  
### NSFont

    +[NSFont familyNames]
    +[NSFont fontNamesForFamilyName:]
    +[NSFont italicSystemFontOfSize:]
    
    -[NSFont fontWithSize:]
    -[NSFont lineHeight]
    
### NSIndexPath

    +[NSIndexPath indexPathForRow:inSection:]
    -[NSIndexPath section]
    -[NSIndexPath row]

### NSValue

    +[NSValue valueWithCGPoint:]
    +[NSValue valueWithCGSize:]
    +[NSValue valueWithCGRect:]
    +[NSValue valueWithCGAffineTransform:]
    
    -[NSValue CGPointValue]
    -[NSValue CGSizeValue]
    -[NSValue CGRectValue]
    -[NSValue CGAffineTransformValue]


### NSView

    -[NSView bringSubviewToFront:(NSView *)view;
    -[NSView sendSubviewToBack:(NSView *)view;

    -[NSView insertSubview:atIndex:]
    -[NSView insertSubview:belowSubview:]
    -[NSView insertSubview:aboveSubview:]
    -[NSView exchangeSubviewAtIndex:withSubviewAtIndex:]
  
    -[NSView isDescendantOfView:]
  
    -[NSView setNeedsDisplay]
    -[NSView setNeedsLayout]
    

## Additional Classes

### XUIView

