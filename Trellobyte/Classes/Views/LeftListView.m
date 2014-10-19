//
//  LeftListView.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "LeftListView.h"

@implementation LeftListView

- (void)awakeFromNib {

    [self setAlphaValue:0.2];
}

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:

    NSColor *color = [LeftListView colorWithHexColorString:@"afcddc"];
    [color  setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

+ (NSColor*)colorWithHexColorString:(NSString*)inColorString
{
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits

    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end
