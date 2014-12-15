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
#import "SDWCardViewController.h"
#import "SDWMainSplitController.h"

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

@property (strong) SDWCardsCollectionViewItem *lastSelectedItem;

@property NSUInteger dropIndex;
@property (strong) IBOutlet SDWProgressIndicator *mainProgressIndicator;
@property (strong) IBOutlet SDWProgressIndicator *cardActionIndicator;


@end

@implementation SDWCardsController


#pragma mark - Lifecycle

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

    [self subscribeToEvents];

    if (![self isShowingListCards]) {

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
        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        SDWCard *cardToRemove = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cardID == %@",note.userInfo[@"cardID"]]].firstObject;
        [arr removeObject:cardToRemove];

        self.cardsArrayController.content = arr;
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldCreateCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self addCard:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldFilterNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

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

    if (index >10000) {
        return NO;
    }
    return YES;
}

//TODO: refactor
- (NSUInteger)bottomObjectIndex:(NSArray *)arr {

    return arr.count == 0 ? 0 : arr.count-1;
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

    // 2. set positions to all cards equal to cards' indexes in array
    for (int i = 0; i<mutableArray.count; i++) {
        SDWCard *card = mutableArray[i];
        card.position = i;
    }

    return mutableArray;
    
}

#pragma mark - Card actions

- (void)updateCardDetails:(SDWCard *)card {

    [self showCardSavingIndicator:YES];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"name":card.name,
                                                                 @"desc":card.cardDescription,
                                                                 @"due":(card.dueDate && (id)card.dueDate != [NSNull null]) ? [NSNumber numberWithLongLong:[card.dueDate timeIntervalSince1970]*1000] : @""
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
    {

        [self showCardSavingIndicator:NO];

        SDWCard *updatedCard = [[SDWCard alloc]initWithAttributes:responseObject];
        [[self cardDetailsVC] setCard:updatedCard];

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:[self.collectionView.content indexOfObject:card] ];
        [arr insertObject:updatedCard atIndex:[self.collectionView.content indexOfObject:card]];
        [self reloadCollection:arr];


//        self.lastSelectedItem.selected = NO;
//        self.lastSelectedItem.textField.toolTip = self.lastSelectedItem.textField.stringValue;
//        [self.lastSelectedItem updateIndicators];


//        SDWCardsCollectionViewItem *selectedCard = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
//        selectedCard.textField.toolTip = selectedCard.textField.stringValue;
//        [selectedCard updateIndicators];

       //r [self reloadCards];


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showCardSavingIndicator:NO];

        CLS_LOG(@"err save - %@",error.localizedDescription);
    }];
}

- (void)updateCard:(SDWCard *)card {
    [self showCardSavingIndicator:YES];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"name":card.name} success:^(NSURLSessionDataTask *task, id responseObject) {

        [self showCardSavingIndicator:NO];

        self.lastSelectedItem.selected = NO;
        self.lastSelectedItem.textField.toolTip = self.lastSelectedItem.textField.stringValue;
        [self.lastSelectedItem.view setNeedsDisplay:YES];

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


                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      CLS_LOG(@"err save pos - %@",error.localizedDescription);
                                  }];

    [self showCardSavingIndicator:NO];

}

- (void)createCard:(SDWCard *)card {
    [self showCardSavingIndicator:YES];

    NSDictionary *params = @{
                             @"name":card.name,
                             @"due":@"",
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
         [[self cardDetailsVC] setCard:nil];

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

   // [self.loadingIndicator startAnimation:nil];
    [self.mainProgressIndicator startAnimation];

    [SDWUser findAll:^(NSArray *objs, NSError *err) {

        if (!err) {
            SharedSettings.selectedListUsers = objs;
            [self loadCardsForListID:self.currentListID];
        } else {
            self.reloadButton.hidden = NO;
            [self.mainProgressIndicator stopAnimation];
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

    [SDWCard findAll:^(NSArray *objs, NSError *err) {

        //[self.loadingIndicator stopAnimation:nil];
        [self.mainProgressIndicator stopAnimation];


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


    NSSortDescriptor *sortBy;


    if (SharedSettings.shouldFilterDueAccending) {

        sortBy = [[NSSortDescriptor alloc]initWithKey:@"dueDate" ascending:YES];

    } else if (SharedSettings.shouldFilterDueDecending) {

        sortBy = [[NSSortDescriptor alloc]initWithKey:@"dueDate" ascending:NO];

    } else {

        sortBy = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
    }


    if (SharedSettings.shouldFilter) {
        [self reloadCardsAndFilter:[objects sortedArrayUsingDescriptors:@[sortBy]]];
    } else {
        self.cardsArrayController.content = [objects sortedArrayUsingDescriptors:@[sortBy]];
    }

}

- (void)updateCardsPositions {

    for (SDWCard *card in self.cardsArrayController.content) {

        [self updateCardPosition:card];
        CLS_LOG(@"%@ - %lu",card.name,(unsigned long)card.position);
    }
}

#pragma mark - NSCollectionViewDelegate,NSCollectionViewDatasource


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

- (void)collectionItemViewClick:(NSCollectionViewItem *)sender {

    SDWCardsCollectionViewItem *selected = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
    selected.delegate = self;

    SDWCard *selectedCard = [self.cardsArrayController.arrangedObjects objectAtIndex:self.collectionView.selectionIndexes.firstIndex];
    [[self cardDetailsVC] setCard:selectedCard];
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

- (void)cardViewShouldDeselectCard:(SDWCardsCollectionViewItem *)cardView {

    [[self cardDetailsVC] setCard:nil];
}

- (void)cardViewShouldSaveCard:(SDWCardsCollectionViewItem *)cardView {

    self.addCardButton.enabled = YES;
    self.lastSelectedItem = cardView;

    SDWCard *card = [self.cardsArrayController.content objectAtIndex:self.collectionView.selectionIndexes.firstIndex];
    card.name = cardView.textField.stringValue;

    [[self cardDetailsVC] setCard:card];

    if (card.isSynced) {

        [self updateCard:card];
    }
    else {
        [self createCard:card];
    }
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

- (void)deleteCardWithID:(NSString *)cardID {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [self showCardSavingIndicator:NO];

        [[self cardDetailsVC] setCard:nil];

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
