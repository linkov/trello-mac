//
//  SDWCardDetailsTextView.m
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+AppColors.h"
#import "SDWCardDetailsTextView.h"

@implementation SDWCardDetailsTextView

- (void)awakeFromNib {
    self.textColor = [NSColor appBleakWhiteColor];
    self.backgroundColor = [NSColor clearColor];
    self.font = [NSFont systemFontOfSize:12];
}

@end
