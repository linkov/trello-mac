//
//  SDWBoardsController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSImage+Util.h"
#import "NSImage+HHTint.h"
#import "NSColor+Util.h"
#import "SDWAppSettings.h"
#import "SDWMainSplitController.h"
#import "SDWBoard.h"
#import "SDWBoardsController.h"
#import "SDWCardsController.h"
#import "SDWBoardsListRow.h"
#import "AFTrelloAPIClient.h"
#import "SDWLoginVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ITSwitch.h"
#import "WSCBoardsOutlineView.h"
#import "SDWBoardsCellView.h"
#import "SDWProgressIndicator.h"
#import "SDWCardViewController.h"

#import "SDWTrelloStore.h"

@interface SDWBoardsController () <NSOutlineViewDelegate, NSOutlineViewDataSource, SDWBoardsListRowDelegate, SDWBoardsListOutlineViewDelegate, NSTextFieldDelegate>
@property (strong) NSArray *boards;
//@property (strong) NSArray *crownBoards;
@property (strong) NSArray *unfilteredBoards;
@property (strong) IBOutlet WSCBoardsOutlineView *outlineView;

@property (strong) NSTreeNode *lastSelectedItem;
@property (strong) SDWBoardsListRow *prevSelectedRow;
@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet NSImageView *crownImageView;
@property (strong) SDWBoard *boardWithDrop;
@property (strong) SDWBoard *boardWithDropParent;
@property (strong) IBOutlet NSButton *logoutButton;
@property (strong) IBOutlet ITSwitch *crownSwitch;
@property (strong) IBOutlet NSScrollView *mainScroll;
@property (strong) IBOutlet NSButton *reloadButton;

@property (strong) SDWBoard *parentBoardForEditedList;
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

    SDWBoard *board = self.lastSelectedItem.representedObject;
    SDWBoard *parentBoard = self.lastSelectedItem.parentNode.representedObject;

    [[self cardsVC] setupCardsForList:board parentList:parentBoard];
}

- (NSArray *)filteredBoardsForIDs:(NSArray *)ids listIDs:(NSArray *)lids {
    NSMutableArray *boards = [NSMutableArray array];

    for (SDWBoard *board in self.unfilteredBoards) {
        NSString *boardID = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", board.boardID]].firstObject;

        if (boardID) {
            NSMutableArray *lists = [NSMutableArray array];
            for (SDWBoard *list in board.children) {
                NSString *listID = [lids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", list.boardID]].firstObject;

                if (listID) {
                    [lists addObject:list];
                }
            }
            board.children = lists;
            [boards addObject:board];
        }
    }
    return boards;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldFilterNotification object:nil userInfo:@{@"shouldFilter": [NSNumber numberWithBool:sender.on]}];
    self.boards = nil;
    [self loadBoards];
}

#pragma mark - Board operations

- (IBAction)reloadBoards:(id)sender {
    self.boards = @[];
    [self.outlineView reloadData];
    self.reloadButton.hidden = YES;
    [self loadBoards];
}

- (void)loadBoards {
    [[self cardDetailsVC] setCard:nil];

    if (SharedSettings.userToken) {
        [self.loadingProgress startAnimation];

        self.logoutButton.image = [NSImage imageNamed:@"logout-small"];

        [[AFRecordPathManager manager]
         setAFRecordMethod:@"findAll"
                  forModel:[SDWBoard class]
            toConcretePath:@"members/me/boards?filter=open&fields=name,starred&lists=open"];

        [SDWBoard findAll:^( NSArray *objects, NSError *error ) {
            [self.loadingProgress stopAnimation];

            if (!error) {
                NSSortDescriptor *sortByPos = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:NO];

                self.unfilteredBoards = [objects sortedArrayUsingDescriptors:@[sortByPos]];
                self.outlineView.delegate = self;

                if (self.crownSwitch.on) {
                    [self loadBoardsIDsWithUserCards];
                } else {
                    self.boards = self.unfilteredBoards;
                    [self reloadDataSource];
                }
            } else {
                self.reloadButton.hidden = NO;
                CLS_LOG( @"err = %@", error.localizedDescription );
            }
        }];
    } else {
        self.logoutButton.image = [NSImage imageNamed:@"logout-small-flip"];
    }
}

