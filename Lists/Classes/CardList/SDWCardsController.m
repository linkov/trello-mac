//
//  CardsController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//


/*-------View Controllers-------*/
#import "SDWCardViewController.h"
#import "SDWMainSplitController.h"
#import "SDWCardsController.h"

/*-------Frameworks-------*/
#import "Xtrace.h"
#import "SDWMacros.h"

/*-------Views-------*/
#import "JWCTableView.h"
#import "SDWSingleCardTableCellView.h"
#import "SDWCardListView.h"
#import "PulseView.h"
#import "SDWProgressIndicator.h"
#import "SDWLabelDisplayItem.h"
#import "BadgeTextField.h"
#import "LabelCloudView.h"

/*-------Helpers & Managers-------*/
#import "Utils.h"
#import "SDWTrelloStore.h"
#import "NSControl+DragInteraction.h"
#import "SDWAppSettings.h"
#import "NSColor+Util.h"


/*-------Models-------*/
#import "SDWListDisplayItem.h"
#import "SDWCardDisplayItem.h"
#import "SDWUserDisplayItem.h"
#import "SDWBoardDisplayItem.h"


@interface SDWCardsController () <NSCollectionViewDelegate,SDWLabelCloudViewDelegate, NSControlInteractionDelegate,SDWSingleCardViewDelegate, JWCTableViewDataSource, JWCTableViewDelegate>
@property (strong) IBOutlet NSArrayController *cardsArrayController;
@property (weak) IBOutlet NSImageView *noConnectionImage;

@property (strong) NSArray *storedUsers;
@property (weak) IBOutlet NSLayoutConstraint *listNameTopConstraint;

@property (strong) SDWListDisplayItem *currentList;
@property (strong) SDWBoardDisplayItem *currentBoard;

@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet NSButton *addCardButton;
@property (strong) IBOutlet NSTextField *listNameLabel;

@property NSString *listName;
@property (strong) SDWSingleCardTableCellView *lastSelectedItem;
@property (strong) SDWCardDisplayItem *lastSelectedCard;

@property NSUInteger dropIndex;
@property (strong) IBOutlet SDWProgressIndicator *mainProgressIndicator;
@property (strong) IBOutlet SDWProgressIndicator *cardActionIndicator;
@property (strong) IBOutlet JWCTableView *tableView;

@property (weak) IBOutlet LabelCloudView *labelsView;
@property (weak) IBOutlet NSLayoutConstraint *labelsViewHeightConstaint;

@property (strong)  NSSet *excludedLabels;
@property (strong)  NSSet *includedLabels;
@property (strong) NSPredicate *labelFilerPredicate;

@end

@implementation SDWCardsController


#pragma mark - Lifecycle

- (NSPredicate *)predicateForIncludedLabelsFilter {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SDWCardDisplayItem *item,
                                                                   NSDictionary *bindings) {
        
        if (item.labels.count == 0) {
            if (self.includedLabels.count > 0) {
                      return NO;
                  }
            return YES;
        }
        for (SDWLabelDisplayItem *cardLabel in item.labels) {

            if (!cardLabel) {
                return NO;
            }
            
            for (SDWLabelDisplayItem *includedLabel in [self.includedLabels allObjects]) {
        
                
                if (([includedLabel.name isEqualToString:cardLabel.name] && includedLabel.name.length > 0 && cardLabel.name.length > 0) || ([includedLabel.color isEqualToString:cardLabel.color] && includedLabel.color.length > 0 && cardLabel.color.length > 0)) {
                    return YES;
                }
            }
        }
        
        if (self.includedLabels.count > 0) {
            return NO;
        }
        return YES;
    }];
    
    return predicate;
}

- (NSPredicate *)predicateForExcludedLabelsFilter {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SDWCardDisplayItem *item,
                                                                   NSDictionary *bindings) {
        
        if (item.labels.count == 0) {
            return YES;
        }
        for (SDWLabelDisplayItem *cardLabel in item.labels) {

            if (!cardLabel) {
                return YES;
            }
            
            for (SDWLabelDisplayItem *excludedLabel in [self.excludedLabels allObjects]) {
        
                
                if (([excludedLabel.name isEqualToString:cardLabel.name] && excludedLabel.name.length > 0 && cardLabel.name.length > 0) || ([excludedLabel.color isEqualToString:cardLabel.color] && excludedLabel.color.length > 0 && cardLabel.color.length > 0)) {
                    return NO;
                }
            }
        }
        return YES;
    }];
    
    return predicate;
}

