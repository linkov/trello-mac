/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                A \c CALayer subclass that draws a check box within its layer. This is shared between ListerKit and ListerKitOSX to draw their respective \c AAPLCheckBox controls.
            
*/
#import <Cocoa/Cocoa.h>
#import "AAPLCheckBoxLayer.h"
#import "SDWAppSettings.h"

@implementation AAPLCheckBoxLayer
@synthesize tintColor = _tintColor;
@synthesize checked = _checked;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([@[@"tintColor", @"checked", @"strokeFactor", @"insetFactor", @"markInsetFactor"] containsObject:key]) {
        return YES;
    }

    return [super needsDisplayForKey:key];
}

- (instancetype)init {

    self = [super init];
    
    if (self) {
        CGFloat components[] = {0.5, 0.5, 0.5};
        _tintColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), components);
        
        _strokeFactor = 0.07;
        _insetFactor = 0.17;
        _markInsetFactor = 0.34;
    }

    return self;
}

- (void)drawInContext:(CGContextRef)context {
    [super drawInContext:context];

    const CGFloat size = MIN(self.bounds.size.width, self.bounds.size.height);

    CGAffineTransform transform = self.affineTransform;
    
    CGFloat xTranslate = 0;
    CGFloat yTranslate = 0;
    
    if (self.bounds.size.width < self.bounds.size.height) {
        yTranslate = (self.bounds.size.height - size)/2.f;
    }
    else {
        xTranslate = (self.bounds.size.width - size)/2.f;
    }
    transform = CGAffineTransformTranslate(transform, xTranslate, yTranslate);
    
    const CGFloat strokeWidth = self.strokeFactor * size;
    const CGFloat checkBoxInset = self.insetFactor * size;
    
    // Create the outer border for the check box.
    CGFloat outerDimension = size - 2.0 * checkBoxInset;
    CGRect checkBoxRect = CGRectMake(checkBoxInset, checkBoxInset, outerDimension, outerDimension);
    checkBoxRect = CGRectApplyAffineTransform(checkBoxRect, transform);

    // Make the desired width of the outer box.
    CGContextSetLineWidth(context, strokeWidth);
    // Set the tint color of the outer box.


    if (self.isChecked) {
        CGContextSetStrokeColorWithColor(context, [SharedSettings.appAccentDarkColor colorWithAlphaComponent:0.2].CGColor);

    } else {

        CGContextSetStrokeColorWithColor(context, [SharedSettings.appAccentDarkColor colorWithAlphaComponent:0.2].CGColor);
    }
    
    // Draw the outer box.
    CGContextStrokeRect(context, checkBoxRect);
    
    // Draw the inner box if it's checked.
    if (self.isChecked) {
        const CGFloat markInset = self.markInsetFactor * size;

        const CGFloat markDimension = size - 2.0 * markInset;
        CGRect markRect = CGRectMake(markInset, markInset, markDimension, markDimension);
        markRect = CGRectApplyAffineTransform(markRect, transform);

        CGContextTranslateCTM(context, 0.0f, markDimension);
        CGContextScaleCTM(context, 1.0f, -1.0f);

        CGContextMoveToPoint(context,9.5, -3.62);
        CGContextAddLineToPoint(context,11.21, -5.5);
        CGContextAddLineToPoint(context,13.5, -0.5);
        CGContextSetStrokeColorWithColor(context, [SharedSettings.appAccentDarkColor colorWithAlphaComponent:0.2].CGColor);

        CGContextStrokePath(context);

        //CGContextSetFillColorWithColor(context, SharedSettings.appBleakWhiteColor.CGColor);
        //CGContextFillRect(context, markRect);
    }
}

- (void)setTintColor:(CGColorRef)tintColor {
    if (!CGColorEqualToColor(_tintColor, tintColor)) {
        _tintColor = tintColor;
        
        [self setNeedsDisplay];
    }
}

- (CGColorRef)tintColor {
    return _tintColor;
}

- (void)setChecked:(BOOL)checked {
    if (_checked != checked) {
        _checked = checked;
        
        [self setNeedsDisplay];
    }
}

- (BOOL)isChecked {
    return _checked;
}

@end
