//
//  CardsController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "SDWBoard.h"
#import "SDWUser.h"
#import "SDWcard.h"
#import "AFRecordPathManager.h"
#import "SDWCardsController.h"
#import "SDWCardsCollectionViewItem.h"
#import "SDWAppSettings.h"
#import "SDWMenuItemImageView.h"
#import "PulseView.h"
#import "SDWProgressIndicator.h"

@interface SDWCardsController () <NSCollectionViewDelegate,SDWMenuItemDelegate,SDWCardViewDelegate>
@property (strong) IBOutlet NSArrayController *cardsArrayController;
@property (strong) IBOutlet NSCollectionView *collectionView;

@property (strong) NSArray *storedUsers;
@property (strong) NSString *currentListID;
@property (strong) NSString *parentListName;
@property (strong) NSString *parentListID;
@property (strong) NSString *listName;
@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet SDWMenuItemImageView *trashImageView;
@property (strong) IBOutlet NSButton *addCardButton;
@property (strong) IBOutlet NSTextField *listNameLabel;
@property (strong) IBOutlet NSButton *reloadButton;
@property (strong) IBOutlet NSProgressIndicator *cardSavingIndicator;

@property NSUInteger dropIndex;

@end

@implementation SDWCardsController


- (void)awakeFromNib {

    [self.addCardButton setHidden:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];

    self.reloadButton.hidden = YES;
    self.mainBox.fillColor  = [SharedSettings appBackgroundColorDark];
    self.collectionView.backgroundColors = @[[SharedSettings appBackgroundColorDark]];

	self.collectionView.itemPrototype = [self.storyboard instantiateControllerWithIdentifier:@"collectionProto"];
    [self.collectionView registerForDraggedTypes:@[@"REORDER_DRAG_TYPE"]];
    NSSize minSize = NSMakeSize(200,30);
    [self.collectionView setMaxItemSize:minSize];

    [self.trashImageView registerForDraggedTypes:@[@"TRASH_DRAG_TYPE"]];
    [self.trashImageView setHidden:YES];
    self.trashImageView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidRemoveCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:self.cardsArrayController.selectionIndex];
        self.cardsArrayController.content = arr;
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldCreateCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self addCard:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldFilterNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self loadCardsForListID:self.currentListID];

    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldRemoveCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self deleteSelectedCard];

    }];


    if (![self isShowingListCards]) {

//        SDWProgressIndicator *progress  = [[SDWProgressIndicator alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//
//        progress.wantsLayer = YES;
//        [progress setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//        
//        [self.view addSubview:progress];
//
//
//        NSArray *constaintsProgressV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[progress(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(progress)];
//        NSArray *constaintsProgressH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[progress(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(progress)];
//
//
//        [self.view addConstraints:constaintsProgressV];
//        [self.view addConstraints:constaintsProgressH];
//
//        NSLayoutConstraint *centerProgressX;
//        centerProgressX = [NSLayoutConstraint constraintWithItem:progress
//                                                       attribute:NSLayoutAttributeCenterX
//                                                       relatedBy:NSLayoutRelationEqual
//                                                          toItem:progress.superview
//                                                       attribute:NSLayoutAttributeCenterX
//                                                      multiplier:1
//                                                        constant:0];
//        [self.view addConstraint:centerProgressX];
//
//        NSLayoutConstraint *centerProgressY;
//        centerProgressY = [NSLayoutConstraint constraintWithItem:progress
//                                               attribute:NSLayoutAttributeCenterY
//                                               relatedBy:NSLayoutRelationEqual
//                                                  toItem:progress.superview
//                                               attribute:NSLayoutAttributeCenterY
//                                              multiplier:1
//                                                constant:0];
//        [self.view addConstraint:centerProgressY];

        //[progress animateOnce];

    }


}

- (void)clearCards {

    self.cardsArrayController.content = @[];
    self.listNameLabel.hidden = YES;
}

- (void)setupCardsForList:(SDWBoard *)list parentList:(SDWBoard *)parentList {

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

    if (![self isShowingListCards]) {
        return;
    }

    SharedSettings.selectedListUsers = nil;
    self.cardsArrayController.content = nil;
    [self loadMembers:self.parentListID];

}

