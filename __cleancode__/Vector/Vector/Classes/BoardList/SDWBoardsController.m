//
//  SDWBoardsController.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSImage+HHTint.h"
#import "NSColor+Util.h"
#import "SDWAppSettings.h"
#import "SDWMainSplitController.h"
#import "SDWBoard.h"
#import "SDWBoardsController.h"
#import "SDWCardsController.h"
#import "SDWBoardsListRow.h"

@interface SDWBoardsController () <NSOutlineViewDelegate,NSOutlineViewDataSource>
@property (strong) NSArray *boards;
@property (strong) IBOutlet NSOutlineView *outlineView;
@property (strong) IBOutlet NSProgressIndicator *loadingProgress;

@property (strong) SDWBoardsListRow *prevSelectedRow;
@property (strong) IBOutlet NSBox *mainBox;
@property (strong) IBOutlet NSImageView *crownImageView;

@end

@implementation SDWBoardsController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self loadBoards];
    self.mainBox.fillColor = [SharedSettings appBackgroundColorDark];
    self.outlineView.backgroundColor = [SharedSettings appBackgroundColorDark];
    [self.outlineView registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];
    self.outlineView.dataSource = self;

}

- (NSColor *)textColor {

	return [NSColor blackColor];
}

- (void)loadBoards {

	if (SharedSettings.userToken) {

		[[self cardsVC].loadingIndicator startAnimation:nil];

		[[AFRecordPathManager manager]
		 setAFRecordMethod:@"findAll"
		          forModel:[SDWBoard class]
		    toConcretePath:@"member/alexlink2/boards?fields=name&lists=open"];


		[self.loadingProgress startAnimation:nil];
		[SDWBoard findAll:^(NSArray *objects, NSError *error) {

		    [self.loadingProgress stopAnimation:nil];

		    [[self cardsVC].loadingIndicator stopAnimation:nil];
		    if (!error) {

		        NSLog(@"boards - %@", objects);

		        self.boards = objects;
		        self.outlineView.delegate = self;
		        [self.outlineView deselectAll:nil];
		        [self.outlineView expandItem:nil expandChildren:YES];
		        [self.outlineView reloadData];
			} else {
		        NSLog(@"err = %@", error.localizedDescription);
			}
		}];
	}
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

- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {

    SDWBoard *board =[self.outlineView itemAtRow:row];

    if (!board.isLeaf) {

        SDWBoardsListRow *boardNameRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:row makeIfNecessary:YES];
        boardNameRow.backgroundColor = [SharedSettings appBackgroundColor];
        [boardNameRow setNeedsDisplay:YES];
    }


}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {

	SDWBoard *board = item.representedObject;

	if (board.isLeaf) {

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
- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {

    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id<NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index {
    return YES;
}

@end
