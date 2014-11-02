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

- (void)awakeFromNib {

  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
 //   NSView *box = self.textField;


//    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:240];
//
//    [self addConstraint:layout];

}

-(IBAction)setCRRR:(id)sender {

    
}

- (void)expand {
//
//
//    [self addConstraints:self.constr];
//    [self setNeedsUpdateConstraints:YES];
//    [self updateConstraintsForSubtreeIfNeeded];
}

@end
