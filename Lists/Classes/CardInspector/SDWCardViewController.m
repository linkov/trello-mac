//
//  ViewController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "SDWAppSettings.h"
#import "SDWCardViewController.h"

@interface SDWCardViewController ()
@property (strong) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSTextView *cardDescriptionTextView;
@property (strong) IBOutlet NSTextView *cardNameTextView;
@property (strong) IBOutlet NSImageView *logoImageView;

@end

@implementation SDWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [SharedSettings appBackgroundColorDark].CGColor;

    self.cardNameTextView.hidden = self.cardDescriptionTextView.hidden = YES;
}


- (void)setCard:(SDWCard *)card {
    _card = card;

    self.logoImageView.hidden = YES;

    self.cardNameTextView.hidden = self.cardDescriptionTextView.hidden = NO;

    self.cardNameTextView.string = self.card.name;
    self.cardDescriptionTextView.string = self.card.cardDescription;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