- (void)reloadCardsAndFilter:(NSArray *)content {
    NSMutableArray *filteredCards = [NSMutableArray array];
    for (SDWCard *card in content) {

        NSString *idM = [card.members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self==%@",SharedSettings.userID]].firstObject;

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

    [self.loadingIndicator startAnimation:nil];

    [SDWUser findAll:^(NSArray *objs, NSError *err) {

        [self.loadingIndicator stopAnimation:nil];

        if (!err) {
            SharedSettings.selectedListUsers = objs;
            [self loadCardsForListID:self.currentListID];
        } else {
            self.reloadButton.hidden = NO;
            CLS_LOG(@"err = %@", err.localizedDescription);
        }
    }];

}

- (void)loadCardsForListID:(NSString *)listID {

    NSString *URL = [NSString stringWithFormat:@"lists/%@/cards", listID];
    NSString *URL2 = [NSString stringWithFormat:@"?lists=open&cards=open&card_fields=name,pos,idMembers,labels"];

    NSString *URLF = [NSString stringWithFormat:@"%@%@", URL, URL2];

    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWCard class]
	    toConcretePath:URLF];

    [self.loadingIndicator startAnimation:nil];

    [SDWCard findAll:^(NSArray *objs, NSError *err) {

        [self.loadingIndicator stopAnimation:nil];


        if (!err) {
            self.reloadButton.hidden = YES;
            [self reloadCollection:objs];
        } else {
            self.reloadButton.hidden = NO;
            CLS_LOG(@"err = %@", err.localizedDescription);
        }
    }];
}

- (void)reloadCollection:(NSArray *)objects {

    [self.addCardButton setHidden:NO];
    NSSortDescriptor *sortByPos = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];

    if (SharedSettings.shouldFilter) {
        [self reloadCardsAndFilter:[objects sortedArrayUsingDescriptors:@[sortByPos]]];
    } else {
        self.cardsArrayController.content = [objects sortedArrayUsingDescriptors:@[sortByPos]];
    }

}

- (void)updateCardsPositions {

    for (SDWCard *card in self.cardsArrayController.content) {

        [self updateCardPosition:card];
        CLS_LOG(@"%@ - %lu",card.name,(unsigned long)card.position);
    }
}

#pragma mark - NSCollectionViewDelegate


- (void)collectionView:(NSCollectionView *)collectionView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint dragOperation:(NSDragOperation)operation {

    [self.trashImageView setHidden:YES];
    [self.addCardButton setHidden:NO];


}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {

    if (index > [self.cardsArrayController.arrangedObjects count]) {
        return NO;
    }

    NSPasteboard *pBoard = [draggingInfo draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"REORDER_DRAG_TYPE"];

   // [self _dbgArrayElementsWithTitle:@"acceptDrop_before"];

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

- (NSArray *)reorderFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inArray:(NSArray *)arr {

    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:arr];

    // 1. swap 2 elements
    SDWCard *movedCard = [mutableArray objectAtIndex:fromIndex];
    SDWCard *newSiblingCard = [mutableArray objectAtIndex:self.dropIndex];

    NSUInteger movedCardPos = movedCard.position;
    NSUInteger newSiblingCardPos = newSiblingCard.position;

    movedCard.position = newSiblingCardPos;
    newSiblingCard.position = movedCardPos;

    [mutableArray removeObject:movedCard];
    [mutableArray insertObject:movedCard atIndex:self.dropIndex];

    for (int i = 0; i<mutableArray.count; i++) {
        SDWCard *card = mutableArray[i];
        card.position = i;
    }

    return mutableArray;

}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event {

    [self.trashImageView setHidden:NO];
    [self.addCardButton setHidden:YES];
    return YES;
}

-(NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {

    if ([self.cardsArrayController.arrangedObjects count] == 1) {
        return NSDragOperationNone;
    }

    NSDragOperation dragOp;

    if (*proposedDropOperation == NSCollectionViewDropBefore ) {

        dragOp = NSDragOperationMove;

    } else if (*proposedDropOperation == NSCollectionViewDropOn ) {

        NSUInteger inx = *proposedDropIndex;

        if ([self isValidIndex:inx]) {
            self.dropIndex = inx;
        }
        dragOp = NSDragOperationNone;

    }

    return dragOp;
}

//TODO: refactor
- (BOOL)isValidIndex:(NSUInteger)index {

    if (index >10000) {
        return NO;
    }
    return YES;
}

//TODO: refactor
- (NSUInteger)bottomObjectIndex:(NSArray *)arr {

    return arr.count == 0 ? 0 : arr.count-1;
}

- (void)_dbgArrayElementsWithTitle:(NSString *)title {

    CLS_LOG(@"--------------%@-------------\n",title);

    for (SDWCard *card in self.cardsArrayController.content) {

        CLS_LOG(@"%@ - %lu",card.name,(unsigned long)card.position);
    }
}

-(BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard {

    SDWCard *card = [self.cardsArrayController.content objectAtIndex:indexes.firstIndex];
    NSDictionary *cardDict = @{
                               @"cardID":card.cardID,
                               @"boardID":card.boardID,
                               @"itemIndex":[NSNumber numberWithInteger:indexes.firstIndex]
                               };

    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:cardDict];
    [pasteboard setData:indexData forType:@"TRASH_DRAG_TYPE"];
    [pasteboard setData:indexData forType:@"REORDER_DRAG_TYPE"];

    return YES;
}

- (void)collectionItemViewDoubleClick:(NSCollectionViewItem *)sender {

    SDWCardsCollectionViewItem *selected = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
    selected.delegate = self;
}

- (BOOL)isShowingListCards {

    if (self.currentListID.length) {
        return YES;
    }

    return NO;
}

- (IBAction)addCard:(id)sender {

    if (![self isShowingListCards]) {
        return;
    }

    SDWCard *newCard = [SDWCard new];
    newCard.boardID = self.parentListID;
    newCard.name = @"";
    newCard.isSynced = NO;

    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr insertObject:newCard atIndex:arr.count];

    self.cardsArrayController.content = arr;

    SDWCardsCollectionViewItem *newRow = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:[self bottomObjectIndex:arr]];
    newRow.delegate = self;
    newRow.selected = YES;
    newRow.textField.editable = YES;
    [newRow.textField becomeFirstResponder];

    self.addCardButton.enabled = NO;

}


