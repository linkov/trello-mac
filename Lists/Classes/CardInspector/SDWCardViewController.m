//
//  ViewController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//


#import "SDWCardViewController.h"

/*-------View Controllers-------*/
#import "SDWMainSplitController.h"
#import "SDWCardCalendarVC.h"
#import "SDWCardsController.h"

/*-------Frameworks-------*/
#import <QuartzCore/QuartzCore.h>

/*-------Views-------*/
#import "ITSwitch.h"
#import "SDWCardDetailBox.h"
#import "NSControl+DragInteraction.h"
#import "JWCTableView.h"
#import "SDWActivityTableCellView.h"
#import "SDWCheckItemTableCellView.h"
#import "SDWLabelDisplayItem.h"
#import "SYFlatButton.h"

/*-------Helpers & Managers-------*/
#import "NSColor+Util.h"
#import "SDWAppSettings.h"
#import "SDWTrelloStore.h"
#import "SDWDataModelManager.h"

/*-------Models-------*/
#import "SDWChecklistDisplayItem.h"
#import "SDWChecklistItemDisplayItem.h"
#import "SDWCardDisplayItem.h"
#import "SDWActivityDisplayItem.h"



#define kLIST_ITEM_TOP_BOTTOM_PAD 12 // hotfix for wrong height

@interface SDWCardViewController () <JWCTableViewDataSource, JWCTableViewDelegate,SDWCheckItemDelegate,NSControlInteractionDelegate, NSTextFieldDelegate, NSTextViewDelegate>
@property (strong) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSTextView *cardDescriptionTextView;
@property (strong) IBOutlet NSTextView *cardNameTextView;
@property (strong) IBOutlet NSImageView *logoImageView;
@property (strong) IBOutlet NSTextField *dueDateLabel;

@property (weak) IBOutlet NSStackView *labelsStackView;

@property (strong,nonatomic) SDWCardDisplayItem *card;

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
@property (strong) NSMutableArray *flatContent;


@property (strong) NSString *dropSectionKey;
@property NSUInteger dropIndex;
@property BOOL isInTODOMode;
@property (strong) IBOutlet NSImageView *cardIcon;
@property (strong) IBOutlet NSImageView *listIcon;
@property (strong) IBOutlet ITSwitch *checkListSwitch;
@property (strong) NSArray *rawcheckLists;
@property (strong) IBOutlet NSImageView *addChecklistOnboard;
@property (strong) IBOutlet NSLayoutConstraint *addChecklistOnboardLeading;

@end

@implementation SDWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.saveButton.interactionDelegate = self;
    self.flatContent = [NSMutableArray array];
    self.rawcheckLists = [NSMutableArray array];

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
    [self.checkListsTable registerForDraggedTypes:@[@"com.sdwr.lists.checklists.drag"]];
    [self.checkListsTable setDraggingDestinationFeedbackStyle:NSTableViewDraggingDestinationFeedbackStyleGap];

    self.logoImageView.hidden = YES;
    self.logoImageView.wantsLayer = YES;
    self.logoImageView.layer.opacity = 0.2;

    self.dueDateLabel.textColor = [NSColor colorWithHexColorString:@"30364C"];
    self.titleDescLabel.textColor = self.commentsLabel.textColor = [[NSColor colorWithHexColorString:@"30364C"] colorWithAlphaComponent:0.4];

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
        [[self cardsVC] updateCardDetails:self.card localOnly:NO];
        
    }];

    self.addChecklistOnboard.hidden = YES;
    
    self.cardDescriptionTextView.delegate = self;
    self.cardNameTextView.delegate = self;
    

}


#pragma mark - NSTextViewDelegate
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(nullable NSString *)replacementString {


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self updateSaveButton:textView];
    });
    
    return YES;

}

- (BOOL)cardNameOrDescriptionNotChanged {
    return ([self.cardDescriptionTextView.string isEqualToString:self.card.cardDescription] && [self.cardNameTextView.string isEqualToString:self.card.name]);
}

