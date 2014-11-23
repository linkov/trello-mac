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
            NSLog(@"err = %@", err.localizedDescription);
        }
    }];

}

- (void)loadCardsForListID:(NSString *)listID {

//    PulseView *pulse = [[PulseView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
//    pulse.wantsLayer = YES;
//    [self.view addSubview:pulse];

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
            NSLog(@"err = %@", err.localizedDescription);
        }
    }];
}

- (void)reloadCollection:(NSArray *)objects {

    [self.addCardButton setHidden:NO];
    NSSortDescriptor *sortByTime = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];

    if (SharedSettings.shouldFilter) {
        [self reloadCardsAndFilter:[objects sortedArrayUsingDescriptors:@[sortByTime]]];
    } else {
        self.cardsArrayController.content = [objects sortedArrayUsingDescriptors:@[sortByTime]];
    }

}

- (void)updateCardsPositions {

    for (SDWCard *card in self.cardsArrayController.content) {

        [self updateCardPosition:card];
        NSLog(@"%@ - %lu",card.name,(unsigned long)card.position);
    }
}

#pragma mark - NSCollectionViewDelegate


- (void)collectionView:(NSCollectionView *)collectionView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint dragOperation:(NSDragOperation)operation {

    [self.trashImageView setHidden:YES];
    [self.addCardButton setHidden:NO];


}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {

    NSLog(@"index - %li",(long)index);

    NSPasteboard *pBoard = [draggingInfo draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"REORDER_DRAG_TYPE"];

//    [self _dbgArrayElementsWithTitle:@"acceptDrop_before"];

    if (indexData && self.dropIndex < 100000) {

        NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        NSUInteger itemMovedFromIndex = [cardDict[@"itemIndex"] integerValue];

        self.cardsArrayController.content = [self reorderFromIndex:itemMovedFromIndex toIndex:self.dropIndex inArray:self.cardsArrayController.content];
    }

    [self reloadCollection:self.cardsArrayController.content];

//    [self _dbgArrayElementsWithTitle:@"acceptDrop_after"];

    [self updateCardsPositions];
    return YES;
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

    [mutableArray replaceObjectAtIndex:fromIndex withObject:movedCard];
    [mutableArray replaceObjectAtIndex:toIndex withObject:newSiblingCard];


    // 2. swap indexes of all elements between fromIndex and toIndex by one

    NSUInteger iterateFrom;
    NSUInteger iterateTo;

    if (![self isValidIndex:iterateFrom] || ![self isValidIndex:iterateTo]) {
        return mutableArray;
    }

    if (fromIndex+1 <= toIndex) {

        iterateFrom = fromIndex+1;
        iterateTo = toIndex;

    } else if ( (int)fromIndex-1 > toIndex) {

        iterateFrom = toIndex;
        iterateTo = fromIndex-1;

    }

    for (NSUInteger i = iterateFrom; i<iterateTo; i++) {

        SDWCard *card1 = [mutableArray objectAtIndex:i];
        SDWCard *card2 = [mutableArray objectAtIndex:i+1];

        NSUInteger movedCardPos = card1.position;
        NSUInteger newSiblingCardPos = card2.position;

        card1.position = newSiblingCardPos;
        card2.position = movedCardPos;

        [mutableArray replaceObjectAtIndex:i withObject:card1];
        [mutableArray replaceObjectAtIndex:i+1 withObject:card2];

    }

    return mutableArray;

}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event {
    [self.trashImageView setHidden:NO];
    [self.addCardButton setHidden:YES];
    return YES;
}

-(NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {

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

    NSLog(@"--------------%@-------------\n",title);

    for (SDWCard *card in self.cardsArrayController.content) {

        NSLog(@"%@ - %lu",card.name,(unsigned long)card.position);
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


- (IBAction)addCard:(id)sender {

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
        [selectedCard.view setNeedsDisplay:YES];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showCardSavingIndicator:NO];

        NSLog(@"err save - %@",error.localizedDescription);
    }];

}


- (void)updateCardPosition:(SDWCard *)card {

    [self showCardSavingIndicator:YES];
//
//    self.cardSavingIndicator.hidden = NO;
//    [self.cardSavingIndicator startAnimation:nil];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/pos?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"value":[NSNumber numberWithInteger:card.position],
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

        [self showCardSavingIndicator:NO];
//        SDWCardsCollectionViewItem *selectedCard = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
//        selectedCard.selected = NO;
//        [selectedCard.view setNeedsDisplay:YES];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       //[self showCardSavingIndicator:NO];

        NSLog(@"err save pos - %@",error.localizedDescription);
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

        NSLog(@"err save - %@",error.localizedDescription);
    }];
}

- (void)cardViewShouldDismissCard:(SDWCardsCollectionViewItem *)cardView {
    self.addCardButton.enabled = YES;
    
    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
    self.cardsArrayController.content = arr;
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
        NSLog(@"err - %@",error.localizedDescription);
    }];
}

@end
