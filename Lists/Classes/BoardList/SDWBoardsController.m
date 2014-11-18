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

@interface SDWBoardsController () <NSOutlineViewDelegate,NSOutlineViewDataSource,SDWBoardsListRowDelegate,SDWBoardsListOutlineViewDelegate,NSTextFieldDelegate>
@property (strong) NSArray *boards;
//@property (strong) NSArray *crownBoards;
@property (strong) NSArray *unfilteredBoards;
@property (strong) IBOutlet WSCBoardsOutlineView *outlineView;
@property (strong) IBOutlet NSProgressIndicator *loadingProgress;

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

@end

@implementation SDWBoardsController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self loadBoards];
    self.mainBox.fillColor = [SharedSettings appBackgroundColorDark];
    self.outlineView.backgroundColor = [SharedSettings appBackgroundColorDark];
    [self.outlineView registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];
    self.outlineView.dataSource = self;
   // self.crownSwitch.enabled = NO
    self.reloadButton.hidden = YES;
    self.outlineView.menuDelegate = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:NSScrollViewWillStartLiveMagnifyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        //[self loadCardsForListID:self.currentListID];

    }];


}

- (void)viewWillAppear {

    //TODO: load last opened list

//    if (SharedSettings.lastSelectedList) {
//        [[self cardsVC] setupCardsForList:SharedSettings.lastSelectedList parentList:nil];
//    }
//
//    SDWBoard *parentBoard = item.parentNode.representedObject;
//
//    [[self cardsVC] setupCardsForList:board parentList:parentBoard];

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
   // [self reloadDataSource];
    [self loadBoards];
}

- (IBAction)reloadBoards:(id)sender {

    self.boards = @[];
    [self.outlineView reloadData];
    self.reloadButton.hidden = YES;
    [self loadBoards];
}


- (void)loadBoards {

	if (SharedSettings.userToken) {

        self.logoutButton.image = [NSImage imageNamed:@"logout-small"];

		[[AFRecordPathManager manager]
		 setAFRecordMethod:@"findAll"
		          forModel:[SDWBoard class]
		    toConcretePath:@"members/me/boards?filter=open&fields=name&lists=open"];

		[self.loadingProgress startAnimation:nil];
		[SDWBoard findAll:^(NSArray *objects, NSError *error) {

		    [self.loadingProgress stopAnimation:nil];

		    if (!error) {

		        self.unfilteredBoards = objects;
		        self.outlineView.delegate = self;

                if(self.crownSwitch.on) {
                    [self loadBoardsIDsWithUserCards];
                } else {
                    self.boards = self.unfilteredBoards;
                    [self reloadDataSource];
                }

			} else {
                self.reloadButton.hidden = NO;
		        NSLog(@"err = %@", error.localizedDescription);
			}
		}];
	}
    else {

        self.logoutButton.image = [NSImage imageNamed:@"logout-small-flip"];
    }
}

- (void)reloadDataSource {

    [self.outlineView deselectAll:nil];
    [self.outlineView expandItem:nil expandChildren:YES];
    [self.outlineView reloadData];
}

- (void)loadBoardsIDsWithUserCards {

    [[AFTrelloAPIClient sharedClient] GET:@"members/me?fields=none&cards=all&card_fields=idBoard,idList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        SharedSettings.userID = responseObject[@"id"];
        NSArray *crownBoardIDs = [responseObject[@"cards"] valueForKeyPath:@"idBoard"];
        NSArray *crownListIDs = [responseObject[@"cards"] valueForKeyPath:@"idList"];
        self.boards = [self filteredBoardsForIDs:crownBoardIDs listIDs:crownListIDs];
        [self reloadDataSource];


    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self.crownSwitch setOn:NO];
        NSLog(@"err - %@",error.localizedDescription);
    }];
}


- (NSArray *)filteredBoardsForIDs:(NSArray *)ids listIDs:(NSArray *)lids {

    NSMutableArray *boards = [NSMutableArray array];
//    NSMutableArray *allBoards = [NSMutableArray arrayWithArray:self.unfilteredBoards];

    for (SDWBoard *board in self.unfilteredBoards) {

        NSString *boardID = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@",board.boardID]].firstObject;

        if (boardID) {
            NSMutableArray *lists = [NSMutableArray array];
            for (SDWBoard *list in board.children) {

                NSString *listID = [lids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@",list.boardID]].firstObject;

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

- (SDWCardsController *)cardsVC {

	SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
	return main.cardsVC;
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(NSTreeNode *)item {

    SDWBoard *board = item.representedObject;

    if (!board.isLeaf) {

        SDWBoardsListRow *boardNameRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:[self.outlineView rowForItem:item]makeIfNecessary:YES];
        boardNameRow.backgroundColor = [SharedSettings appBackgroundColor];
        [boardNameRow setNeedsDisplay:YES];
    }



	SDWBoardsListRow *row = [SDWBoardsListRow new];
	return row;
}

- (void)moveCard:(NSDictionary *)cardData {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardData[@"cardID"]];
    
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"idList":self.boardWithDrop.boardID, @"idBoard":self.boardWithDropParent.boardID} success:^(NSURLSessionDataTask *task, id responseObject) {

            [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidRemoveCardNotification object:nil userInfo:@{@"cardID":cardData[@"cardID"]}];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"err - %@",error.localizedDescription);
    }];

}

- (void)createList {

    [[AFTrelloAPIClient sharedClient] POST:@"lists?"
                                parameters:@{
                                             @"name":self.editedListName,
                                             @"idBoard":self.parentBoardForEditedList.boardID,
                                             @"pos":[NSNumber numberWithInteger:self.editedListPositon-1]
                                             }
                                   success:^(NSURLSessionDataTask *task, id responseObject)
    {

        SDWBoardsCellView *cellView = [self.outlineView viewAtColumn:0 row:self.editedRow makeIfNecessary:YES];

        cellView.textLabel.editable = NO;
        [cellView.textLabel resignFirstResponder];
        [self reloadBoards:nil];
        [[self cardsVC] clearCards];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"err - %@",error.localizedDescription);
    }];
}