- (void)updateSaveButton:(NSTextView *)textView {

    if (textView == self.cardDescriptionTextView) {
        if(![self.cardDescriptionTextView.string isEqualToString:self.card.cardDescription]) {
            self.saveButton.hidden = NO;
        } else {
            self.saveButton.hidden = YES;
        }
        
        
    }
        


         if (textView == self.cardNameTextView) {
             
             if(![self.cardNameTextView.string isEqualToString:self.card.name]) {
                 self.saveButton.hidden = NO;
             } else {
                 self.saveButton.hidden = YES;
             }
         }


    
}


- (void)viewWillAppear {

    self.checkListsScrollLeadingSpace.constant = self.addChecklistOnboardLeading.constant = -500;
}

- (void)viewWillDisappear {
    [self.labelsStackView.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (void)onAddLabel:(id)sender {
    
//    SDWMainSplitController *splitViewVC  = (SDWMainSplitController *)self.parentViewController;
//    splitViewVC.boardsListVCDidRequestAddItem
}

- (void)setupCard:(SDWCardDisplayItem *)card {
    [self.labelsStackView.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.saveButton.hidden = !self.isInTODOMode;
    

    if (!card) {
        [self animateLogoIn:YES];
        [self hideViews:YES];
        [self hideComments:YES];

        [self.todoSectionContents removeAllObjects];
        [self.todoSectionKeys removeAllObjects];
        [self.flatContent removeAllObjects];
        [self.checkListsTable reloadData];

        return;
    }

    self.card = card;

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
    [self.cardNameTextView setNeedsDisplay:YES];

    self.cardDescriptionTextView.string = self.card.cardDescription ?: @"";
    [self.cardDescriptionTextView setNeedsDisplay:YES];


    [self updateDueDateViewWithDate:self.card.dueDate];

    if (card.trelloID) {
        
        [self fetchActivities];
        [self fetchChecklists];
    }
    
    
   // NSButton *addLabel = [NSButton buttonWithImage:[NSImage imageNamed:@"add_label"] target:self action:@selector(onAddLabel:)];
//    NSButton *addLabel = [[NSButton alloc] init];
//
//    [addLabel setImage:[NSImage imageNamed:@"add_label"]];
//    [addLabel setAction:@selector(onAddLabel:)];
//    [addLabel setTarget:self];
//
//
//    SYFlatButton *button = [[SYFlatButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 30.0)];
//    button.title = @" + Add label ";
////    button.momentary = YES;
//    button.cornerRadius = 4.0;
//    button.font = [NSFont fontWithName:@"IBMPlexSans-Medium" size:13];
//    button.titleNormalColor = [NSColor whiteColor];
//     button.titleHighlightColor = [NSColor whiteColor];
//    button.backgroundNormalColor = [NSColor blackColor];
//    button.backgroundHighlightColor = [NSColor blackColor];
//    button.action = @selector(onAddLabel:);
//    button.target = self;
////    [self.view addSubview:button];
//
//
//    [self.labelsStackView addView:button inGravity:NSStackViewGravityCenter];
    
    for (SDWLabelDisplayItem *label in [self.card labels]) {
        
          NSTextField *text = [[NSTextField alloc]init];
              [text setWantsLayer:YES];
              [text setTranslatesAutoresizingMaskIntoConstraints:NO];
              [text setFont: [NSFont fontWithName:@"IBMPlexSans-Medium" size:12]];

              [text setBezeled:NO];
              [text setTextColor:[NSColor whiteColor]];
        [text setStringValue:[NSString stringWithFormat:@" %@ ",label.name.length > 0 ? label.name: label.color]];
              [text setEditable:NO];
              text.backgroundColor = [SharedSettings colorForTrelloColor:label.color];
              text.alignment = NSTextAlignmentLeft;
              text.layer.backgroundColor = [SharedSettings colorForTrelloColor:label.color].CGColor;
              text.layer.cornerRadius = 2;

        [self.labelsStackView addArrangedSubview:text];
        
        NSLog(@"name = %@, color = %@", label.name, label.color);
    }
   

    NSView *spacer = [NSView new];
    [spacer setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [self.labelsStackView addArrangedSubview:spacer];
}



- (void)fetchActivities {
    
    SDWTrelloStoreCompletionBlock block = ^(NSArray *objects, NSError *error) {
        
        [[self cardsVC] showCardSavingIndicator:NO];
        
        if (!error) {
            
            if(objects.count != 0) {
                
                [self hideComments:NO];
                self.activityItems = objects;
                [self.activityTable reloadData];
            }
            
        } else {
            //            CLSLog(@"fetchActivities error %@",err.localizedDescription);
        }
    };
    
    [[SDWTrelloStore store] fetchAllActivitiesForCard:self.card currentData:block fetchedData:block];


}

- (void)fetchChecklists {

    [[self cardsVC] showCardSavingIndicator:YES];
    
    [[SDWTrelloStore store] fetchAllChecklistsForCardID:self.card.trelloID CurrentData:^(id object, NSError *error) {
        
        [[self cardsVC] showCardSavingIndicator:NO];
        
        if (!error) {
            
            self.rawcheckLists = object;
            [self loadRowsAndSectionsFromFlatData:object];
            
            
            if (self.todoSectionKeys.count == 0) {
                self.addChecklistOnboard.hidden = NO;
            } else {
                self.addChecklistOnboard.hidden = YES;
            }
            
        }
        
        
    } FetchedData:^(id object, NSError *error) {
       
        [[self cardsVC] showCardSavingIndicator:NO];
        
        if (!error) {
            
            self.rawcheckLists = object;
            [self loadRowsAndSectionsFromFlatData:object];
            
            
            if (self.todoSectionKeys.count == 0) {
                self.addChecklistOnboard.hidden = NO;
            } else {
                self.addChecklistOnboard.hidden = YES;
            }
            
        }
        
    }];




}


- (void)loadRowsAndSectionsFromFlatData:(NSArray *)data {

    [self.flatContent removeAllObjects];

    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];
    NSArray *dataArray = [data copy];

    NSSortDescriptor *sortBy = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES selector:@selector(compare:)];
    dataArray = [NSMutableArray arrayWithArray:[dataArray sortedArrayUsingDescriptors:@[sortBy]]];

    for (SDWChecklistDisplayItem *checkList in dataArray) {
        
        [self.flatContent addObject:checkList.name];
        [self.flatContent addObjectsFromArray:[[checkList items] sortedArrayUsingDescriptors:@[sortBy]]];

        [contents setObject:[[checkList items] sortedArrayUsingDescriptors:@[sortBy]] forKey:checkList.trelloID];
        [keys addObject:checkList.trelloID];
    }

    self.todoSectionContents = contents;
    self.todoSectionKeys = keys;
    [self.checkListsTable reloadData];

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

    self.titleDescLabel.hidden = self.dueBox.hidden = self.nameBox.hidden = self.descBox.hidden = self.cardIcon.hidden =
   self.listIcon.hidden = self.checkListsScrollView.hidden = self.checkListSwitch.hidden =
 shouldHide;
}

- (SDWCardsController *)cardsVC {

    SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
    return main.cardsVC;
}


- (IBAction)saveCard:(NSButton *)sender {

    if (!self.isInTODOMode) {

        self.card.name = self.cardNameTextView.string;
        self.card.cardDescription = self.cardDescriptionTextView.string;
        [[self cardsVC] updateCardDetails:self.card localOnly:NO];

    } else {

        [self addChecklist];

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

    if (section == 0) {
        return 18;
    }
    return 40;
}


-(NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (tableView != self.activityTable) {

        SDWCheckItemTableCellView *resultView = [tableView makeViewWithIdentifier:@"checkListCellView" owner:self];

        resultView.textField.stringValue = [self checkListNameFromID: [[self todoSectionKeys] objectAtIndex:section] ];

        resultView.checkBoxWidth.constant = 0;
        resultView.textField.textColor =[[NSColor colorWithHexColorString:@"30364C"] colorWithAlphaComponent:0.4];

        if (section == 0) {
            resultView.addCheckItemCenterY.constant = 4;
            resultView.checkItemTopSpace.constant = 1;
            resultView.handleCenterY.constant = 2;
        } else {

            resultView.addCheckItemCenterY.constant = -8;
            resultView.handleCenterY.constant = -10;
            resultView.checkItemTopSpace.constant = 24;
        }

        [resultView.superview setNeedsUpdateConstraints:YES];
        [resultView.superview updateConstraintsForSubtreeIfNeeded];
        resultView.layer.backgroundColor = [NSColor clearColor].CGColor;
        resultView.textField.enabled = YES;
        resultView.addCheckItemWidth.constant = 15;
        resultView.textField.font = [NSFont fontWithName:@"TektonPro-BoldObl" size:14];
        resultView.delegate = self;
        resultView.trelloCheckListID = [[self todoSectionKeys] objectAtIndex:section];
        resultView.trelloCheckItem = nil;
        resultView.addCheckLeading.constant = resultView.addCheckTrailing.constant = 5;
        resultView.checkItemWidth.constant = 200;

        return resultView;
        
    } else {

        return nil;
    }

}


//Height related
-(CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.activityTable) {

        SDWActivityDisplayItem *activity = self.activityItems[[indexPath row]];

        CGRect rec = [activity.content boundingRectWithSize:CGSizeMake(255, MAXFLOAT) options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:11]}];

        return rec.size.height+16+(17+4);

    } else {

        NSString *key = [[self todoSectionKeys] objectAtIndex:[indexPath section]];
        NSArray *contents = [[self todoSectionContents] objectForKey:key];
        SDWChecklistDisplayItem *item = [contents objectAtIndex:[indexPath row]];

        CGRect rec = [item.name boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:12]}];

        return floor(rec.size.height+kLIST_ITEM_TOP_BOTTOM_PAD);

    }

    return 30;

}