- (void)awakeFromNib {


    self.labelFilerPredicate = [self predicateForIncludedLabelsFilter];
}

- (void)viewDidLoad {
    [super viewDidLoad];

  
   
    self.mainBox.fillColor  = [SharedSettings appBackgroundColorDark];
    self.tableView.backgroundColor = [NSColor clearColor];

    self.labelsViewHeightConstaint.constant = 2;
    [self.view setNeedsLayout:YES];
    
    [self.tableView registerForDraggedTypes:@[@"REORDER_DRAG_TYPE"]];
    [self.tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    [self.tableView setDraggingDestinationFeedbackStyle:NSTableViewDraggingDestinationFeedbackStyleGap];

    self.labelsView.delegate = self;
    
    [self.addCardButton registerForDraggedTypes:@[@"TRASH_DRAG_TYPE"]];
    self.addCardButton.interactionDelegate = self;
    [self subscribeToEvents];

    if (![self isShowingListCards]) {

        [self.addCardButton setHidden:YES];
        self.onboardingImage.hidden = NO;
    }


}


- (void)labelCloudDidUpdateDisabledLabels:(NSSet<SDWLabelDisplayItem *> *)labels includedLabels:(nonnull NSSet<SDWLabelDisplayItem *> *)includedLabels {
    
    self.includedLabels = includedLabels;
    self.excludedLabels = labels;
    
    
    self.labelFilerPredicate = [self predicateForIncludedLabelsFilter];
    if (self.currentBoard) {
        [self loadCardsForBoard:self.currentBoard];
    } else {
        [self loadCardsForList:self.currentList];
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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsWillExitFullscreenNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self.ListWidth setPriority:NSLayoutPriorityDefaultHigh];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsWillEnterFullscreenNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self.ListWidth setPriority:NSLayoutPriorityDefaultLow];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidRemoveCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self loadCardsForList:self.currentList];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldCreateCardNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self addCard:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldFilterNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self loadCardsForList:self.currentList];

    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidReceiveNetworkOnNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        self.noConnectionImage.hidden = YES;
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidReceiveNetworkOffNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        self.noConnectionImage.hidden = NO;
        
    }];



    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidChangeDotOptionNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self loadCardsForList:self.currentList];

    }];

}


- (BOOL)isShowingListCards {

    if (self.currentList) {
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
    SDWCardDisplayItem *movedCard = [mutableArray objectAtIndex:fromIndex];
    SDWCardDisplayItem *newSiblingCard = [mutableArray objectAtIndex:toIndex];

    NSUInteger movedCardPos = movedCard.position;
    NSUInteger newSiblingCardPos = newSiblingCard.position;

    movedCard.position = newSiblingCardPos;
    newSiblingCard.position = movedCardPos;

    [mutableArray removeObject:movedCard];
    [mutableArray insertObject:movedCard atIndex:toIndex];

    // 2. set positions to all cards equal to cards' indexes in array
    for (int i = 0; i<mutableArray.count; i++) {
        SDWCardDisplayItem *card = mutableArray[i];
        card.position = i;
    }

    return mutableArray;
    
}

#pragma mark - Card actions

- (void)updateCardDetails:(SDWCardDisplayItem *)card localOnly:(BOOL)local {

    if (local) {

        NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
        [arr removeObjectAtIndex:[self.cardsArrayController.content indexOfObject:card] ];
        [arr insertObject:card atIndex:[self.cardsArrayController.content indexOfObject:card]];
        [self reloadCollection:arr];
        return;

    }

    [self showCardSavingIndicator:YES];

    [[SDWTrelloStore store] updateCard:card withCompletion:^(SDWCardDisplayItem *updatedCard, NSError *error) {

        [self showCardSavingIndicator:NO];

        if (!error) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SDWListsShouldReloadBoardsDatasourceNotification" object:nil userInfo:nil];

            [[self cardDetailsVC] setupCard:updatedCard];

            //TODO: refactor this
            if (![self isValidIndex:[self.cardsArrayController.content indexOfObject:card]]) {

                [self reloadCards];
                return;
            }

            NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
            [arr removeObjectAtIndex:[self.cardsArrayController.content indexOfObject:card] ];
            [arr insertObject:updatedCard atIndex:[self.cardsArrayController.content indexOfObject:card]];
            [self reloadCollection:arr];

        }
    }];

}



- (void)updateCardPosition:(SDWCardDisplayItem *)card {


    [[SDWTrelloStore store] moveCard:card
                          toPosition:@(card.position)];
     [self showCardSavingIndicator:NO];

}


