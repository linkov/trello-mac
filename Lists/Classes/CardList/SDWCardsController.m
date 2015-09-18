//
//  CardsController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWCardsController.h"

/*-------View Controllers-------*/
#import "SDWCardViewController.h"
#import "SDWMainSplitController.h"

/*-------Frameworks-------*/

/*-------Views-------*/
#import "JWCTableView.h"
#import "SDWSingleCardTableCellView.h"
#import "PulseView.h"
#import "SDWProgressIndicator.h"
#import "SDWCardListView.h"

/*-------Helpers & Managers-------*/
#import "NSControl+DragInteraction.h"
#import "AFRecordPathManager.h"
#import "SDWAppSettings.h"
#import "NSColor+Util.h"
#import "SDWTrelloStore.h"
#import "Utils.h"
#import "Xtrace.h"
#import "NSColor+AppColors.h"
#import "Constants.h"

/*-------Models-------*/
#import "SDWBoard.h"
#import "SDWUser.h"
#import "SDWcard.h"

@interface SDWCardsController () <NSCollectionViewDelegate, NSControlInteractionDelegate, SDWSingleCardViewDelegate, JWCTableViewDataSource, JWCTableViewDelegate>
@property (strong) IBOutlet NSArrayController *cardsArrayController;

@property (strong) NSArray *storedUsers;
@property (strong) NSString *currentListID;
@property (strong) NSString *parentListName;
@property (strong) NSString *parentListID;
@property (strong) NSString *listName;
@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet NSButton *addCardButton;
@property (strong) IBOutlet NSTextField *listNameLabel;
@property (strong) IBOutlet NSButton *reloadButton;

@property (strong) SDWSingleCardTableCellView *lastSelectedItem;
@property (strong) SDWCard *lastSelectedCard;

@property NSUInteger dropIndex;
@property (strong) IBOutlet SDWProgressIndicator *mainProgressIndicator;
@property (strong) IBOutlet SDWProgressIndicator *cardActionIndicator;
@property (strong) IBOutlet JWCTableView *tableView;

@end

@implementation SDWCardsController

#pragma mark - Lifecycle

- (void)awakeFromNib {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.reloadButton.hidden = YES;
    self.mainBox.fillColor = [NSColor appBackgroundColorDark];
    self.tableView.backgroundColor = [NSColor clearColor];

    [self.tableView registerForDraggedTypes:@[@"REORDER_DRAG_TYPE"]];
    [self.tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    [self.tableView setDraggingDestinationFeedbackStyle:NSTableViewDraggingDestinationFeedbackStyleGap];

    [self.addCardButton registerForDraggedTypes:@[@"TRASH_DRAG_TYPE"]];
    self.addCardButton.interactionDelegate = self;
    [self subscribeToEvents];

    if (![self isShowingListCards]) {
        [self.addCardButton setHidden:YES];
        self.onboardingImage.hidden = NO;
    }
}

#pragma mark - Utils

- (SDWCardViewController *)cardDetailsVC {
    SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
    return main.cardDetailsVC;
}

- (void)showCardSavingIndicator:(BOOL)show {
    if (show) {
        [self.cardActionIndicator startAnimation];
    } else {
        [self.cardActionIndicator stopAnimation];
    }
}

- (void)subscribeToEvents {
    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidRemoveCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [[self cardDetailsVC] setCard:nil];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
        SDWCard *cardToRemove = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cardID == %@", note.userInfo[@"cardID"]]].firstObject;
        [arr removeObject:cardToRemove];

        self.cardsArrayController.content = arr;
        [self.tableView reloadData];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldCreateCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self addCard:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldFilterNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadCardsForListID:self.currentListID];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidChangeDotOptionNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadCardsForListID:self.currentListID];
    }];
}

- (BOOL)isShowingListCards {
    if (self.currentListID.length) {
        return YES;
    }

    return NO;
}

//TODO: refactor
- (BOOL)isValidIndex:(NSUInteger)index {
    if (index > 10000) {
        return NO;
    }
    return YES;
}