-(NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {

    NSView *result;

    if (tableView == self.activityTable) {


        SDWActivityDisplayItem *activity = self.activityItems[[indexPath row]];

        SDWActivityTableCellView *resultView = [tableView makeViewWithIdentifier:@"cellView" owner:self];
        resultView.textField.stringValue = activity.content;
        resultView.textField.textColor = [SharedSettings appAccentDarkColor];
        resultView.timeLabel.textColor = resultView.initialsLabel.textColor = [[NSColor colorWithHexColorString:@"30364C"] colorWithAlphaComponent:0.8];
        resultView.initialsLabel.stringValue = activity.memberInitials;
        resultView.timeLabel.stringValue = activity.dateString;

        resultView.separatorLine.fillColor = [SharedSettings appBackgroundColorDark];

        if ([indexPath row] == self.activityItems.count - 1) {
            resultView.separatorLine.hidden = YES;
        } else {
            resultView.separatorLine.hidden = NO;
        }

        resultView.initialsLabel.wantsLayer = YES;
        resultView.initialsLabel.layer.cornerRadius = 1.5;
        resultView.initialsLabel.layer.borderWidth = 0;
        resultView.initialsLabel.layer.borderColor = [[NSColor colorWithHexColorString:@"30364C"] colorWithAlphaComponent:0.8].CGColor;
        
        result = resultView;

    } else {

        NSString *key = [[self todoSectionKeys] objectAtIndex:[indexPath section]];
        NSArray *contents = [[self todoSectionContents] objectForKey:key];
        SDWChecklistItemDisplayItem *item = [contents objectAtIndex:[indexPath row]];

        SDWCheckItemTableCellView *resultView = [tableView makeViewWithIdentifier:@"checkListCellView" owner:self];
        resultView.textField.stringValue = item.name;
        resultView.textField.textColor = [SharedSettings appAccentDarkColor];
        resultView.checkBox.tintColor = [SharedSettings appAccentDarkColor];
        [resultView.checkBox setChecked:!item.isOpen];
        resultView.textField.enabled = !resultView.checkBox.checked;
        //resultView.toolTip = resultView.textField.stringValue;


        resultView.layer.backgroundColor = [SharedSettings appBackgroundColor].CGColor;
        resultView.textField.font = [NSFont systemFontOfSize:12];
        resultView.delegate = self;

        resultView.trelloCheckItem = item;
        resultView.trelloCheckListID = [[self todoSectionKeys] objectAtIndex:indexPath.section];
        

//        resultView.centerYConstraint.constant = 0;
        resultView.checkBoxWidth.constant = 23;
        resultView.addCheckItemWidth.constant = resultView.addCheckLeading.constant = resultView.addCheckTrailing.constant = 0;
        resultView.checkItemTopSpace.constant = 5;
        resultView.checkItemWidth.constant = 220;
        resultView.handleCenterY.constant = 0;

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

        self.saveButton.hidden = NO;
        self.checkListsScrollLeadingSpace.constant = 16;
        self.addChecklistOnboardLeading.constant = 4;
        self.cardInfoTrailingSpace.constant = -500;

        [self.saveButton registerForDraggedTypes:@[@"TRASH_DRAG_TYPE"]];

        self.isInTODOMode = YES;

    } else {
        pos = -500;
        checkListsPos = -500;
        checkMarkImage = [NSImage imageNamed:@"saveAlt2"];


        self.checkListsScrollLeadingSpace.constant = self.addChecklistOnboardLeading.constant = -500;
        self.cardInfoTrailingSpace.constant = 0;

        [self.saveButton unregisterDraggedTypes];
        
        self.saveButton.hidden = [self cardNameOrDescriptionNotChanged];

        self.isInTODOMode = NO;

    }

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3; // you can leave this out if the default is acceptable
        context.allowsImplicitAnimation = YES;
        context.timingFunction =  [CAMediaTimingFunction functionWithControlPoints:0.25 :0.10 :0.25 :1.00];
        self.saveButton.image =  checkMarkImage;
        [self.view updateConstraintsForSubtreeIfNeeded];
        [self.view layoutSubtreeIfNeeded];

    } completionHandler:^{

    }];

}



