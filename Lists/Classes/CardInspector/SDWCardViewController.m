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

    NSString *cardName;
    if ([self.card.name isKindOfClass:[NSAttributedString class]]) {
        cardName = [(NSAttributedString *)self.card.name string];
    } else {
        cardName = self.card.name;
    }

    self.logoImageView.hidden = YES;

    self.cardNameTextView.hidden = self.cardDescriptionTextView.hidden = NO;

    self.cardNameTextView.string = cardName;
    self.cardDescriptionTextView.string = self.card.cardDescription;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
