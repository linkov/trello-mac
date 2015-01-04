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
#import "SDWTrelloStore.h"
#import "SDWChecklist.h"
#import "SDWChecklistItem.h"
#import "SDWCheckItemTableCellView.h"

@interface SDWCardViewController () <JWCTableViewDataSource, JWCTableViewDelegate,SDWCheckItemDelegate>
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
@property (strong) IBOutlet NSScrollView *checkListsScrollView;
@property (strong) IBOutlet NSLayoutConstraint *checkListsScrollLeadingSpace;
@property (strong) IBOutlet NSLayoutConstraint *cardInfoScrollLeading;
@property (strong) IBOutlet NSLayoutConstraint *cardInfoTrailingSpace;
@property (strong) IBOutlet JWCTableView *checkListsTable;


@property (nonatomic, retain) NSMutableArray *todoSectionKeys;
@property (nonatomic, retain) NSMutableDictionary *todoSectionContents;

@property BOOL isInTODOMode;

@end

@implementation SDWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.checkListsScrollView.wantsLayer = YES;
    self.scrollView.wantsLayer = YES;

    self.isInTODOMode = NO;
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [SharedSettings appBackgroundColorDark].CGColor;

    self.activityItems = [NSArray array];
    self.activityTable.backgroundColor = [SharedSettings appBackgroundColor];
    self.activityTable.wantsLayer = YES;

    self.activityTableScroll.wantsLayer = YES;
    self.activityTableScroll.layer.cornerRadius = 1.5;

    [self.checkListsTable setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];

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

- (void)viewWillAppear {

    self.checkListsScrollLeadingSpace.constant = -500;
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
    [self fetchChecklists];

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

- (void)fetchChecklists {

    [[SDWTrelloStore store] fetchChecklistsForCardID:self.card.cardID completion:^(id object, NSError *error) {

        if (!error) {

            NSMutableArray *keys = [[NSMutableArray alloc] init];
            NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];

            for (SDWChecklist *checkList in object) {

                [contents setObject:checkList.items forKey:checkList.name];
                [keys addObject:checkList.name];
            }

            self.todoSectionContents = contents;
            self.todoSectionKeys = keys;
            [self.checkListsTable reloadData];


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

    if (!self.isInTODOMode) {

        self.card.name = self.cardNameTextView.string;
        self.card.cardDescription = self.cardDescriptionTextView.string;
        [[self cardsVC] updateCardDetails:self.card];

    } else {

        //[self fetchChecklists];

    }
}



- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowCalendar"]) {
        SDWCardCalendarVC *calVC = segue.destinationController;
        calVC.currentDue = self.card.dueDate;
    }
}

#pragma mark - JWCTableViewDataSource, JWCTableViewDelegate

-(BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section {

    if (tableView == self.activityTable) {
        return NO;
    }

    return YES;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.activityTable) {
        return NO;
    }

    return YES;
}

//Number of rows in section
-(NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.activityTable) {

        return self.activityItems.count;

    } else {

        NSString *key = [[self todoSectionKeys] objectAtIndex:section];
        NSArray *contents = [[self todoSectionContents] objectForKey:key];
        NSInteger rows = [contents count];
        return rows;
    }
}

//Number of sections
-(NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {

    if (tableView == self.activityTable) {

        return 1;
    } else {

       return  [[self todoSectionKeys] count];
    }

}

//Has a header view for a section
-(BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {

    if (tableView == self.activityTable) {
        return NO;
    }
    return YES;
}

-(CGFloat)tableView:(NSTableView *)tableView heightForHeaderViewForSection:(NSInteger)section {
    return 40;
}


-(NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (tableView != self.activityTable) {

        SDWCheckItemTableCellView *resultView = [tableView makeViewWithIdentifier:@"checkListCellView" owner:self];

        resultView.textField.stringValue = [[self todoSectionKeys] objectAtIndex:section];
        //resultView.textField.textColor = [SharedSettings appBleakWhiteColor];
        //resultView.textField.font = [NSFont boldSystemFontOfSize:16];
        [resultView.checkBox removeFromSuperview];
        resultView.textField.textColor =[[NSColor colorWithHexColorString:@"EDEDF4"] colorWithAlphaComponent:0.3];
        resultView.centerYConstraint.constant = -12;
        [resultView.superview setNeedsUpdateConstraints:YES];
        [resultView.superview updateConstraintsForSubtreeIfNeeded];

        return resultView;
        
    } else {

        return nil;
    }

}


//Height related
-(CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.activityTable) {

        SDWActivity *activity = self.activityItems[[indexPath row]];

        CGRect rec = [activity.content boundingRectWithSize:CGSizeMake(255, MAXFLOAT) options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:11]}];

        return rec.size.height+16+(17+4);
    }

    return 30;

}