#pragma mark - Drag Drop

//TODO: move to Shared Utils
- (NSArray *)reorderFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inArray:(NSArray *)arr {

    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:arr];

    // 1. swap 2 elements
    SDWChecklistItemDisplayItem *movedItem = [mutableArray objectAtIndex:fromIndex];
    SDWChecklistItemDisplayItem *newSiblingItem = [mutableArray objectAtIndex:toIndex];

    NSUInteger movedCardPos = movedItem.position;
    NSUInteger newSiblingCardPos = newSiblingItem.position;

    movedItem.position = newSiblingCardPos;
    newSiblingItem.position = movedCardPos;

    [mutableArray removeObject:movedItem];
    [mutableArray insertObject:movedItem atIndex:toIndex];

    // 2. set positions to all cards equal to cards' indexes in array
    for (int i = 0; i<mutableArray.count; i++) {
        SDWChecklistItemDisplayItem *item = mutableArray[i];
        item.position = i;
    }


    NSSortDescriptor *sortBy = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES selector:@selector(compare:)];
    mutableArray = [NSMutableArray arrayWithArray:[mutableArray sortedArrayUsingDescriptors:@[sortBy]]];

    return mutableArray;
    
}

- (NSDragOperation)_jwcTableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {



    if ([self.flatContent count] == 1 || row > self.flatContent.count-1) {
        return NSDragOperationNone;
    }

    NSUInteger itemMovedFromIndex = 0;
    NSUInteger itemIndexInSection = 0;
    NSString *sectionKeyNew;

    NSPasteboard *pBoard = [info draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"com.sdwr.lists.checklists.drag"];

    NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
    NSString *sectionKeyOriginal = cardDict[@"sectionKey"];
    itemMovedFromIndex = [cardDict[@"itemIndex"] integerValue];


    NSTableRowView *rowView = [self.checkListsTable rowViewAtRow:row makeIfNecessary:YES];
    SDWCheckItemTableCellView *cellView = rowView.subviews.firstObject;
    [cellView animateControlsOpacityIn:NO];

    if ([[self.flatContent objectAtIndex:row] isKindOfClass:[SDWChecklistItemDisplayItem class]]) {

        SDWChecklistItemDisplayItem *item = [self.flatContent objectAtIndex:row];
        NSArray *sectionContentsOfItem = self.todoSectionContents[item.checklist.trelloID];
        itemIndexInSection = [sectionContentsOfItem indexOfObject:item];
        self.dropSectionKey = cellView.trelloCheckListID;
        sectionKeyNew = item.checklist.trelloID;

    } else {

        NSLog(@"[self.flatContent objectAtIndex:row] is Section");
    }



    NSDragOperation dragOp = NSDragOperationNone;


    if (op == NSTableViewDropAbove) {

        if (itemMovedFromIndex < itemIndexInSection && [sectionKeyOriginal isEqualToString:self.dropSectionKey]) {

            /* fix for when dragging down index hops over 1 item always */
            itemIndexInSection -= 1;
        }

        self.dropIndex = itemIndexInSection;
        dragOp = NSDragOperationMove;

    } else if (op == NSTableViewDropOn) {
        dragOp = NSDragOperationNone;
    }

    return dragOp;
}


