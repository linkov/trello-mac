//
//  NSColor+AppColors.m
//  Lists
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "NSColor+AppColors.h"

@implementation NSColor (AppColors)

+ (NSColor *)appBackgroundColor {
    return [NSColor colorWithHexColorString:@"1E5676"];
}

+ (NSColor *)appSelectionColor {
    return [NSColor colorWithHexColorString:@"deeef4"];
}

+ (NSColor *)appHighlightGreenColor {
    return [NSColor colorWithHexColorString:@"1D8722"];
}

+ (NSColor *)appUIColor {
    return [NSColor colorWithHexColorString:@"4F778A"];
}

+ (NSColor *)appBleakWhiteColor {
    return [NSColor colorWithHexColorString:@"E8E8E8"];
}

+ (NSColor *)appHighlightColor {
    return [NSColor colorWithHexColorString:@"3E6378"];
}

+ (NSColor *)appBackgroundColorDark {
    return [NSColor colorWithCalibratedRed:0.096 green:0.265 blue:0.387 alpha:1.000];
}

@end