//TODO: refactor
- (NSUInteger)bottomObjectIndex:(NSArray *)arr {
    return arr.count == 0 ? 0 : arr.count - 1;
}

- (NSArray *)reorderFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inArray:(NSArray *)arr {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:arr];

    // 1. swap 2 elements
    SDWCard *movedCard = [mutableArray objectAtIndex:fromIndex];
    SDWCard *newSiblingCard = [mutableArray objectAtIndex:toIndex];

    NSUInteger movedCardPos = movedCard.position;
    NSUInteger newSiblingCardPos = newSiblingCard.position;

    movedCard.position = newSiblingCardPos;
    newSiblingCard.position = movedCardPos;

    [mutableArray removeObject:movedCard];
    [mutableArray insertObject:movedCard atIndex:toIndex];

    // 2. set positions to all cards equal to cards' indexes in array
    for (int i = 0; i < mutableArray.count; i++) {
        SDWCard *card = mutableArray[i];
        card.position = i;
    }

    return mutableArray;
}

#pragma mark - Card actions

- (void)updateCardDetails:(SDWCard *)card localOnly:(BOOL)local {
    if (local) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:[self.cardsArrayController.content indexOfObject:card] ];
        [arr insertObject:card atIndex:[self.cardsArrayController.content indexOfObject:card]];
        [self reloadCollection:arr];
        return;
    }

    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] updateCard:card withCompletion:^(id object, NSError *error) {
        [self showCardSavingIndicator:NO];

        if (!error) {
            SDWCard *updatedCard = [[SDWCard alloc]initWithAttributes:object];
            [[self cardDetailsVC] setCard:updatedCard];

            //TODO: refactor this
            if (![self isValidIndex:[self.cardsArrayController.content indexOfObject:card]]) {
                [self reloadCards];
                return;
            }

            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
            [arr removeObjectAtIndex:[self.cardsArrayController.content indexOfObject:card] ];
            [arr insertObject:updatedCard atIndex:[self.cardsArrayController.content indexOfObject:card]];
            [self reloadCollection:arr];
        }
    }];
}

- (void)updateCard:(SDWCard *)card {
    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] updateCard:card withCompletion:^(id object, NSError *error) {
        [self showCardSavingIndicator:NO];

        if (!error) {
            self.lastSelectedItem.mainBox.selected = NO;
            self.lastSelectedItem.mainBox.textField.toolTip = self.lastSelectedItem.textField.stringValue;
            [self.lastSelectedItem setNeedsDisplay:YES];
        }
    }];
}

- (void)updateCardPosition:(SDWCard *)card {
    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] moveCardID:card.cardID
                            toPosition:[NSNumber numberWithInteger:card.position]
                            completion:^(id object, NSError *error)
    {
        [self showCardSavingIndicator:NO];
    }];
}

- (void)createCard:(SDWCard *)card {
    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] createCardWithName:card.name
                                        listID:self.currentListID
                                withCompletion:^(id object, NSError *error)
    {
        [self showCardSavingIndicator:NO];

        if (!error) {
            SDWCard *updatedCard = [[SDWCard alloc]initWithAttributes:object];

            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
            [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
            [arr insertObject:updatedCard atIndex:[self bottomObjectIndex:arr]];
            [self reloadCollection:arr];
            [[self cardDetailsVC] setCard:updatedCard];
        }
    }];
}

- (void)dismissNewEditedCard {
    self.addCardButton.enabled = YES;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
    self.cardsArrayController.content = arr;
    [self.tableView reloadData];
}

- (void)clearCards {
    self.cardsArrayController.content = @[];
    self.listNameLabel.hidden = YES;
}

- (void)setupCardsForList:(SDWBoard *)list parentList:(SDWBoard *)parentList {
    [self.onboardingImage removeFromSuperview];
    self.listNameLabel.hidden = NO;
    self.reloadButton.hidden = YES;
    self.parentListName = parentList.name;
    self.listName = list.name;
    self.currentListID = list.boardID;
    self.parentListID = parentList.boardID;

    [self reloadCards];
}