- (BOOL)_jwcTableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
                  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {

    NSPasteboard *pBoard = [info draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"com.sdwr.lists.checklists.drag"];

    NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
    NSUInteger itemMovedFromIndex = [cardDict[@"itemIndex"] integerValue];
    NSString *sectionKey = cardDict[@"sectionKey"];
    NSUInteger itemFlatIndex = [cardDict[@"itemFlatIndex"] integerValue];
    SDWChecklistItemDisplayItem *originalItem = [self.flatContent objectAtIndex:itemFlatIndex];
    originalItem.position = self.dropIndex;
    
//    SDWMChecklist *checklist = [[SDWDataModelManager manager] fetchEntityForName:[SDWMChecklist entityName] withTrelloID:self.dropSectionKey inContext:[SDWDataModelManager manager].managedObjectContext];
//    SDWChecklistDisplayItem *checkListDisplayItem = [[SDWChecklistDisplayItem alloc ] initWithModel:checklist];
    


    if ([sectionKey isEqualToString:self.dropSectionKey]) {

        NSArray *reorderedArray = [self reorderFromIndex:itemMovedFromIndex toIndex:self.dropIndex inArray:self.todoSectionContents[self.dropSectionKey]];
        [self.todoSectionContents setValue:reorderedArray forKey:self.dropSectionKey];
        [self changePositionForCheckItem:originalItem];


    } else {

        NSMutableArray *mutableItems =[NSMutableArray arrayWithArray:self.todoSectionContents[sectionKey]];
        [mutableItems removeObject:originalItem];
        [self.todoSectionContents setObject:[NSArray arrayWithArray:mutableItems] forKey:sectionKey];

        mutableItems = [NSMutableArray arrayWithArray:self.todoSectionContents[self.dropSectionKey]];

        if (mutableItems.count == 0) {
            self.dropIndex = 0;
        }

        [mutableItems insertObject:originalItem atIndex:self.dropIndex];

        [self.todoSectionContents setObject:[NSArray arrayWithArray:mutableItems] forKey:self.dropSectionKey];

        [self moveCheckItem:originalItem fromListID:sectionKey toListID:self.dropSectionKey];
    }

    [self updateFlatContent];

    [self.checkListsTable reloadData];

    return YES;

}

