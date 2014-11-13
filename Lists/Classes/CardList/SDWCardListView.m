//
//  SDWCardListView.m
//  Lists
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "PulseView.h"
#import "SDWAppSettings.h"
#import "SDWCardListView.h"
#import "NSColor+Util.h"


@implementation SDWCardListView

#pragma mark - Properties

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//
//        NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(3, self.bounds.size.height/2-6/2, 6, 6)];
//        [[NSColor lightGrayColor] setFill];
//        [[NSColor grayColor] setStroke];
//        [ovalPath fill];
//        [ovalPath stroke];
//}

- (void)setSelected:(BOOL)selected
{

    if (selected) {

        self.fillColor = [SharedSettings appSelectionColor];
    }
    else {

        self.fillColor = [NSColor whiteColor];
    }
}

- (void)awakeFromNib {

  [self setTranslatesAutoresizingMaskIntoConstraints:NO];

   // NSView *box = self.textField;


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
