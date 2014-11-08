//
//  CardsController.m
//  Vector
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

@property (strong) NSArray *cards;
@property (strong) NSArray *storedUsers;
@property (strong) NSString *currentListID;
@property (strong) NSString *parentListName;
@property (strong) NSString *parentListID;
@property (strong) NSString *listName;
@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet SDWMenuItemImageView *trashImageView;
@property (strong) IBOutlet NSButton *addCardButton;

@end

@implementation SDWCardsController


- (void)awakeFromNib {

    [self.addCardButton setHidden:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];


    self.mainBox.fillColor  = [SharedSettings appBackgroundColorDark];
    self.collectionView.backgroundColors = @[[SharedSettings appBackgroundColorDark]];

	self.collectionView.itemPrototype = [self.storyboard instantiateControllerWithIdentifier:@"collectionProto"];
    [self.collectionView registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];
    NSSize minSize = NSMakeSize(200,30);
    [self.collectionView setMaxItemSize:minSize];

    [self.trashImageView registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];
    [self.trashImageView setHidden:YES];
    self.trashImageView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:@"com.sdwr.trello-mac.didRemoveCardNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        SDWCard *card = [self.cardsArrayController.content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cardID ==%@",note.userInfo[@"cardID"]]].lastObject;

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:self.cardsArrayController.selectionIndex];

        self.cardsArrayController.content = arr;
    }];


}

- (void)viewWillAppear {
	[super viewWillAppear];
}

- (void)viewDidAppear {
    [super viewDidAppear];
}

- (void)viewDidLayout {
	[super viewDidLayout];
}

- (void)setupCardsForList:(SDWBoard *)list parentList:(SDWBoard *)parentList {


    self.parentListName = parentList.name;
    self.listName = list.name;
    self.currentListID = list.boardID;
    self.parentListID = parentList.boardID;

    [self reloadCards];
}

- (void)reloadCards {

    SharedSettings.selectedListUsers = nil;
    self.cardsArrayController.content = nil;
    self.cards = nil;
    [self loadMembers:self.parentListID];

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
            NSLog(@"err = %@", err.localizedDescription);
        }
    }];
}

- (void)reloadCollection:(NSArray *)objects {

    [self.addCardButton setHidden:NO];
	self.cardsArrayController.content = objects;
    self.cards = objects;
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
//- (void)collectionView:(NSCollectionView *)collectionView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint dragOperation:(NSDragOperation)operation {
//
//}


-(NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {

    //NSLog(@"Validate Drop");
    return NSDragOperationMove;
}

-(BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard {

    SDWCard *card = [self.cards objectAtIndex:indexes.lastIndex];
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:card.cardID];
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


#pragma mark - SDWCardViewDelegate

- (void)cardViewShouldSaveCard:(SDWCardsCollectionViewItem *)cardView {

    SDWCard *card = [self.cards objectAtIndex:self.collectionView.selectionIndexes.firstIndex];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"name":cardView.textField.stringValue} success:^(NSURLSessionDataTask *task, id responseObject) {

        NSLog(@"success save");

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"err save - %@",error.localizedDescription);
    }];


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