- (void)updateFlatContent {

    NSMutableArray *newFlatContent = [NSMutableArray array];

    for (NSString *key in self.todoSectionKeys) {

        [newFlatContent addObject:[self checkListNameFromID:key] ];

        for (SDWMChecklistItem *item in self.todoSectionContents[key]) {

            [newFlatContent addObject:item];
        }
    }

    self.flatContent = newFlatContent;
}

- (BOOL)_jwcTableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {

    if (tv == self.activityTable) {
        return NO;
    }

    if (![[self.flatContent objectAtIndex:rowIndexes.firstIndex] isKindOfClass:[SDWChecklistItemDisplayItem class]]) {

        NSTableRowView *rowView = [self.checkListsTable rowViewAtRow:rowIndexes.firstIndex makeIfNecessary:YES];
        SDWCheckItemTableCellView *cellView = rowView.subviews.firstObject;

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{
                                                                     @"isSection":@YES,
                                                                     @"sectionKey":cellView.trelloCheckListID,
                                                                     @"itemFlatIndex":[NSNumber numberWithInteger:rowIndexes.firstIndex]
                                                                     }];

        [pboard setData:data forType:@"TRASH_DRAG_TYPE"];

    } else {

        SDWChecklistItemDisplayItem *item = [self.flatContent objectAtIndex:rowIndexes.firstIndex];
        NSArray *sectionContentsOfItem = self.todoSectionContents[item.checklist.trelloID];
        NSUInteger itemIndexInSection = [sectionContentsOfItem indexOfObject:item];

        NSLog(@"writeRowsWithIndexes - itemIndexInSection %lu",(unsigned long)itemIndexInSection);


        if (itemIndexInSection > 10000) {

            return NO;
        }



        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{
                                                                     @"isSection":@NO,
                                                                     @"trelloID":item.trelloID,
                                                                     @"name":item.name,
                                                                     @"sectionKey":item.checklist.trelloID,
                                                                     @"itemIndex":[NSNumber numberWithInteger:itemIndexInSection],
                                                                     @"itemFlatIndex":[NSNumber numberWithInteger:rowIndexes.firstIndex]
                                                                     }];

        [pboard setData:data forType:@"com.sdwr.lists.checklists.drag"];
        [pboard setData:data forType:@"TRASH_DRAG_TYPE"];
    }




    return YES;

}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {

    self.saveButton.image = [NSImage imageNamed:@"trashSM"];

}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {

    self.saveButton.image = [NSImage imageNamed:@"addCard"];
}