- (void)dismissNewEditedCard {
    
    self.addCardButton.enabled = YES;
    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
    self.cardsArrayController.content = arr;
    [self.tableView reloadData];
}

- (void)clearCards {

    self.cardsArrayController.content = @[];
    self.listNameLabel.hidden = YES;
    [self.tableView reloadData];
}

- (void)setupCardsForList:(SDWListDisplayItem *)list {

    [self.onboardingImage removeFromSuperview];
    self.listNameLabel.hidden = NO;
    self.listNameTopConstraint.constant = 16;
    self.listNameLabel.font = [NSFont fontWithName:@"IBMPlexSans-Text" size:28];
    
    self.currentBoard = nil;
    self.currentList = list;
    self.listName = list.name;
    
    self.labelsViewHeightConstaint.constant = 2;
    [self.view setNeedsLayout:YES];
    
    [self loadAndSaveAllLabelsForBoardID:self.currentList.board.trelloID completion:^{
        
         [self reloadCards];
        
    }];

    
    
}

- (void)setupCardsForTimeline {

//    [self.onboardingImage removeFromSuperview];
//    self.listNameLabel.hidden = NO;
//    self.listNameTopConstraint.constant = 22;
//    self.listNameLabel.font = [NSFont fontWithName:@"IBMPlexSans-Text" size:18];
//    self.currentList = nil;
//
//
//    self.currentBoard = board;
//    self.listName =  [NSString stringWithFormat:@"%@ [overview]",self.currentBoard.name];
//
//    [self loadAndSaveAllLabelsForBoardID:board.trelloID completion:^{
//
//         [self reloadCardsForCurrentBoard];
//
//    }];
    

}


- (void)setupCardsForBoard:(SDWBoardDisplayItem *)board {

    [self.onboardingImage removeFromSuperview];
    self.listNameLabel.hidden = NO;
    self.listNameTopConstraint.constant = 22;
    self.listNameLabel.font = [NSFont fontWithName:@"IBMPlexSans-Text" size:18];
    self.currentList = nil;

    
    self.currentBoard = board;
    self.listName =  [NSString stringWithFormat:@"%@ [overview]",self.currentBoard.name];
    
    [self loadAndSaveAllLabelsForBoardID:board.trelloID completion:^{
        
         [self reloadCardsForCurrentBoard];
        
    }];
    

}


- (IBAction)reloadCardsAfterFail:(id)sender {


    [self reloadCards];
}

- (void)reloadCardsForCurrentBoard {

    [[self cardDetailsVC] setupCard:nil];


    SharedSettings.selectedListUsers = nil;


    /*
     clean previous cards before loading new ones
     so that loading indicator is not on top of cards
     */
    self.cardsArrayController.content = nil;
    [self.tableView reloadData];

    [self loadCardsForBoard:self.currentBoard];

    [self loadMembers:self.currentList.board.trelloID];
 
    

}

- (void)reloadCards {

    [[self cardDetailsVC] setupCard:nil];

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
    
    [self loadCardsForList:self.currentList];

    [self loadMembers:self.currentList.board.trelloID];

}

- (void)reloadCardsAndFilter:(NSArray *)content {
    
    NSMutableArray *filteredArray = [NSMutableArray new];
    
    for (SDWCardDisplayItem *cardItem in self.cardsArrayController.content) {
        
        if ([cardItem.members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"trelloID == %@",SharedSettings.userID]].count > 0) {
            [filteredArray addObject:cardItem];
        }
    }

    self.cardsArrayController.content = filteredArray;
}

- (void)loadMembers:(NSString *)boardID {
    
    //
    
     [self loadCardsForList:self.currentList];
    
//    [self.mainProgressIndicator startAnimation];
//
//    [[SDWTrelloStore store] fetchUsersForBoardID:boardID currentData:^(NSArray *objects, NSError *error) {
//
//        if (objects.count > 0) {
//             [self.mainProgressIndicator stopAnimation];
//        }
//
//        if (!error) {
//            SharedSettings.selectedListUsers = objects;
//            [self loadCardsForList:self.currentList];
//        } else {
//            [self.mainProgressIndicator stopAnimation];
//            //            CLS_LOG(@"err = %@", err.localizedDescription);
//        }
//
//    } fetchedData:^(NSArray *objects, NSError *error) {
//
//         [self.mainProgressIndicator stopAnimation];
//
//        if (!error) {
//            SharedSettings.selectedListUsers = objects;
//            [self loadCardsForList:self.currentList];
//        } else {
//            [self.mainProgressIndicator stopAnimation];
//        }
//    }];
    

}


