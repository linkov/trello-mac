//
//  SDWBoardsController.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWMainSplitController.h"
#import "SDWBoard.h"
#import "SDWBoardsController.h"
#import "SDWCardsController.h"

@interface SDWBoardsController () <NSOutlineViewDelegate>
@property (strong) NSArray *boards;
@property (strong) IBOutlet NSOutlineView *outlineView;
@property NSUInteger selectedIndex;

@end

@implementation SDWBoardsController

- (void)viewDidLoad {
	[super viewDidLoad];


    [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        if (self.selectedIndex) {
            [self.outlineView reloadData];
            [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.selectedIndex] byExtendingSelection:NO];
        }
    }];

	self.textColor = [NSColor whiteColor];
	[self loadBoards];
}

- (NSColor *)textColor {

	return [NSColor whiteColor];
}

- (void)loadBoards {

	if (SharedSettings.userToken) {

		[[AFRecordPathManager manager]
		 setAFRecordMethod:@"findAll"
		          forModel:[SDWBoard class]
		    toConcretePath:@"member/alexlink2/boards?fields=name&lists=open"];

		[SDWBoard findAll:^(NSArray *objects, NSError *error) {

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


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {

	SDWBoard *board = item.representedObject;


	if (board.isLeaf) {


		SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
		[main.cardsVC setupCardsForList:board.boardID];

		return YES;
	}
	return NO;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    self.selectedIndex = self.outlineView.selectedRowIndexes.firstIndex;
}


- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
    [rowView setEmphasized:NO];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
	return NO;
}

@end
