//
//  SDWCardListView.m
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "SDWCardListView.h"

@implementation SDWCardListView

#pragma mark - Properties

- (void)setSelected:(BOOL)selected
{

    if (selected) {

        self.fillColor = [NSColor blueColor];
    }
    else {

        self.fillColor = [NSColor whiteColor];
    }
}


-(IBAction)setCRRR:(id)sender {

    
}

@end