- (void)loadAndSaveAllLabelsForBoardID:(NSString *)boardID completion:(SDWEmptyBlock)completion {

    self.excludedLabels = [NSSet new];
    self.includedLabels = [NSSet new];
    
    self.labelsView.bottomBorder.frame = CGRectMake(15.0f, 1.,self.labelsView.frame.size.width - 30, 1.0f);

    [[SDWTrelloStore store] fetchLabelsForBoardID:boardID currentData:^(NSArray *objects, NSError *error) {
        
      self.labelsViewHeightConstaint.constant = 80;

      [self.labelsView resetDisabledLabels];
        self.labelsView.labels = objects;
      [self.labelsView.collectionView reloadData];
      
       SDWPerformBlock(completion);
        
     
        
    } fetchedData:^(NSArray *objects, NSError *error) {
        
        self.labelsViewHeightConstaint.constant = 80;
        [self.labelsView resetDisabledLabels];

        self.labelsView.labels = objects;
        [self.labelsView.collectionView reloadData];
       
         SDWPerformBlock(completion);
        
       
    }];
    

}


- (void)loadCardsForBoard:(SDWBoardDisplayItem *)board {
    
    [self.mainProgressIndicator startAnimation];


    [[SDWTrelloStore store] fetchAllCardsForBoard:board CurrentData:^(NSArray *objects, NSError *error) {
        
        if (objects.count > 0) {
            [self.mainProgressIndicator stopAnimation];
        }
        
        
        NSArray *objectsExcludingLabels = [objects filteredArrayUsingPredicate:self.labelFilerPredicate];
        if (!error) {
            [self reloadCollection:objectsExcludingLabels];
        } else {
            NSLog(@"%@", error);
        }
        
    } FetchedData:^(id objects, NSError *error) {
        
        [self.mainProgressIndicator stopAnimation];

        NSArray *objectsExcludingLabels = [objects filteredArrayUsingPredicate:self.labelFilerPredicate];
        if (self.currentBoard.model.uniqueIdentifier == board.model.uniqueIdentifier) {
            if (!error) {
                [self reloadCollection:objectsExcludingLabels];
            } else {
                NSLog(@"%@", error);
            }
        }
        

    } crownFiltered:SharedSettings.shouldFilter];
    

}



- (void)loadCardsForList:(SDWListDisplayItem *)list {
    
    [self.mainProgressIndicator startAnimation];

//    self.labelsView.bottomBorder.frame = CGRectZero;
    
    [[SDWTrelloStore store] fetchAllCardsForList:list CurrentData:^(NSArray *objects, NSError *error) {
        
        if (objects.count > 0) {
            [self.mainProgressIndicator stopAnimation];
        }
//
//
//        NSArray *objectsExcludingLabels = [objects filteredArrayUsingPredicate:self.labelFilerPredicate];
//        
//        if (!error) {
//            [self reloadCollection:objectsExcludingLabels];
//        } else {
//            NSLog(@"%@", error);
//        }
        
    } FetchedData:^(id objects, NSError *error) {
        
        [self.mainProgressIndicator stopAnimation];
        
        NSArray *objectsExcludingLabels = [objects filteredArrayUsingPredicate:self.labelFilerPredicate];
        
        if (self.currentList.model.uniqueIdentifier == list.model.uniqueIdentifier) {
            if (!error) {
                [self reloadCollection:objectsExcludingLabels];
            } else {
                NSLog(@"%@", error);
            }
        }
        

    } crownFiltered:SharedSettings.shouldFilter];
    

}

- (void)reloadCollection:(NSArray *)objects {

    [self.addCardButton setHidden:self.currentBoard != nil];


    NSSortDescriptor *sortBy;


    if (SharedSettings.shouldFilterDueAccending) {

        sortBy = [[NSSortDescriptor alloc]initWithKey:@"dueDate" ascending:YES selector:@selector(compare:)];

    } else if (SharedSettings.shouldFilterDueDecending) {

        sortBy = [[NSSortDescriptor alloc]initWithKey:@"dueDate" ascending:NO selector:@selector(compare:)];

    } else {

        sortBy = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES selector:@selector(compare:)];
    }


//    self.cardsArrayController.content = @[];

    self.cardsArrayController.content = [objects sortedArrayUsingDescriptors:@[sortBy]];

    // tableView implementation
    [self.tableView reloadData];
    [self.tableView deselectAll:nil];

}