-(NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {

    NSView *result;

    if (tableView == self.activityTable) {


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


        
        result = resultView;

    } else {

        NSString *key = [[self todoSectionKeys] objectAtIndex:[indexPath section]];
        NSArray *contents = [[self todoSectionContents] objectForKey:key];
        SDWChecklistItem *item = [contents objectAtIndex:[indexPath row]];

        SDWCheckItemTableCellView *resultView = [tableView makeViewWithIdentifier:@"checkListCellView" owner:self];
        resultView.textField.stringValue = item.name;
        resultView.textField.textColor = [SharedSettings appBleakWhiteColor];
        resultView.checkBox.tintColor = [SharedSettings appBleakWhiteColor];
        [resultView.checkBox setChecked:[item.state isEqualToString:@"incomplete"] == YES ? NO : YES];
        resultView.textField.enabled = !resultView.checkBox.checked;

        resultView.layer.backgroundColor = [SharedSettings appBackgroundColor].CGColor;
        resultView.textField.font = [NSFont systemFontOfSize:12];
        resultView.delegate = self;
        resultView.trelloCheckItem = item;

        result = resultView;
    }

    return result;

}

- (IBAction)switchDidChange:(ITSwitch *)sender {


    CGFloat pos;
    CGFloat checkListsPos;
    NSImage *checkMarkImage;

    if (self.isInTODOMode == NO) {
        pos = 500;
        checkListsPos = 500;
        checkMarkImage = [NSImage imageNamed:@"addCard"];


        self.checkListsScrollLeadingSpace.constant = 15;

        //self.cardInfoTrailingSpace.priority = 1000;
        self.cardInfoTrailingSpace.constant = -500;


        self.isInTODOMode = YES;

    } else {
        pos = -500;
        checkListsPos = -500;
        checkMarkImage = [NSImage imageNamed:@"saveAlt2"];


        self.checkListsScrollLeadingSpace.constant = -500;
        self.cardInfoTrailingSpace.constant = 0;


        self.isInTODOMode = NO;

    }

//    [self.view setNeedsUpdateConstraints:YES];

   // [self.view layoutSubtreeIfNeeded];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
        context.duration = 0.25; // you can leave this out if the default is acceptable
        context.allowsImplicitAnimation = YES;
        self.saveButton.image =  checkMarkImage;
        [self.view updateConstraintsForSubtreeIfNeeded];
        [self.view layoutSubtreeIfNeeded];

    } completionHandler:^{


    }];

//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        context.duration = 0.3;
//        //context.timingFunction = kCAMediaTimingFunctionEaseIn;
////        self.scrollView.animator.frame = CGRectOffset(self.scrollView.frame, pos, 0);
////        self.checkListsScrollView.animator.frame = CGRectOffset(self.checkListsScrollView.frame, pos, 0);
//
//        [self.view updateConstraintsForSubtreeIfNeeded];
//        self.saveButton.image =  checkMarkImage;
//
//    } completionHandler:^{
//
//    }];

}

#pragma mark - SDWCheckItemDelegate

- (void)checkItemDidCheck:(SDWCheckItemTableCellView *)item {

    item.trelloCheckItem.state = item.checkBox.checked == YES ? @"complete" : @"incomplete";

   [[SDWTrelloStore store] updateCheckItem:item.trelloCheckItem cardID:self.card.cardID withCompletion:^(id object, NSError *error) {

   }];
}

- (void)checkItemDidChangeName:(SDWCheckItemTableCellView *)item {

    [[SDWTrelloStore store] updateCheckItem:item.trelloCheckItem cardID:self.card.cardID withCompletion:^(id object, NSError *error) {

    }];
}

@end
