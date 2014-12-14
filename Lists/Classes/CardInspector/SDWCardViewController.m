//
//  ViewController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWCardDetailBox.h"
#import "NSColor+Util.h"
#import "SDWAppSettings.h"
#import "SDWCardViewController.h"

@interface SDWCardViewController ()
@property (strong) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSTextView *cardDescriptionTextView;
@property (strong) IBOutlet NSTextView *cardNameTextView;
@property (strong) IBOutlet NSImageView *logoImageView;
@property (strong) IBOutlet NSTextView *dueDateTextView;

@property (strong) IBOutlet SDWCardDetailBox *dueBox;
@property (strong) IBOutlet SDWCardDetailBox *nameBox;
@property (strong) IBOutlet SDWCardDetailBox *descBox;



@end

@implementation SDWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [SharedSettings appBackgroundColorDark].CGColor;

    self.dueBox.hidden = self.nameBox.hidden = self.descBox.hidden = YES;
}


- (void)setCard:(SDWCard *)card {

    if (!card) {
        self.logoImageView.hidden = NO;
         self.dueBox.hidden = self.nameBox.hidden = self.descBox.hidden = YES;
        return;
    }

    _card = card;

    NSString *cardName;
    if ([self.card.name isKindOfClass:[NSAttributedString class]]) {
        cardName = [(NSAttributedString *)self.card.name string];
    } else {
        cardName = self.card.name;
    }
    self.logoImageView.hidden = YES;

    self.dueBox.hidden = self.nameBox.hidden = self.descBox.hidden = NO;

    self.cardNameTextView.string = cardName;
    self.cardDescriptionTextView.string = self.card.cardDescription;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    NSString *dateString = [dateFormatter stringFromDate:self.card.dueDate];
    if (dateString) {
        self.dueDateTextView.string = dateString;
    } else {
        self.dueDateTextView.string = @"Set due date";
    }

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