- (void)updateCardsPositions {

    for (SDWCardDisplayItem *card in self.cardsArrayController.content) {

        [self updateCardPosition:card];
//        CLS_LOG(@"%@ - %lu",card.name,(unsigned long)card.position);
    }
}



- (IBAction)addCard:(id)sender {

    if (![self isShowingListCards] || [SharedSettings isOffline]) {
        return;
    }

    SDWCardDisplayItem *newCard = [SDWCardDisplayItem new];
    newCard.name = @"";
    self.lastSelectedCard = newCard;



    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr addObject:newCard];

    self.cardsArrayController.content = arr;

    NSUInteger lastIndex = arr.count-1;
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:lastIndex] withAnimation:NSTableViewAnimationEffectFade];

    SDWSingleCardTableCellView *newRow = (SDWSingleCardTableCellView *)[self.tableView viewAtColumn:0 row:lastIndex makeIfNecessary:NO];
    newRow.delegate = self;
    newRow.boardID = self.currentList.board.trelloID;
    
    
    if (self.currentBoard) {
        newRow.boardID = self.currentBoard.trelloID;
    }
    
    newRow.mainBox.textField.delegate = newRow;
    newRow.mainBox.selected = YES;
    newRow.mainBox.textField.editable = YES;
    [newRow.mainBox.textField becomeFirstResponder];

    self.addCardButton.enabled = NO;

}


#pragma mark - SDWSingleCardViewDelegate

- (void)cardViewDidSelectCard:(SDWSingleCardTableCellView *)cardView {

    SDWCardDisplayItem *selectedCard = [self.cardsArrayController.arrangedObjects objectAtIndex:[self.tableView rowForView:cardView]];
    self.lastSelectedCard = selectedCard;
}