- (void)reloadDataSource {
    self.isAccessingExpandViaDataReload = YES;

    [self.outlineView deselectAll:nil];
    [self.outlineView expandItem:nil expandChildren:YES];
    [self.outlineView reloadData];

    self.isAccessingExpandViaDataReload = NO;
}

- (void)loadBoardsIDsWithUserCards {
    [[SDWTrelloStore store] fetchAllAssigneesWithCompletion:^( NSDictionary *object, NSError *error ) {
        if (!error) {
            self.boards = [self filteredBoardsForIDs:object[@"crownBoardIDs"] listIDs:object[@"crownListIDs"]];
            [self reloadDataSource];
        } else {
            [self.crownSwitch setOn:NO];
        }
    }];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidRemoveCardNotification object:nil userInfo:@{@"cardID": cardData[@"cardID"]}];

    [[SDWTrelloStore store] moveCardID:cardData[@"cardID"]
                              toListID:self.boardWithDrop.boardID
                               boardID:self.boardWithDropParent.boardID];
}

#pragma mark - SDWBoardsListRowDelegate

- (void)boardRowDidDoubleClick:(SDWBoardsListRow *)boardRow {
}

#pragma mark - SDWBoardsListOutlineViewDelegate

- (void)outlineviewShouldDeleteListAtRow:(NSUInteger)listRow {
//
//    SDWBoard *board =[[self.outlineView itemAtRow:listRow] representedObject];
//    [self deleteList:board];
}

- (void)outlineviewShouldAddListBelowRow:(NSUInteger)listRow {
}

#pragma mark - NSOutlineViewDelegate,NSOutlineViewDataSource

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(NSTreeNode *)item {
    SDWBoardsListRow *row = [SDWBoardsListRow new];
    return row;
}

- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
    SDWBoard *board = [[self.outlineView itemAtRow:row] representedObject];
    SDWBoardsListRow *boardNameRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:row makeIfNecessary:YES];
    boardNameRow.delegate = self;

    if (!board.isLeaf) {
        boardNameRow.backgroundColor = [SharedSettings appBackgroundColor];
        [boardNameRow setNeedsDisplay:YES];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {
    [[self cardDetailsVC] setCard:nil];

    SDWBoard *board = item.representedObject;

    if (board.isLeaf) {
        SharedSettings.lastSelectedList = board.boardID;
        self.lastSelectedItem = item;
        SDWBoard *parentBoard = item.parentNode.representedObject;

        [[self cardsVC] setupCardsForList:board parentList:parentBoard];

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
    SDWBoard *board = [item representedObject];

    if (self.isAccessingExpandViaDataReload) {
        if ([SharedSettings.collapsedBoardsIDs containsObject:board.boardID]) {
            return NO;
        }
    } else {
        SDWBoard *board = [item representedObject];

        NSMutableSet *set = [NSMutableSet setWithSet:SharedSettings.collapsedBoardsIDs];
        [set removeObject:board.boardID];
        SharedSettings.collapsedBoardsIDs = [NSSet setWithSet:set];
    }

    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(NSTreeNode *)item {
    if ([item.childNodes containsObject:self.lastSelectedItem]) {
        [[self cardsVC] clearCards];
    }

    SDWBoard *board = [item representedObject];
    NSMutableSet *set = [NSMutableSet setWithSet:SharedSettings.collapsedBoardsIDs];

    [set addObject:board.boardID];

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

    if ([cardDict[@"boardID"] isEqualToString:self.boardWithDrop.boardID]) {
        return NO;
    } else {
        [self moveCard:cardDict];
    }

    return YES;
}

@end
