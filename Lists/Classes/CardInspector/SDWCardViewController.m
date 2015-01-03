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
#import "SDWActivity.h"
#import "JWCTableView.h"
#import "SDWActivityTableCellView.h"

#import "ITSwitch.h"

@interface SDWCardViewController () <JWCTableViewDataSource, JWCTableViewDelegate>
@property (strong) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSTextView *cardDescriptionTextView;
@property (strong) IBOutlet NSTextView *cardNameTextView;
@property (strong) IBOutlet NSImageView *logoImageView;
@property (strong) IBOutlet NSTextField *dueDateLabel;

@property (strong) IBOutlet SDWCardDetailBox *dueBox;
@property (strong) IBOutlet SDWCardDetailBox *nameBox;
@property (strong) IBOutlet SDWCardDetailBox *descBox;

@property (strong) IBOutlet NSButton *saveButton;

@property (strong) IBOutlet JWCTableView *activityTable;
@property (strong) NSArray *activityItems;
@property (strong) IBOutlet NSScrollView *activityTableScroll;
@property (strong) IBOutlet NSTextField *titleDescLabel;
@property (strong) IBOutlet NSTextField *commentsLabel;
@property (strong) IBOutlet NSButton *dueButton;

@end

@implementation SDWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [SharedSettings appBackgroundColorDark].CGColor;

    self.activityItems = [NSArray array];
    self.activityTable.backgroundColor = [SharedSettings appBackgroundColor];
    self.activityTable.wantsLayer = YES;

    self.activityTableScroll.wantsLayer = YES;
    self.activityTableScroll.layer.cornerRadius = 1.5;

    self.logoImageView.hidden = YES;
    self.logoImageView.wantsLayer = YES;
    self.logoImageView.layer.opacity = 0.2;

    self.dueDateLabel.textColor = [[NSColor colorWithHexColorString:@"EDEDF4"] colorWithAlphaComponent:0.9];
    self.titleDescLabel.textColor = self.commentsLabel.textColor = [[NSColor colorWithHexColorString:@"EDEDF4"] colorWithAlphaComponent:0.3];

    CIFilter *invert = [CIFilter filterWithName: @"CIColorInvert"];
    [invert setDefaults];

    self.dueButton.layer.filters = @[invert];
    self.dueButton.layer.opacity = 0.8;


    [self hideViews:YES];
    [self hideComments:YES];
    [self animateLogoIn:YES];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidUpdateDueNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        self.card.dueDate = note.userInfo[@"date"];
        [self updateDueDateViewWithDate:self.card.dueDate];
        [[self cardsVC] updateCardDetails:self.card];
        
    }];
}


- (void)setCard:(SDWCard *)card {

    if (!card) {
        [self animateLogoIn:YES];
        [self hideViews:YES];
        [self hideComments:YES];
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
    [self hideComments:YES];
    [self hideViews:NO];

    self.cardNameTextView.string = cardName;
    self.cardDescriptionTextView.string = self.card.cardDescription ?: @"";


    [self updateDueDateViewWithDate:self.card.dueDate];

    [self fetchActivities];

}



- (void)fetchActivities {

    NSString *URL = [NSString stringWithFormat:@"cards/%@/actions?filter=commentCard", self.card.cardID];
    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWActivity class]
	    toConcretePath:URL];

    [SDWActivity findAll:^(NSArray *response, NSError *err) {

        if (!err) {

            if(response.count != 0) {

                [self hideComments:NO];
                self.activityItems = response;
                [self.activityTable reloadData];
            }

        } else {
            CLSLog(@"fetchActivities error %@",err.localizedDescription);
        }

    }];
}

- (void)updateDueDateViewWithDate:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if (dateString) {
        self.dueDateLabel.stringValue = dateString;
    } else {
        self.dueDateLabel.stringValue = @"Remind me";
    }
    [self.dueDateLabel setNeedsDisplay:YES];
}

- (void)animateLogoIn:(BOOL)fadeIn {

    self.logoImageView.hidden = !fadeIn;
}

- (void)hideComments:(BOOL)shouldHide {

    self.activityTableScroll.hidden = self.commentsLabel.hidden = shouldHide;
}

- (void)hideViews:(BOOL)shouldHide {

  self.titleDescLabel.hidden = self.saveButton.hidden = self.dueBox.hidden = self.nameBox.hidden = self.descBox.hidden = shouldHide;
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
    }
}

#pragma mark - JWCTableViewDataSource, JWCTableViewDelegate


-(BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//Number of rows in section
-(NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityItems.count;
}

//Number of sections
-(NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {
    return 1;
}

//Has a header view for a section
-(BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {
    return NO;
}

//Height related
-(CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SDWActivity *activity = self.activityItems[[indexPath row]];

    CGRect rec = [activity.content boundingRectWithSize:CGSizeMake(255, MAXFLOAT) options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:11]}];

    return rec.size.height+16+(17+4);
}

-(NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {

    SDWActivity *activity = self.activityItems[[indexPath row]];

    SDWActivityTableCellView *resultView = [tableView makeViewWithIdentifier:@"cellView" owner:self];
    resultView.textField.stringValue = activity.content;
    resultView.textField.textColor = [SharedSettings appBleakWhiteColor];
    resultView.timeLabel.textColor = resultView.initialsLabel.textColor = [[NSColor colorWithHexColorString:@"EDEDF4"] colorWithAlphaComponent:0.2];
    resultView.initialsLabel.stringValue = activity.memberInitials;
    resultView.timeLabel.stringValue = activity.timeString;

    resultView.separatorLine.fillColor = [SharedSettings appBackgroundColorDark];

    if ([indexPath row] == self.activityItems.count - 1) {
        resultView.separatorLine.hidden = YES;
    } else {
        resultView.separatorLine.hidden = NO;
    }

    resultView.initialsLabel.wantsLayer = YES;
    resultView.initialsLabel.layer.cornerRadius = 1.5;
    resultView.initialsLabel.layer.borderWidth = 1;
    resultView.initialsLabel.layer.borderColor = [[NSColor colorWithHexColorString:@"EDEDF4"] colorWithAlphaComponent:0.2].CGColor;
    
    return resultView;
}

- (IBAction)switchDidChange:(ITSwitch *)sender {

    CGFloat pos = self.scrollView.frame.origin.x == 500 ? -500 : 500;

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        //context.timingFunction = kCAMediaTimingFunctionEaseIn;
        self.scrollView.animator.frame = CGRectOffset(self.scrollView.frame, pos, 0);
        self.saveButton.image =  self.scrollView.frame.origin.x != 0 ? [NSImage imageNamed:@"addCard"] : [NSImage imageNamed:@"saveAlt2"];
    } completionHandler:nil];
    
}

@end
