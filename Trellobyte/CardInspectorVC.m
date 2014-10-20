//
//  CardInspectorVC.m
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "CardInnerViewVC.h"
#import "CardLabel.h"
#import "Card.h"
#import "CardInspectorVC.h"


@interface CardInspectorVC ()

@property (strong) NSView *innerView;

@end

@implementation CardInspectorVC

- (void)awakeFromNib {
//    [self.mainView setWantsLayer:YES];
//    NSColor *color = [NSColor greenColor];
//    [self.mainView setFillColor:color];
    //[self.mainView setNeedsLayout:YES];



}


- (void)setActiveCard:(Card *)activeCard {


    CardInnerViewVC* vc = [[CardInnerViewVC alloc] initWithNibName:@"CardInspector" bundle:nil];
    self.innerView = [vc view];
    // [self.innerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.innerView];

    self.labelsArray = vc.labelsArray;
    self.labelCollection = vc.labelsCollection;

    NSSize minSize = NSMakeSize(0,40);
    [self.labelCollection setMaxItemSize:minSize];

    [self setupConstraints];

    _activeCard = activeCard;
    NSLog(@"Inspecting %@",self.activeCard.name);
    [self setupView];

}

- (void)setupView {

    if (self.activeCard.labels.count>0) {

        self.labelsArray.content = self.activeCard.labels;
        [self.labelCollection setNeedsDisplay:YES];

        NSLog(@"labelsArray = %@",self.labelsArray.content);
    }
}


- (void)setupConstraints {

    NSView *mainView = self.mainView;
    NSView *innerView = self.innerView;

    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[innerView(==mainView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(innerView,mainView)];
        NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[innerView(==mainView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(innerView,mainView)];

    [self.view addConstraints:constraints];
    [self.view addConstraints:constraints1];
    [self.view setNeedsUpdateConstraints:YES];
    [self.view updateConstraints];

}

@end