- (IBAction)reloadCardsAfterFail:(id)sender {
    self.reloadButton.hidden = YES;
    [self reloadCards];
}

- (void)reloadCards {
    [[self cardDetailsVC] setCard:nil];

    if (![self isShowingListCards]) {
        return;
    }

    SharedSettings.selectedListUsers = nil;

    /*
       clean previous cards before loading new ones
       so that loading indicator is not on top of cards
     */
    self.cardsArrayController.content = nil;
    [self.tableView reloadData];

    [self loadMembers:self.parentListID];
}

- (void)reloadCardsAndFilter:(NSArray *)content {
    NSMutableArray *filteredCards = [NSMutableArray array];
    for (SDWCard *card in content) {
        NSString *idM = [card.members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self==%@", SharedSettings.userID]].firstObject;

        if (idM) {
            [filteredCards addObject:card];
        }
    }

    self.cardsArrayController.content = filteredCards;
}

- (void)loadMembers:(NSString *)listID {
    NSString *URL = [NSString stringWithFormat:@"boards/%@/members?", listID];
    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
              forModel:[SDWUser class]
        toConcretePath:URL];

    [self.mainProgressIndicator startAnimation];

    [SDWUser findAll:^(NSArray *objs, NSError *err) {
        if (!err) {
            SharedSettings.selectedListUsers = objs;
            [self loadCardsForListID:self.currentListID];
        } else {
            self.reloadButton.hidden = NO;
            [self.mainProgressIndicator stopAnimation];
            //CLS_LOG(@"err = %@", err.localizedDescription);
        }
    }];
}

- (void)loadCardsForListID:(NSString *)listID {
    NSString *URL = [NSString stringWithFormat:@"lists/%@/cards", listID];
    NSString *URL2 = [NSString stringWithFormat:@"?lists=open&cards=open"];

    NSString *URLF = [NSString stringWithFormat:@"%@%@", URL, URL2];

    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
              forModel:[SDWCard class]
        toConcretePath:URLF];

    [SDWCard findAll:^(NSArray *objs, NSError *err) {
        //[self.loadingIndicator stopAnimation:nil];
        [self.mainProgressIndicator stopAnimation];

        if (!err) {
            self.reloadButton.hidden = YES;
            [self reloadCollection:objs];
        } else {
            self.reloadButton.hidden = NO;
            //CLS_LOG(@"err = %@", err.localizedDescription);
        }
    }];
}

- (void)reloadCollection:(NSArray *)objects {
    [self.addCardButton setHidden:NO];

    NSSortDescriptor *sortBy;

    if (SharedSettings.shouldFilterDueAccending) {
        sortBy = [[NSSortDescriptor alloc]initWithKey:@"dueDate" ascending:YES selector:@selector(compare:)];
    } else if (SharedSettings.shouldFilterDueDecending) {
        sortBy = [[NSSortDescriptor alloc]initWithKey:@"dueDate" ascending:NO selector:@selector(compare:)];
    } else {
        sortBy = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES selector:@selector(compare:)];
    }

    if (SharedSettings.shouldFilter) {
        [self reloadCardsAndFilter:[objects sortedArrayUsingDescriptors:@[sortBy]]];
    } else {
        self.cardsArrayController.content = [objects sortedArrayUsingDescriptors:@[sortBy]];
    }

    // tableView implementation
    [self.tableView reloadData];
    [self.tableView deselectAll:nil];
}

- (void)updateCardsPositions {
    for (SDWCard *card in self.cardsArrayController.content) {
        [self updateCardPosition:card];
        // CLS_LOG(@"%@ - %lu", card.name, (unsigned long)card.position);
    }
}

