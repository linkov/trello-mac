//
//  SDWBoardsController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//



#import "SDWBoardsController.h"


/*-------View Controllers-------*/

#import "SDWCardsController.h"
#import "SDWMainSplitController.h"
#import "SDWCardViewController.h"
#import "SDWLoginVC.h"

/*-------Frameworks-------*/
#import <QuartzCore/QuartzCore.h>

/*-------Views-------*/
#import "ITSwitch.h"
#import "WSCBoardsOutlineView.h"
#import "SDWBoardsCellView.h"
#import "SDWProgressIndicator.h"
#import "SDWBoardsListRow.h"

/*-------Helpers & Managers-------*/
#import "SDWTrelloStore.h"
#import "SDWAppSettings.h"
#import "NSColor+Util.h"
#import "AFTrelloAPIClient.h"

/*-------Models-------*/
#import "SDWBoardDisplayItem.h"
#import "SDWListDisplayItem.h"

@interface SDWBoardsController () <NSOutlineViewDelegate,NSOutlineViewDataSource,SDWBoardsListRowDelegate,SDWBoardsListOutlineViewDelegate,NSTextFieldDelegate>
@property (strong) NSArray<SDWBoardDisplayItem *> *boards;


@property (strong) NSArray<SDWBoardDisplayItem *> *unfilteredBoards;
@property (strong) IBOutlet WSCBoardsOutlineView *outlineView;

@property (strong) NSTreeNode *lastSelectedItem;
@property (strong) SDWBoardsListRow *prevSelectedRow;
@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet NSImageView *crownImageView;
@property (strong) SDWBoardDisplayItem *boardWithDrop;
@property (strong) SDWBoardDisplayItem *boardWithDropParent;
@property (strong) IBOutlet NSButton *logoutButton;
@property (strong) IBOutlet ITSwitch *crownSwitch;
@property (strong) IBOutlet NSScrollView *mainScroll;
@property (strong) IBOutlet NSButton *reloadButton;

@property (strong) SDWBoardDisplayItem *parentBoardForEditedList;
@property (strong) NSString *editedListName;
@property NSUInteger editedListPositon;
@property NSUInteger editedRow;
@property (strong) IBOutlet SDWProgressIndicator *loadingProgress;

@property BOOL isAccessingExpandViaDataReload;
@property (strong) IBOutlet NSButton *dueSortButton;

@end

@implementation SDWBoardsController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self loadBoards];
    self.mainBox.fillColor = [SharedSettings appBackgroundColorDark];
    self.outlineView.backgroundColor = [SharedSettings appBackgroundColorDark];
    [self.outlineView registerForDraggedTypes:@[@"REORDER_DRAG_TYPE"]];
    self.outlineView.dataSource = self;
    self.reloadButton.hidden = YES;
    self.outlineView.menuDelegate = self;

    self.dueSortButton.image = [NSImage imageNamed:@"dueSortOff"];

}

#pragma mark - Utils
- (IBAction)sortByDue:(NSButton *)sender {

    if (!SharedSettings.shouldFilterDueAccending && !SharedSettings.shouldFilterDueDecending) {

        SharedSettings.shouldFilterDueAccending = YES;
        self.dueSortButton.image = [NSImage imageNamed:@"dueSort"];

    } else if (SharedSettings.shouldFilterDueAccending) {

        SharedSettings.shouldFilterDueDecending = YES;
        SharedSettings.shouldFilterDueAccending = NO;
        self.dueSortButton.image = [NSImage imageNamed:@"dueSortDes"];

    } else if (SharedSettings.shouldFilterDueDecending) {

        SharedSettings.shouldFilterDueDecending = NO;
        SharedSettings.shouldFilterDueAccending = NO;
        self.dueSortButton.image = [NSImage imageNamed:@"dueSortOff"];

    }

    SDWMList *list = self.lastSelectedItem.representedObject;

    [[self cardsVC] setupCardsForList:list];

}



- (NSColor *)textColor {

	return [NSColor blackColor];
}

- (IBAction)logout:(id)sender {

    SharedSettings.userToken = nil;
    [(SDWMainSplitController *)self.parentViewController logout];
    self.boards = @[];
    [self loadBoards];
    [self.outlineView reloadData];
    [[self cardsVC] clearCards];

}
- (IBAction)crownSwitchDidChange:(ITSwitch *)sender {

    SharedSettings.shouldFilter = sender.on;
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldFilterNotification object:nil userInfo:@{@"shouldFilter":[NSNumber numberWithBool:sender.on]}];
    self.boards = nil;
    [self loadBoards];
}


#pragma mark - Board operations


- (IBAction)addBoard:(id)sender {

    if (self.delegate) {

        [self.delegate boardsListVCDidRequestAddItem];
    }
}

- (IBAction)reloadBoards:(id)sender {

    self.boards = @[];
    [self.outlineView reloadData];
    self.reloadButton.hidden = YES;
    [self loadBoards];
}

- (void)loadBoards {

    [[self cardDetailsVC] setCard:nil];
    
    if (!SharedSettings.userToken) {
        self.logoutButton.image = [NSImage imageNamed:@"logout-small-flip"];
        return;
    }

    self.logoutButton.image = [NSImage imageNamed:@"logout-small"];
    [self.loadingProgress startAnimation];
    
    SDWTrelloStoreCompletionBlock block =^(id objects, NSError *error) {
        
        [self.loadingProgress stopAnimation];
        
        if (!error) {
            
            self.outlineView.delegate = self;
            NSSortDescriptor *sortByPos = [[NSSortDescriptor alloc]initWithKey:@"starred" ascending:NO];
            self.boards = [objects sortedArrayUsingDescriptors:@[sortByPos]];
            [self reloadDataSource];
           
            
            
        } else {
            self.reloadButton.hidden = NO;
        }
    };
    
    [[SDWTrelloStore store] fetchAllBoardsCurrentData:block fetchedData:block crownFiltered:self.crownSwitch.on];

}