- (void)cardViewShouldAddLabelOfColor:(NSString *)color {
    
    
    SDWLabelDisplayItem *label;
    
    if (self.currentBoard) {
        label = [self.currentBoard.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@ || name == %@",color, color]].firstObject;

    } else {
        label = [self.currentList.board.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@ || name == %@",color, color]].firstObject;

    }
    
    
    [self showCardSavingIndicator:YES];
    
    if (label) {
        [[SDWTrelloStore store] addLabelForCard:self.lastSelectedCard labelID:label.trelloID completion:^(id object, NSError *error) {
            [self showCardSavingIndicator:NO];
            [self reloadCards];
        }];
    }
   
}

- (void)cardViewShouldRemoveLabelOfColor:(NSString *)color {
    
    SDWLabelDisplayItem *label;
    
    if (self.currentBoard) {
            label = [self.currentBoard.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@ || name == %@",color, color]].firstObject;

    } else {
        label = [self.currentList.board.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@ || name == %@",color, color]].firstObject;

    }
    
    
    [self showCardSavingIndicator:YES];
    
    if (label) {
        [[SDWTrelloStore store] removeLabelForCardID:self.lastSelectedCard.trelloID labelID:label.trelloID completion:^(id object, NSError *error) {
            [self showCardSavingIndicator:NO];
            [self reloadCards];
        }];
    }

}


- (void)cardViewShouldRemoveUser:(NSString *)trelloID {
    
    
    if (trelloID) {
        [self showCardSavingIndicator:YES];
        [[SDWTrelloStore store] removeUserFromCard:self.lastSelectedCard userID:trelloID completion:^(id object, NSError *error) {
           
            [self showCardSavingIndicator:NO];
            [self reloadCards];
        }];
    }
}

- (void)cardViewShouldAddUser:(NSString *)trelloID {
    
    if (trelloID) {
        [self showCardSavingIndicator:YES];
        [[SDWTrelloStore store] addUserToCard:self.lastSelectedCard userID:trelloID completion:^(id object, NSError *error) {
           
            [self showCardSavingIndicator:NO];
            [self reloadCards];
        }];
    }
}


- (void)cardViewShouldDeselectCard:(SDWSingleCardTableCellView *)cardView {

    if (![self isValidIndex:self.cardsArrayController.selectionIndex]) {
        [[self cardDetailsVC] setupCard:nil];
    }
}

- (void)cardViewShouldSaveCard:(SDWSingleCardTableCellView *)cardView {

    self.addCardButton.enabled = YES;
    self.lastSelectedItem = cardView;
    self.lastSelectedItem.mainBox.selected = NO;





    if (self.lastSelectedCard.model.uniqueIdentifier) {
        SDWCardDisplayItem *card = self.lastSelectedCard;
        card.name = cardView.mainBox.textField.stringValue;
        [[self cardDetailsVC] setupCard:self.lastSelectedCard];
        
        
        [self showCardSavingIndicator:YES];
        
        [[SDWTrelloStore store] updateCard:self.lastSelectedCard withCompletion:^(id object, NSError *error) {
            
            [self showCardSavingIndicator:NO];
            
            if (!error) {
                
                self.lastSelectedItem.mainBox.selected = NO;
                self.lastSelectedItem.mainBox.textField.toolTip = self.lastSelectedItem.textField.stringValue;
                [self.lastSelectedItem setNeedsDisplay:YES];
                
            }
        }];


    }
    else {


        SDWCardDisplayItem *lastItem = [(NSArray *)self.cardsArrayController.content lastObject];
        int64_t lastItemPosition = lastItem.position;
        
       [[SDWTrelloStore store] createCardWithName:cardView.mainBox.textField.stringValue
                                                                                list:self.currentList
                                                                            position:lastItemPosition+1 updatedCard:^(id updatedCard) {
                                                                                
//                                                                                NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
//                                                                                [arr removeObjectAtIndex:[self bottomObjectIndex:arr]];
//                                                                                [arr insertObject:updatedCard atIndex:[self bottomObjectIndex:arr]];
//                                                                                [self reloadCollection:arr];
                                                                                 [self loadCardsForList:self.currentList];
//                                                                                [[self cardDetailsVC] setupCard:updatedCard];
                                                                            }];
        

//        [self loadCardsForList:self.currentList];
             
        
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

- (void)archiveCardWithID:(NSString *)UID {

    
    [[self cardDetailsVC] setupCard:nil];

    SDWCardDisplayItem *cardToDelete = [self.cardsArrayController.content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.model.uniqueIdentifier == %@",UID]].firstObject;

    [[SDWTrelloStore store] archiveCard:cardToDelete];
    NSMutableArray *arr =[NSMutableArray arrayWithArray:self.cardsArrayController.content];
    [arr removeObject:cardToDelete];
    self.cardsArrayController.content = arr;
    [self.tableView reloadData];
}






// TableView implementation

#pragma mark - JWCTableViewDataSource, JWCTableViewDelegate

-(BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section {

    return NO;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentBoard) {
        
        return YES;
    }
    
  

    SDWSingleCardTableCellView *selectedCell = [tableView viewAtColumn:0 row:indexPath.row makeIfNecessary:NO];
   
    [selectedCell.mainBox setSelected:YES];
    selectedCell.delegate = self;
    selectedCell.mainBox.textField.delegate = selectedCell;

    //TODO: refactor
    for (int i = 0; i<[self.cardsArrayController.content count]; i++) {

        SDWSingleCardTableCellView *cell = [self.tableView viewAtColumn:0 row:i makeIfNecessary:NO];

        if(cell != selectedCell) {
            [cell.mainBox setSelected:NO];
        }

    }

    SDWCardDisplayItem *selectedCard = [self.cardsArrayController.arrangedObjects objectAtIndex:indexPath.row];
    self.lastSelectedCard = selectedCard;
    [[self cardDetailsVC] setupCard:selectedCard];


    return YES;
}

-(NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentBoard) {
        
        SDWListDisplayItem *list  = self.currentBoard.lists[section];
         NSArray *objectsExcludingLabels = [self.cardsArrayController.arrangedObjects filteredArrayUsingPredicate:self.labelFilerPredicate];
        
        return [objectsExcludingLabels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"list.trelloID == %@",list.trelloID]].count;
    }
    return [[self.cardsArrayController.arrangedObjects filteredArrayUsingPredicate:self.labelFilerPredicate] count];
}


-(NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {

    if (self.currentBoard) {
        return self.currentBoard.lists.count;
    }
    
    
    return 1;
}



-(BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {
    SDWListDisplayItem *list  = self.currentBoard.lists[section];
    if (self.currentBoard && list.cards.count > 0) {
        return YES;
    }
    return NO;
}

-(CGFloat)tableView:(NSTableView *)tableView heightForHeaderViewForSection:(NSInteger)section {
    if (self.currentBoard) {
        return 32;
    }
    return 0;
}


-(NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.currentBoard) {
        SDWListDisplayItem *list  = self.currentBoard.lists[section];
        NSTextView *headerLabel = [[NSTextView alloc] initWithFrame:NSMakeRect(0.0, 0.0, self.tableView.bounds.size.width, 20.0)];
        [headerLabel setBackgroundColor: [NSColor clearColor]];
        [headerLabel setString: list.name];
        [headerLabel setEditable:NO];
        [headerLabel setFont:[NSFont fontWithName:@"IBMPlexSans-Medium" size:16]];
        [headerLabel setTextColor:  [NSColor blackColor]];

        NSSize txtPadding;
        txtPadding.width = 4.0;
        txtPadding.height = 8.0;
        [headerLabel setTextContainerInset:txtPadding];
//
        return headerLabel;

    }
    return nil;
}

-(CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SDWCardDisplayItem *card = self.cardsArrayController.arrangedObjects[indexPath.row];
    
    
    if (self.currentBoard) {
        
        SDWListDisplayItem *list = self.currentBoard.lists[indexPath.section];
        card = [list.cards filteredArrayUsingPredicate:self.labelFilerPredicate][indexPath.row];
        
        if (!card) {
            return 0;
        }
    }
    

    CGRect rec = [card.name boundingRectWithSize:CGSizeMake( (card.commentsCount.intValue > 0 ? 323 : 375), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [NSFont fontWithName:@"IBMPlexSans-Text" size:13]}];
    CGFloat height = ceilf(rec.size.height);

    if ([card labels].count) {
        
        height += 20;
    }
    
    if ([card members].count || card.dueDate) {
        
        height += 22;
       
    }

    
    if (height > 14) {
        
        return height+7+7;
    }
    

    return 27;



}

-(NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {

    if ([[self.cardsArrayController.arrangedObjects filteredArrayUsingPredicate:self.labelFilerPredicate] count] == 0) {
        return nil;
    }

    
    SDWCardDisplayItem *card = self.cardsArrayController.arrangedObjects[indexPath.row];
    
    if (self.currentBoard) {
        
        SDWListDisplayItem *list = self.currentBoard.lists[indexPath.section];
        
        NSArray *objectsExcludingLabels = [list.cards filteredArrayUsingPredicate:self.labelFilerPredicate];
        card = objectsExcludingLabels[indexPath.row];
    }
    
    

    SDWSingleCardTableCellView *view = [self.tableView makeViewWithIdentifier:@"cellView" owner:self];
    view.menuClickEnabled = (self.currentBoard == nil);
    view.boardID = self.currentList.board.trelloID;
    view.cardDisplayItem = card;
    
    if (self.currentBoard) {
        view.boardID = self.currentBoard.trelloID;
    }
    
    view.mainBox.textField.stringValue = card.name;
    view.mainBox.textField.font = [NSFont fontWithName:@"IBMPlexSans-Text" size:13];
    view.widthConstraint.constant = [self widthForMembersCount:card.members.count];
    view.textField.backgroundColor = [NSColor clearColor];
    view.delegate = self;
    view.mainBox.selected = NO;
    
    if (card.commentsCount.intValue > 0) {
        view.mainTextfieldTrailingConstraint.constant = 65;
        view.commentsIconWidth.constant = 16;
        view.commentsCountTextfield.font = [NSFont fontWithName:@"IBMPlexSans-SemiBold" size:10];
        view.commentsCountTextfield.stringValue = [card.commentsCount stringValue];
        
        view.commentsCountTextfield.textColor = [NSColor colorWithHexColorString:@"BBBBBB"];
        view.commentsIconImageView.contentTintColor = [NSColor colorWithHexColorString:@"BBBBBB"];
    } else {
        view.mainTextfieldTrailingConstraint.constant = 11;
        view.commentsCountTextfield.stringValue = @"";
        view.commentsIconWidth.constant = 0;
    }


    if (SharedSettings.shouldShowCardLabels == YES) {
        view.mainBox.labels = [card labels];
    } else {
        view.mainBox.labels = @[];
    }


    /* mark due */
    NSDate *due = card.dueDate;
    if (due != nil && [due timeIntervalSinceNow] < 0.0) {
        [view.mainBox setShouldDrawSideLine:YES];

    } else if (due != nil && ([due timeIntervalSinceNow] > 0.0 && [due timeIntervalSinceNow] < 100000 ) ) {
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
            } else {
                [view.mainBox setHasDot:NO];
            }
        }

            break;

        case SDWDotOptionHasOpenTodos: {

            BOOL hasOpenTodos = [card hasOpenChecklistItems];

            if (hasOpenTodos != 0 && hasOpenTodos != NO) {
                [view.mainBox setHasDot:YES];
            } else {
                 [view.mainBox setHasDot:NO];
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
    
    [view.customLabelsView.views makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if(card.dueDate){
        NSTextField *text = [[NSTextField alloc]init];
        
        [text setWantsLayer:YES];
        [text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [text setFont:[NSFont systemFontOfSize:9]];
        [text setTextColor:[NSColor colorWithHexColorString:@"3E6378"]];
        [text setStringValue:[Utils dateToString:card.dueDate]];
        [text setEditable:NO];
        text.alignment = NSTextAlignmentCenter;
        
        text.layer.cornerRadius = 1.5;
        text.layer.borderWidth = 1;
        text.layer.borderColor = [NSColor colorWithHexColorString:@"3E6378"].CGColor;
        [view.stackView addView:text inGravity:NSStackViewGravityTrailing];
    }
    
    /* show labels */
    if ([card labels].count) {

        for (SDWLabelDisplayItem *label in [card labels]) {
            
              BadgeTextField *text = [[BadgeTextField alloc]init];
                  [text setWantsLayer:YES];
                  [text setTranslatesAutoresizingMaskIntoConstraints:NO];
                  [text setFont: [NSFont fontWithName:@"IBMPlexSans-Medium" size:12]];

                  [text setBezeled:NO];
            
            if (label.name.length == 0) {
                [text setTextColor:[SharedSettings colorForTrelloColor:label.color]];
            } else {
                [text setTextColor:[NSColor whiteColor]];
            }
            

                  
                  [text setStringValue:[NSString stringWithFormat:@" %@ ",label.name.length > 0 ? label.name: label.color]];
                  [text setEditable:NO];
                  text.backgroundColor = [SharedSettings colorForTrelloColor:label.color];
                  text.alignment = NSTextAlignmentLeft;
                  text.layer.backgroundColor = [SharedSettings colorForTrelloColor:label.color].CGColor;
                  text.layer.cornerRadius = 2;

            [view.customLabelsView addArrangedSubview:text];
            
//            NSLog(@"name = %@, color = %@", label.name, label.color);
        }
        
        NSView *spacer = [NSView new];
        [spacer setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
        
        [view.customLabelsView addArrangedSubview:spacer];
        view.customLabelsViewHeightConstaint.constant = 20;
    } else {
        view.customLabelsViewHeightConstaint.constant = 1;
    }


    for (SDWUserDisplayItem *member in card.members) {

        NSTextField *text = [[NSTextField alloc]init];

        [text setWantsLayer:YES];
        [text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [text setFont:[NSFont systemFontOfSize:9]];
        [text setTextColor:[NSColor colorWithHexColorString:@"171A23"]];
        [text setStringValue:member.initials];
        [text setEditable:NO];
        text.alignment = NSTextAlignmentCenter;

        text.layer.cornerRadius = 1.5;
        text.layer.borderWidth = 1;
        text.layer.borderColor = [NSColor colorWithHexColorString:@"171A23"].CGColor;
        [view.stackView addView:text inGravity:NSStackViewGravityTrailing];
        
    }
    
    
    
    if (card.members.count || card.dueDate) {
        NSView *spacer = [NSView new];
        [spacer setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
        [view.stackView addArrangedSubview:spacer];
    }



    return view;

}

- (void)_dbgArrayElementsWithTitle:(NSString *)title {


}


#pragma mark - JWCTableViewDelegate ( Drag / Drop )

- (BOOL)_jwcTableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {

    if (self.currentBoard) {
        return NO;
    }

    
    SDWCardDisplayItem *card = [self.cardsArrayController.content objectAtIndex:rowIndexes.firstIndex];
    NSDictionary *cardDict = @{
                               @"cardID":card.model.uniqueIdentifier,
                               @"itemID":card.model.uniqueIdentifier,
                               @"boardID":card.model.list.board.uniqueIdentifier,
                               @"itemIndex":[NSNumber numberWithInteger:rowIndexes.firstIndex]
                               };

    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:cardDict];
    [pboard setData:indexData forType:@"TRASH_DRAG_TYPE"];
    [pboard setData:indexData forType:@"REORDER_DRAG_TYPE"];

    return YES;
}
- (NSDragOperation)_jwcTableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {

    if ([self.cardsArrayController.arrangedObjects count] == 1 || self.currentBoard) {
        return NSDragOperationNone;
    }

    NSDragOperation dragOp = NSDragOperationNone;

    if (op == NSTableViewDropAbove ) {

        dragOp = NSDragOperationMove;


    } else if (op == NSTableViewDropOn ) {

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

        if (itemMovedFromIndex == self.dropIndex) {
            return NO;
        }

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



- (CGFloat)widthForMembersCount:(NSUInteger)count {

    CGFloat width = 297;
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