- (IBAction)addCard:(id)sender {
    if (![self isShowingListCards]) {
        return;
    }

    SDWCard *newCard = [SDWCard new];
    newCard.boardID = self.parentListID;
    newCard.name = @"";
    newCard.isSynced = NO;

    self.lastSelectedCard = newCard;

    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr addObject:newCard];

    self.cardsArrayController.content = arr;

    NSUInteger lastIndex = arr.count - 1;
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:lastIndex] withAnimation:NSTableViewAnimationEffectNone];

    SDWSingleCardTableCellView *newRow = (SDWSingleCardTableCellView *)[self.tableView viewAtColumn:0 row:lastIndex makeIfNecessary:NO];
    newRow.delegate = self;
    newRow.mainBox.textField.delegate = newRow;
    newRow.mainBox.selected = YES;
    newRow.mainBox.textField.editable = YES;
    [newRow.mainBox.textField becomeFirstResponder];

    self.addCardButton.enabled = NO;
}

#pragma mark - SDWSingleCardViewDelegate

- (void)cardViewDidSelectCard:(SDWSingleCardTableCellView *)cardView {
    SDWCard *selectedCard = [self.cardsArrayController.arrangedObjects objectAtIndex:[self.tableView rowForView:cardView]];
    self.lastSelectedCard = selectedCard;
}

- (void)cardViewShouldContainLabelColors:(NSString *)colors {
    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] updateLabelsForCardID:self.lastSelectedCard.cardID
                                           colors:colors
                                       completion:^(id object, NSError *error)
    {
        [self showCardSavingIndicator:NO];
    }];
}

- (void)cardViewShouldRemoveLabelOfColor:(NSString *)color {
    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] removeLabelForCardID:self.lastSelectedCard.cardID
                                           color:color
                                      completion:^(id object, NSError *error)
    {
        [self showCardSavingIndicator:NO];
    }];
}

- (void)cardViewShouldDeselectCard:(SDWSingleCardTableCellView *)cardView {
    if (![self isValidIndex:self.cardsArrayController.selectionIndex]) {
        [[self cardDetailsVC] setCard:nil];
    }
}

- (void)cardViewShouldSaveCard:(SDWSingleCardTableCellView *)cardView {
    self.addCardButton.enabled = YES;
    self.lastSelectedItem = cardView;
    self.lastSelectedItem.mainBox.selected = NO;

    SDWCard *card = self.lastSelectedCard;

    card.name = cardView.mainBox.textField.stringValue;

    [[self cardDetailsVC] setCard:card];

    if (card.isSynced) {
        [self updateCard:card];
    } else {
        [self createCard:card];
    }
}

- (void)cardViewShouldDismissCard:(SDWSingleCardTableCellView *)cardView {
    [self dismissNewEditedCard];
}

#pragma mark - SDWMenuItemDelegate

- (void)control:(NSControl *)control didAcceptDropWithPasteBoard:(NSPasteboard *)pasteboard {
    NSData *data = [pasteboard dataForType:@"TRASH_DRAG_TYPE"];
    NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self archiveCardWithID:dataDict[@"cardID"]];
}

- (void)archiveCardWithID:(NSString *)cardID {
    [self showCardSavingIndicator:YES];

    [[self cardDetailsVC] setCard:nil];

    SDWCard *cardToDelete = [self.cardsArrayController.content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cardID == %@", cardID]].firstObject;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObject:cardToDelete];
    self.cardsArrayController.content = arr;
    [self.tableView reloadData];

    [[SDWTrelloStore store] archiveCardID:cardID withCompletion:^(id object, NSError *error) {
        [self showCardSavingIndicator:NO];

        if (!error) {
        }
    }];
}

// TableView implementation

#pragma mark - JWCTableViewDataSource, JWCTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section {
    return NO;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDWSingleCardTableCellView *selectedCell = [self.tableView viewAtColumn:0 row:indexPath.row makeIfNecessary:NO];
    [selectedCell.mainBox setSelected:YES];
    selectedCell.delegate = self;
    selectedCell.mainBox.textField.delegate = selectedCell;

    //TODO: refactor
    for (int i = 0; i < [self.cardsArrayController.content count]; i++) {
        SDWSingleCardTableCellView *cell = [self.tableView viewAtColumn:0 row:i makeIfNecessary:NO];

        if (cell != selectedCell) {
            [cell.mainBox setSelected:NO];
        }
    }

    SDWCard *selectedCard = [self.cardsArrayController.arrangedObjects objectAtIndex:indexPath.row];
    self.lastSelectedCard = selectedCard;
    [[self cardDetailsVC] setCard:selectedCard];

    return YES;
}

