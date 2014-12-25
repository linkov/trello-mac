//
//  NSImage+Util.h
//  Trellobyte
//
//  Created by alex on 10/25/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Util)

+ (NSImage *)imageFromBezierPath:(NSBezierPath *)path color:(NSColor *)color;
+ (NSImage *)imageWithCIImage:(CIImage *)i;
- (NSImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (NSImage *)imageTintedWithColor:(NSColor *)tint;

- (NSImage *)grayscaleImageWithAlphaValue:(CGFloat)alphaValue
                          saturationValue:(CGFloat)saturationValue
                          brightnessValue:(CGFloat)brightnessValue
                            contrastValue:(CGFloat)contrastValue;

@end
