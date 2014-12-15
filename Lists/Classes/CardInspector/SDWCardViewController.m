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
#import <QuartzCore/QuartzCore.h>

#import "SDWCardsController.h"
#import "SDWMainSplitController.h"
#import "SDWCardCalendarVC.h"

@interface SDWCardViewController ()
@property (strong) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSTextView *cardDescriptionTextView;
@property (strong) IBOutlet NSTextView *cardNameTextView;
@property (strong) IBOutlet NSImageView *logoImageView;
@property (strong) IBOutlet NSTextView *dueDateTextView;

@property (strong) IBOutlet SDWCardDetailBox *dueBox;
@property (strong) IBOutlet SDWCardDetailBox *nameBox;
@property (strong) IBOutlet SDWCardDetailBox *descBox;

@property (strong) IBOutlet NSButton *saveButton;
@property (strong) IBOutlet NSCollectionView *activityCollectionView;


@end

@implementation SDWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [SharedSettings appBackgroundColorDark].CGColor;

    self.logoImageView.hidden = YES;
    self.logoImageView.wantsLayer = YES;

    self.logoImageView.layer.opacity = 0.2;

    [self hideViews:YES];
    [self animateLogoIn:YES];

    self.activityCollectionView.wantsLayer = YES;
    self.activityCollectionView.layer.cornerRadius = 1.5;
    self.activityCollectionView.backgroundColors = @[ [SharedSettings appBackgroundColor] ];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidUpdateDueNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        self.card.dueDate = note.userInfo[@"date"];
        [self updateDueDateViewWithDate:self.card.dueDate];
    }];
}


- (void)setCard:(SDWCard *)card {

    if (!card) {
        [self animateLogoIn:YES];
        [self hideViews:YES];
        return;
    }

    _card = card;

    NSString *cardName;
    if ([self.card.name isKindOfClass:[NSAttributedString class]]) {
        cardName = [(NSAttributedString *)self.card.name string];
    } else {
        cardName = self.card.name;
    }
    [self animateLogoIn:NO];

    [self hideViews:NO];

    self.cardNameTextView.string = cardName;
    self.cardDescriptionTextView.string = self.card.cardDescription ?: @"";


    [self updateDueDateViewWithDate:self.card.dueDate];

}

- (void)updateDueDateViewWithDate:(NSDate *)date {

    NSLog(@"updateDueDateViewWithDate, date - %@",date);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if (dateString) {
        self.dueDateTextView.string = dateString;
    } else {
        self.dueDateTextView.string = @"";
    }

    [self.dueDateTextView setNeedsDisplay:YES];
}

- (void)animateLogoIn:(BOOL)fadeIn {

    self.logoImageView.hidden = !fadeIn;

//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.fromValue = [NSNumber numberWithInt:fadeIn ? 0.0 : 1.0];
//    animation.toValue = [NSNumber numberWithInt:fadeIn ? 1.0 : 0.0];
//    animation.duration = 0.4;
//    animation.autoreverses = YES;
//    animation.repeatCount = HUGE_VAL;
//
//    [self.logoImageView.layer addAnimation:animation forKey:@"opa"];

    // implicit animation code that worked before 10.8
    //[self.logoImageView.layer setTransform:transform];
}

- (void)hideViews:(BOOL)shouldHide {

    self.activityCollectionView.hidden = self.saveButton.hidden = self.dueBox.hidden = self.nameBox.hidden = self.descBox.hidden = shouldHide;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (SDWCardsController *)cardsVC {

    SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
    return main.cardsVC;
}


- (IBAction)saveCard:(NSButton *)sender {

    self.card.name = self.cardNameTextView.string;
    self.card.cardDescription = self.cardDescriptionTextView.string;
    [[self cardsVC] updateCardDetails:self.card];
}



- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowCalendar"]) {
        SDWCardCalendarVC *calVC = segue.destinationController;
        calVC.currentDue = self.card.dueDate;
        // ????
    }
}

@end