- (NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cardsArrayController.arrangedObjects count];
}

- (NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {
    return 1;
}

- (BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightForHeaderViewForSection:(NSInteger)section {
    return 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDWCard *card = self.cardsArrayController.arrangedObjects[indexPath.row];

    CGRect rec = [card.name boundingRectWithSize:CGSizeMake([self widthForMembersCount:card.members.count] - 2, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:11]}];
    CGFloat height = ceilf(rec.size.height);

    if (height > 14) {
        return height + 7 + 7;
    }

    return 27;
}

- (NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {
    if ([self.cardsArrayController.arrangedObjects count] == 0) {
        return nil;
    }

    SDWCard *card = self.cardsArrayController.arrangedObjects[indexPath.row];
    SDWSingleCardTableCellView *view = [self.tableView makeViewWithIdentifier:@"cellView" owner:self];
    view.mainBox.textField.stringValue = card.name;
    view.widthConstraint.constant = [self widthForMembersCount:card.members.count];
    view.textField.backgroundColor = [NSColor clearColor];
    view.delegate = self;
    view.mainBox.selected = NO;

    /* mark labels */
    if (SharedSettings.shouldShowCardLabels == YES) {
        view.mainBox.labels = card.labels;
    } else {
        view.mainBox.labels = @[];
    }

    /* mark due */
    NSDate *due = card.dueDate;
    if (due != nil && [due timeIntervalSinceNow] < 0.0) {
        [view.mainBox setShouldDrawSideLine:YES];
    } else if (due != nil && ([due timeIntervalSinceNow] > 0.0 && [due timeIntervalSinceNow] < 100000) ) {
        [view.mainBox setShouldDrawSideLineAmber:YES];
    } else {
        [view.mainBox setShouldDrawSideLine:NO];
        [view.mainBox setShouldDrawSideLineAmber:NO];
    }

    /* mark dot */
    switch (SharedSettings.dotOption) {
        case SDWDotOptionHasDescription: {
            NSString *descString = card.cardDescription;

            if (descString.length > 0) {
                [view.mainBox setHasDot:YES];
            } else {
                [view.mainBox setHasDot:NO];
            }
        }
        break;
        case SDWDotOptionNoDue: {
            NSDate *due = card.dueDate;

            if (due == nil) {
                [view.mainBox setHasDot:YES];
            }
        }

        break;

        case SDWDotOptionHasOpenTodos: {
            BOOL hasOpenTodos = [[self.representedObject valueForKey:@"hasOpenTodos"] boolValue];

            if (hasOpenTodos) {
                [view.mainBox setHasDot:YES];
            }
        }

        break;

        case SDWDotOptionOff: {
        }

        break;

        default:
            break;
    }

    /* load card users */
    [view.stackView.views makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray *members = card.members;

//    NSMutableArray *testMembers = [NSMutableArray arrayWithArray:members];
//    [testMembers addObject:@"DL"];
//    [testMembers addObject:@"MK"];

    for (NSString *memberID in members) {
        NSTextField *text = [[NSTextField alloc]init];

        [text setWantsLayer:YES];
        [text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [text setFont:[NSFont systemFontOfSize:9]];
        [text setTextColor:[NSColor colorWithHexColorString:@"3E6378"]];
        [text setStringValue:[self memberNameFromID:memberID] ];
        [text setEditable:NO];
        text.alignment = NSCenterTextAlignment;

        text.layer.cornerRadius = 1.5;
        text.layer.borderWidth = 1;
        text.layer.borderColor = [NSColor colorWithHexColorString:@"3E6378"].CGColor;

        if (text.stringValue.length > 0) {
            //TODO: remove this hack
            if (card.labels.count == 0) {
                for (NSLayoutConstraint *co in view.mainBox.constraints) {
                    if (co.priority == 750) {
                        co.constant = 7;
                    }
                }
            } else {
                for (NSLayoutConstraint *co in view.mainBox.constraints) {
                    if (co.priority == 750) {
                        co.constant = 3;
                    }
                }
            }

            [view.stackView addView:text inGravity:NSStackViewGravityTrailing];
        }
    }

    return view;
}

- (void)_dbgArrayElementsWithTitle:(NSString *)title {
    //CLS_LOG(@"--------------%@-------------\n", title);

    for (SDWCard *card in self.cardsArrayController.content) {
        //CLS_LOG(@"%@ - %lu", card.name, (unsigned long)card.position);
    }
}

#pragma mark - JWCTableViewDelegate ( Drag / Drop )

- (BOOL)_jwcTableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    SDWCard *card = [self.cardsArrayController.content objectAtIndex:rowIndexes.firstIndex];
    NSDictionary *cardDict = @{
        @"cardID": card.cardID,
        @"itemID": card.cardID,
        @"boardID": card.boardID,
        @"itemIndex": [NSNumber numberWithInteger:rowIndexes.firstIndex]
    };

    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:cardDict];
    [pboard setData:indexData forType:@"TRASH_DRAG_TYPE"];
    [pboard setData:indexData forType:@"REORDER_DRAG_TYPE"];

    return YES;
}

- (NSDragOperation)_jwcTableView:(NSTableView *)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    if ([self.cardsArrayController.arrangedObjects count] == 1) {
        return NSDragOperationNone;
    }

    NSDragOperation dragOp = NSDragOperationNone;

    if (op == NSTableViewDropAbove) {
        dragOp = NSDragOperationMove;
    } else if (op == NSTableViewDropOn) {
        NSUInteger inx = row;

        if ([self isValidIndex:inx]) {
            self.dropIndex = inx;
        }
        dragOp = NSDragOperationNone;
    }

    return dragOp;
}

- (BOOL)_jwcTableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
                  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    if (self.dropIndex > [self.cardsArrayController.arrangedObjects count]) {
        return NO;
    }

    NSPasteboard *pBoard = [info draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"REORDER_DRAG_TYPE"];

    // [self _dbgArrayElementsWithTitle:@"acceptDrop_before"];

    //TODO: refactor
    if (indexData && self.dropIndex < 100000) {
        NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        NSUInteger itemMovedFromIndex = [cardDict[@"itemIndex"] integerValue];

        self.cardsArrayController.content = [self reorderFromIndex:itemMovedFromIndex toIndex:self.dropIndex inArray:self.cardsArrayController.content];
    }

    [self reloadCollection:self.cardsArrayController.content];

    // [self _dbgArrayElementsWithTitle:@"acceptDrop_after"];

    [self updateCardsPositions];
    return YES;
}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {
    self.addCardButton.image = [NSImage imageNamed:@"archive"];
}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    self.addCardButton.image = [NSImage imageNamed:@"addCard"];
}

#pragma mark - Utils

- (NSString *)memberNameFromID:(NSString *)userID {
    for (SDWUser *user in SharedSettings.selectedListUsers) {
        if ([user.userID isEqualToString:userID]) {
            NSString *str = [Utils twoLetterIDFromName:user.name];

            return str;
        }
    }
    return @"NA";
}

- (CGFloat)widthForMembersCount:(NSUInteger)count {
    CGFloat width;
    if (count == 0) {
        width = 375;
    } else if (count == 1) {
        width = 347;
    } else if (count > 2) {
        width = 297;
    }

    return width;
}

@end
