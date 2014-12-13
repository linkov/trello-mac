//
//  SDWCardDetailsTextView.m
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCardDetailsTextView.h"

@implementation SDWCardDetailsTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    self.textColor = [NSColor whiteColor];
    self.backgroundColor = [SharedSettings appBackgroundColor];
    self.textContainerInset = CGSizeMake(4, 10);
    self.layer.cornerRadius = 2;

}

@end