#pragma mark - NSControlInteractionDelegate

- (void)control:(NSControl *)control didAcceptDropWithPasteBoard:(NSPasteboard *)pasteboard {

    NSData *data = [pasteboard dataForType:@"TRASH_DRAG_TYPE"];
    NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    BOOL isSection = [dataDict[@"isSection"] boolValue];

    if (isSection) {

        SDWChecklistDisplayItem *checkList = [self.rawcheckLists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"trelloID = %@",dataDict[@"sectionKey"]]].firstObject;

        [[SDWTrelloStore store] deleteCheckList:checkList withCompletion:^(id object, NSError *error) {

            if (!error) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.rawcheckLists];
                [arr removeObject:checkList];
                self.rawcheckLists = arr;

                if (self.rawcheckLists.count == 0) {
                    self.addChecklistOnboard.hidden = NO;
                }

                [self.todoSectionKeys removeObject:dataDict[@"sectionKey"]];
                [self.todoSectionContents removeObjectForKey:dataDict[@"sectionKey"]];
                [self.checkListsTable reloadData];
                [self updateFlatContent];
                [self updateCardTodosStatus];
            }

        }];


    } else {

        NSMutableArray *sectionContent =  [NSMutableArray arrayWithArray:self.todoSectionContents[dataDict[@"sectionKey"]]];
        SDWChecklistItemDisplayItem *item = [sectionContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"trelloID == %@",dataDict[@"trelloID"]]].firstObject;

                [sectionContent removeObject:item];
                self.todoSectionContents[dataDict[@"sectionKey"]] = sectionContent;
                [self.checkListsTable reloadData];
                [self updateFlatContent];
        
        [[self cardsVC] showCardSavingIndicator:YES];

        [[SDWTrelloStore store] deleteCheckItem:item cardID:self.card.trelloID withCompletion:^(id object, NSError *error) {

            [[self cardsVC] showCardSavingIndicator:NO];

            if (!error) {

                [self updateCardTodosStatus];
                
            }
        }];
    }
}

#pragma mark - SDWCheckItemDelegate

- (void)checkItemShouldAddItem:(SDWCheckItemTableCellView *)itemView {
    
    
    if([SharedSettings isOffline]) {
        return;
    }


    SDWChecklistItemDisplayItem *newItem = [SDWChecklistItemDisplayItem new];
    newItem.name = @"new item";
    newItem.state = @"incomplete";

//    NSMutableArray *sectionContent =  [NSMutableArray arrayWithArray:self.todoSectionContents[itemView.trelloCheckList.trelloID]];
//    newItem.checklist = itemView.trelloCheckList;

    [[self cardsVC] showCardSavingIndicator:YES];
    
    
    [[SDWTrelloStore store] createCheckItemWithName:@"new item" inChecklistID:itemView.trelloCheckListID cardID:self.card.trelloID withCompletion:^(id object, NSError *error) {
        
        
        if (!error) {
            NSMutableArray *sectionContent =  [NSMutableArray arrayWithArray:self.todoSectionContents[itemView.trelloCheckListID]];
            
            [sectionContent addObject:object];
            [self.todoSectionContents setObject:sectionContent forKey:itemView.trelloCheckListID];
            [self.checkListsTable reloadData];
            [self updateFlatContent];
            
            NSUInteger rowIndexInFlat = [self.flatContent indexOfObject:object];
            
            [self.checkListsTable scrollRowToVisible:rowIndexInFlat];
            
            NSTableRowView *rowView = [self.checkListsTable rowViewAtRow:rowIndexInFlat makeIfNecessary:YES];
            SDWCheckItemTableCellView *cellView = rowView.subviews.firstObject;
            [cellView.textField becomeFirstResponder];
        }
        

        
    }];
    


}



