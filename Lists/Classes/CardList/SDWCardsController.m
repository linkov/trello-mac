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
    [self.collectionView registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];
    NSSize minSize = NSMakeSize(200,30);
    [self.collectionView setMaxItemSize:minSize];

    [self.trashImageView registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];
    [self.trashImageView setHidden:YES];
    self.trashImageView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidRemoveCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        SDWCard *card = [self.cardsArrayController.content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cardID ==%@",note.userInfo[@"cardID"]]].lastObject;

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:self.cardsArrayController.selectionIndex];
        self.cardsArrayController.content = arr;
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"com.sdwr.trello-mac.shouldCreateCardNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self addCard:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldFilterNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self loadCardsForListID:self.currentListID];

    }];


}

- (void)clearCards {

    self.cardsArrayController.content = @[];
    self.listNameLabel.stringValue = @"";
}

- (void)setupCardsForList:(SDWBoard *)list parentList:(SDWBoard *)parentList {


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

    //self.cards = objects;
}


#pragma mark - NSCollectionViewDelegate



- (void)collectionView:(NSCollectionView *)collectionView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint dragOperation:(NSDragOperation)operation {

    [self.trashImageView setHidden:YES];
    [self.addCardButton setHidden:NO];


}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {

    NSLog(@"acceptDrop");

//    NSPasteboard *pBoard = [draggingInfo draggingPasteboard];
//    NSData *indexData = [pBoard dataForType:@"MY_DRAG_TYPE"];
//    NSString *cardID = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
//
//    SDWCard *card = [self.cardsArrayController.content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cardID ==%@",cardID]].lastObject;
//
//    [self.cardsArrayController  removeObject:card];
//    
    return YES;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event {

    [self.trashImageView setHidden:NO];
    [self.addCardButton setHidden:YES];
    NSLog(@"Can drop");
    return YES;
}

-(NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    return NSDragOperationMove;
}

-(BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard {

    SDWCard *card = [self.cardsArrayController.content objectAtIndex:indexes.lastIndex];
    NSDictionary *cardDict = @{@"cardID":card.cardID,@"boardID":card.boardID};

    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:cardDict];
    //    [pasteboard setDraggedTypes:@[@"MY_DRAG_TYPE"]];
    [pasteboard setData:indexData forType:@"MY_DRAG_TYPE"];
    // Here we temporarily store the index of the Cell,
    // being dragged to pasteboard.
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
    [arr insertObject:newCard atIndex:0];

    self.cardsArrayController.content = arr;

    SDWCardsCollectionViewItem *newRow = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:0];
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

- (void)updateCard:(SDWCard *)card {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"name":card.name} success:^(NSURLSessionDataTask *task, id responseObject) {

        SDWCardsCollectionViewItem *selectedCard = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
        selectedCard.selected = NO;
        [selectedCard.view setNeedsDisplay:YES];

        NSLog(@"success save");

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"err save - %@",error.localizedDescription);
    }];

}

- (void)createCard:(SDWCard *)card {

    NSDictionary *params = @{
                             @"name":card.name,
                             @"due":@"null",
                             @"idList":self.currentListID,
                             @"urlSource":@"null"
                             };

    NSLog(@"params -= %@",params);

    [[AFTrelloAPIClient sharedClient] POST:@"cards?"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject)
    {

        SDWCard *updatedCard = [[SDWCard alloc]initWithAttributes:responseObject];

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:0];
        [arr insertObject:updatedCard atIndex:0];
        self.cardsArrayController.content = arr;

        NSLog(@"success create");
        //        SDWCardsCollectionViewItem *selected = (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];
        //        selected.selected = NO;

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"err save - %@",error.localizedDescription);
    }];
}

- (void)cardViewShouldDismissCard:(SDWCardsCollectionViewItem *)cardView {
    self.addCardButton.enabled = YES;
    
    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObjectAtIndex:0];
    self.cardsArrayController.content = arr;
}

#pragma mark - SDWMenuItemDelegate

- (void)menuItemShouldValidateDropWithAction:(SDWMenuItemDropAction)action objectID:(NSString *)objectID {

    if (action == SDWMenuItemDropActionDelete) {

        NSString *urlString = [NSString stringWithFormat:@"cards/%@?",objectID];

        [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            //TODO: don't rely on selectionIndex in the future
            NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
            [arr removeObjectAtIndex:self.cardsArrayController.selectionIndex];
            self.cardsArrayController.content = arr;

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"err - %@",error.localizedDescription);
        }];
    }
}

@end
