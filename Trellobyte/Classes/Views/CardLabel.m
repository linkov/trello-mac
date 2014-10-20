//
//  CardLabel.m
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "CardLabel.h"

@implementation CardLabel

- (void)awakeFromNib {

    self.cornerRadius = 4;
   // self.fillColor =
}


- (void)setTitle:(NSString *)aString {

    self.fillColor = self.borderColor = [self colorForString:aString];
    [self setNeedsLayout:YES];

}


- (NSColor *)colorForString:(NSString *)str {

    if ([str isEqualToString:@"green"]) {
        return [NSColor greenColor];
    }
    else if ([str isEqualToString:@"blue"]) {

        return [NSColor blueColor];
    }
    else if ([str isEqualToString:@"red"]) {

        return [NSColor redColor];
    }

    return [NSColor whiteColor];
}

@end