- (void)reloadDataSource {

    self.isAccessingExpandViaDataReload = YES;

    [self.outlineView deselectAll:nil];
    [self.outlineView expandItem:nil expandChildren:YES];
    [self.outlineView reloadData];

    self.isAccessingExpandViaDataReload = NO;

}





#pragma mark - Card operations

- (SDWCardViewController *)cardDetailsVC {

    SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
    return main.cardDetailsVC;
}

- (SDWCardsController *)cardsVC {

	SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
	return main.cardsVC;
}

- (void)moveCard:(NSDictionary *)cardData {

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidRemoveCardNotification object:nil userInfo:@{@"cardID":cardData[@"cardID"]}];

    [[SDWTrelloStore store] moveCardID:cardData[@"cardID"]
                              toListID:self.boardWithDrop.trelloID
                               boardID:self.boardWithDropParent.trelloID];
}




#pragma mark - SDWBoardsListRowDelegate

- (void)boardRowDidDoubleClick:(SDWBoardsListRow *)boardRow {}

#pragma mark - SDWBoardsListOutlineViewDelegate

- (void)outlineviewShouldAddListToBoardAtRow:(NSUInteger)boardRow {

    SDWBoard *board =[[self.outlineView itemAtRow:boardRow] representedObject];
    if (self.delegate) {
        [self.delegate boardsListVCDidRequestAddListToBoard:board];
    }
}

- (void)outlineviewShouldEditBoardAtRow:(NSUInteger)boardRow {

     SDWBoard *board =[[self.outlineView itemAtRow:boardRow] representedObject];

    if (self.delegate) {
        [self.delegate boardsListVCDidRequestBoardEdit:board];
    }
}

- (void)outlineviewShouldDeleteBoardAtRow:(NSUInteger)boardRow {
    SDWBoardDisplayItem *board =[[self.outlineView itemAtRow:boardRow] representedObject];

    [[SDWTrelloStore store] deleteBoardID:board.trelloID completion:^(id object, NSError *error) {

        [self reloadBoards:nil];
    }];

}

- (void)outlineviewShouldDeleteListAtRow:(NSUInteger)listRow {

    SDWBoardDisplayItem *board =[[self.outlineView itemAtRow:listRow] representedObject];

    [[SDWTrelloStore store] deleteListID:board.trelloID withCompletion:^(id object, NSError *error) {

        [self reloadBoards:nil];
    }];

}

- (void)outlineviewShouldAddListBelowRow:(NSUInteger)listRow {


}


#pragma mark - NSOutlineViewDelegate,NSOutlineViewDataSource

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(NSTreeNode *)item {

    SDWBoardsListRow *row = [SDWBoardsListRow new];
    return row;
}

- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {

    SDWBoardDisplayItem *board =[[self.outlineView itemAtRow:row] representedObject];
    SDWBoardsListRow *boardNameRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:row makeIfNecessary:YES];
    boardNameRow.delegate = self;

    if (!board.isLeaf) {
        boardNameRow.backgroundColor = [SharedSettings appBackgroundColor];
        [boardNameRow setNeedsDisplay:YES];
    }

}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {

    [[self cardDetailsVC] setCard:nil];

	SDWListDisplayItem *list = item.representedObject;

	if (list.isLeaf) {

        SharedSettings.lastSelectedList = list.trelloID;
        self.lastSelectedItem = item;

		[[self cardsVC] setupCardsForList:list];

		return YES;
	}
    
	return NO;
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification {

    if (self.outlineView.selectedRow == -1) {
        return;
    }

	self.prevSelectedRow.selected = NO;
	[self.prevSelectedRow setNeedsDisplay:YES];

	SDWBoardsListRow *selectedRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:self.outlineView.selectedRow makeIfNecessary:YES];
	selectedRow.selected = YES;
	[selectedRow setNeedsDisplay:YES];

	self.prevSelectedRow = selectedRow;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {

    SDWBoardDisplayItem *board  = [item representedObject];

    if (self.isAccessingExpandViaDataReload) {

        if ([SharedSettings.collapsedBoardsIDs containsObject:board.trelloID]) {
            return NO;
        }

    } else {

        NSMutableSet *set = [NSMutableSet setWithSet:SharedSettings.collapsedBoardsIDs];
        [set removeObject:board.trelloID];
        SharedSettings.collapsedBoardsIDs = [NSSet setWithSet:set];

    }

    return YES;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(NSTreeNode *)item {

    if([item.childNodes containsObject:self.lastSelectedItem]) {
        [[self cardsVC] clearCards];
    }

    SDWBoardDisplayItem *board  = [item representedObject];
    NSMutableSet *set = [NSMutableSet setWithSet:SharedSettings.collapsedBoardsIDs];

    [set addObject:board.trelloID];

    SharedSettings.collapsedBoardsIDs = [NSSet setWithSet:set];

    return YES;
}

// handle drop
- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(NSTreeNode *)item proposedChildIndex:(NSInteger)index {
    if (item.isLeaf) {
        self.boardWithDropParent = item.parentNode.representedObject;
        self.boardWithDrop = item.representedObject;
        return NSDragOperationMove;
    }
    return NSDragOperationNone;

}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id<NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index {

    NSPasteboard *pBoard = [info draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"REORDER_DRAG_TYPE"];

    NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];

    if ([cardDict[@"boardID"] isEqualToString:self.boardWithDrop.trelloID]) {
        return NO;
    }
    else  {

        [self moveCard:cardDict];

    }

    return YES;
}

@end