#pragma mark - Trello API

- (void)moveCheckItem:(SDWChecklistItemDisplayItem *)item fromListID:(NSString *)listID toListID:(NSString *)toListID {

    [[self cardsVC] showCardSavingIndicator:YES];
    
    [[SDWTrelloStore store] moveCheckItem:item fromList:listID toList:toListID cardID:self.card.trelloID withCompletion:^(id object, NSError *error) {
         [[self cardsVC] showCardSavingIndicator:NO];
    }];


}

- (void)changePositionForCheckItem:(SDWChecklistItemDisplayItem *)item {

    [[self cardsVC] showCardSavingIndicator:YES];

    [[SDWTrelloStore store] updateCheckItemPosition:item cardID:self.card.trelloID withCompletion:^(id object, NSError *error) {

        [[self cardsVC] showCardSavingIndicator:NO];
    }];
}

- (void)checkItemDidCheck:(SDWCheckItemTableCellView *)itemView {

    itemView.trelloCheckItem.state = itemView.checkBox.checked == YES ? @"complete" : @"incomplete";
    [[self cardsVC] showCardSavingIndicator:YES];

   [[SDWTrelloStore store] updateCheckItem:itemView.trelloCheckItem cardID:self.card.trelloID withCompletion:^(id object, NSError *error) {

       [[self cardsVC] showCardSavingIndicator:NO];
       [self updateCardTodosStatus];

   }];
}

- (void)checkItemDidChangeName:(SDWCheckItemTableCellView *)itemView {

    [[self cardsVC] showCardSavingIndicator:YES];

    /* invalidate heightForRow - in case user typed multiline text we need to change cell height */
    [self.checkListsTable reloadData];

    if (itemView.trelloCheckItem && [itemView.trelloCheckItem isKindOfClass:[SDWChecklistItemDisplayItem class]]) {

        [[SDWTrelloStore store] updateCheckItem:itemView.trelloCheckItem
                                         cardID:self.card.trelloID
                                 withCompletion:^(id object, NSError *error) {

            [[self cardsVC] showCardSavingIndicator:NO];
            [self updateCardTodosStatus];

        }];

    } else {

        [[SDWTrelloStore store] updateChecklistName:itemView.textField.stringValue
                                          forListID:itemView.trelloCheckListID
                                     withCompletion:^(id object, NSError *error)
        {

            [[self cardsVC] showCardSavingIndicator:NO];
            
            //TODO: don't reload all to change name - refactor this
            [self fetchChecklists];
            [self updateCardTodosStatus];

        }];

    }


}

- (void)addChecklist {
    
    if([SharedSettings isOffline]) {
        return;
    }

    [[self cardsVC] showCardSavingIndicator:YES];

    [[SDWTrelloStore store] addCheckListForCardID:self.card.trelloID withCompletion:^(SDWChecklistDisplayItem *checklist, NSError *error) {

        [[self cardsVC] showCardSavingIndicator:NO];

        if (!error) {
            NSMutableArray *newRaw = [NSMutableArray arrayWithArray:self.rawcheckLists];
            [newRaw addObject:checklist];
            self.rawcheckLists = [NSArray arrayWithArray:newRaw];

            [self.flatContent addObject:checklist.name];
            [self.todoSectionKeys addObject:checklist.trelloID];
            [self.checkListsTable reloadData];

            [self.checkListsTable scrollRowToVisible:self.flatContent.count-1];

            NSTableRowView *rowView = [self.checkListsTable rowViewAtRow:self.flatContent.count-1 makeIfNecessary:YES];
            SDWCheckItemTableCellView *cellView = rowView.subviews.firstObject;
            [cellView animateControlsOpacityIn:YES];

            self.addChecklistOnboard.hidden = YES;
        }

    }];
}


#pragma mark - Utils

- (void)updateCardTodosStatus {
    [[self cardsVC] updateCardDetails:self.card localOnly:NO];

}

- (NSString *)checkListNameFromID:(NSString *)checkListID {

    SDWChecklistDisplayItem *list = [self.rawcheckLists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"trelloID == %@",checkListID]].firstObject;
    return list.name;
}

@end
