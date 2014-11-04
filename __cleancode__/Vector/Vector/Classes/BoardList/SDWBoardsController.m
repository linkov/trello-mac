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
@property (strong) IBOutlet NSProgressIndicator *loadingProgress;

@end

@implementation SDWBoardsController

- (void)viewDidLoad {
	[super viewDidLoad];

//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200] ];

	[self loadBoards];
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
    self.selectedIndex = self.outlineView.selectedRowIndexes.firstIndex;
}


//- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
//    [rowView setEmphasized:NO];
//}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
	return NO;
}

@end