#pragma mark - SDWCardViewDelegate

- (void)cardViewShouldSaveCard:(SDWCardsCollectionViewItem *)cardView {

    self.addCardButton.enabled = YES;

    SDWCard *card = [self.cardsArrayController.content objectAtIndex:self.collectionView.selectionIndexes.firstIndex];
    card.name = cardView.textField.stringValue;


    if (card.isSynced) {

        [self updateCard:card];
    }
    else {
        [self createCard:card];
    }
}

- (void)showCardSavingIndicator:(BOOL)show {

    if (show) {
        self.cardSavingIndicator.hidden = NO;
        [self.cardSavingIndicator startAnimation:nil];
    } else {
        self.cardSavingIndicator.hidden = YES;
        [self.cardSavingIndicator stopAnimation:nil];
    }

}

- (void)updateCard:(SDWCard *)card {

    [self showCardSavingIndicator:YES];

    self.cardSavingIndicator.hidden = NO;
    [self.cardSavingIndicator startAnimation:nil];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"name":card.name} success:^(NSURLSessionDataTask *task, id responseObject) {

        [self showCardSavingIndicator:NO];
        SDWCardsCollectionViewItem *selectedCard = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
        selectedCard.selected = NO;
        selectedCard.textField.toolTip = selectedCard.textField.stringValue;
        [selectedCard.view setNeedsDisplay:YES];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showCardSavingIndicator:NO];

        CLS_LOG(@"err save - %@",error.localizedDescription);
    }];

}


- (void)updateCardPosition:(SDWCard *)card {

    [self showCardSavingIndicator:YES];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/pos?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"value":[NSNumber numberWithInteger:card.position],
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

        [self showCardSavingIndicator:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       [self showCardSavingIndicator:NO];
        CLS_LOG(@"err save pos - %@",error.localizedDescription);
    }];
    
}

- (void)createCard:(SDWCard *)card {
    [self showCardSavingIndicator:YES];

    NSDictionary *params = @{
                             @"name":card.name,
                             @"due":@"null",
                             @"idList":self.currentListID,
                             @"urlSource":@"null"
                             };

    [[AFTrelloAPIClient sharedClient] POST:@"cards?"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject)
    {

        [self showCardSavingIndicator:NO];

        SDWCard *updatedCard = [[SDWCard alloc]initWithAttributes:responseObject];

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
        [arr insertObject:updatedCard atIndex:[self bottomObjectIndex:arr]];
        [self reloadCollection:arr];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showCardSavingIndicator:NO];
        CLS_LOG(@"err save - %@",error.localizedDescription);
    }];
}

- (void)dismissNewEditedCard {

    self.addCardButton.enabled = YES;
    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
    self.cardsArrayController.content = arr;
}

- (void)cardViewShouldDismissCard:(SDWCardsCollectionViewItem *)cardView {

    [self dismissNewEditedCard];
}

#pragma mark - SDWMenuItemDelegate

- (void)menuItemShouldValidateDropWithAction:(SDWMenuItemDropAction)action objectID:(NSString *)objectID {

    if (action == SDWMenuItemDropActionDelete) {

        [self showCardSavingIndicator:YES];

        [self deleteCardWithID:objectID];
    }
}

- (void)deleteSelectedCard {

    SDWCard *card = [self.cardsArrayController.content objectAtIndex:self.collectionView.selectionIndexes.firstIndex];
    [self deleteCardWithID:card.cardID];

}

- (void)deleteCardWithID:(NSString *)cardID {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [self showCardSavingIndicator:NO];
        //TODO: don't rely on selectionIndex in the future
        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:self.cardsArrayController.selectionIndex];
        self.cardsArrayController.content = arr;

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showCardSavingIndicator:NO];
        CLS_LOG(@"err - %@",error.localizedDescription);
    }];
}

@end
