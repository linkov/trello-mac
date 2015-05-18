//
//  SDWCardDetailBox.m
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+AppColors.h"
#import "SDWCardDetailBox.h"

@implementation SDWCardDetailBox

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Drawing code here.
}

- (void)awakeFromNib {
    self.fillColor = [NSColor appBackgroundColor];
    self.cornerRadius = 1.5;
    self.borderColor = [NSColor appHighlightColor];
    self.borderWidth = 0;
}

@end