- (void)deleteList:(SDWBoard *)list {

    NSString *urlString = [NSString stringWithFormat:@"lists/%@?",list.boardID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"closed":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {

        [self reloadBoards:nil];
        [[self cardsVC] clearCards];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"err - %@",error.localizedDescription);
    }];

}

#pragma mark - SDWBoardsListRowDelegate

- (void)boardRowDidDoubleClick:(SDWBoardsListRow *)boardRow {


//    NSTreeNode *item = [self.outlineView itemAtRow:self.outlineView.selectedRow];
//    SDWBoard *board =[item representedObject];
//    SDWBoard *parentBoard = item.parentNode.representedObject;
//
//    if (board.isLeaf) {
//
//        NSLog(@"%@",board.name);
//
//        SDWCardsController *cards = [self.storyboard instantiateControllerWithIdentifier:@"cardsVC"];
//        [cards setupCardsForList:board parentList:parentBoard];
////        NSWindowController *window = [[NSWindowController alloc]init];
////        window.window = [NSWindow new];
////        window.contentViewController = cards;
////        [window showWindow:nil];
////        [window.window makeKeyAndOrderFront:self];
//
//    }
}

#pragma mark - SDWBoardsListOutlineViewDelegate

- (void)outlineviewShouldDeleteListAtRow:(NSUInteger)listRow {

    SDWBoard *board =[[self.outlineView itemAtRow:listRow] representedObject];
    [self deleteList:board];
}

- (void)outlineviewShouldAddListBelowRow:(NSUInteger)listRow {


//    SDWBoard *board = [[self.outlineView itemAtRow:listRow] representedObject];
//    self.editedListPositon = board.pos;
//    SDWBoard *parentBoard =[[[self.outlineView itemAtRow:listRow] parentNode] representedObject];
//    NSMutableArray *mutableParentBoardChildren =[NSMutableArray arrayWithArray:parentBoard.children];
//
//    NSUInteger rightClickedListIndex = [parentBoard.children indexOfObject:board];
//
//    self.parentBoardForEditedList = parentBoard;
//
//    SDWBoard *newBoard = [SDWBoard new];
//    newBoard.name = @"";
//    newBoard.isLeaf = YES;
//
//    [mutableParentBoardChildren insertObject:newBoard atIndex:rightClickedListIndex];
//    parentBoard.children = [mutableParentBoardChildren copy];
//    [self.outlineView reloadData];
//
//
//    SDWBoardsCellView *cellView = [self.outlineView viewAtColumn:0 row:listRow makeIfNecessary:YES];
//    self.editedRow = listRow;
//
//    cellView.textLabel.editable = YES;
//    [cellView.textLabel becomeFirstResponder];
//    cellView.textLabel.delegate = self;

}

#pragma mark - NSTextFieldDelegate (new list textfield)

//- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
//    self.editedListName = fieldEditor.string;
//    return YES;
//}
//- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
//    return YES;
//}
//
//- (void)controlTextDidEndEditing:(NSNotification *)obj {
//
//    if (self.editedListName.length >0) {
//        [self createList];
//    } else {
//        [self reloadBoards:nil];
//    }
//}

#pragma mark - NSOutlineViewDelegate,NSOutlineViewDataSource


- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {

    SDWBoard *board =[self.outlineView itemAtRow:row];
    SDWBoardsListRow *boardNameRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:row makeIfNecessary:YES];
    boardNameRow.delegate = self;

    if (!board.isLeaf) {

        boardNameRow.backgroundColor = [SharedSettings appBackgroundColor];
        [boardNameRow setNeedsDisplay:YES];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {

	SDWBoard *board = item.representedObject;

	if (board.isLeaf) {

        SharedSettings.lastSelectedList = board.boardID;

		SDWBoard *parentBoard = item.parentNode.representedObject;

		[[self cardsVC] setupCardsForList:board parentList:parentBoard];

		return YES;
	}
    
	return NO;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {

	self.prevSelectedRow.selected = NO;
	[self.prevSelectedRow setNeedsDisplay:YES];

	SDWBoardsListRow *selectedRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:self.outlineView.selectedRow makeIfNecessary:YES];
	selectedRow.selected = YES;
	[selectedRow setNeedsDisplay:YES];

	self.prevSelectedRow = selectedRow;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
	return NO;
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
    }
    else  {

        [self moveCard:cardDict];

    }

    return YES;
}

@end
