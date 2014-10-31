//
//  SDWBoardsController.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWMainSplitController.h"
#import "SDWBoard.h"
#import "SDWBoardsController.h"
#import "SDWCardsController.h"

@interface SDWBoardsController () <NSOutlineViewDelegate>
@property (strong) NSArray *boards;
@property (strong) IBOutlet NSOutlineView *outlineView;


@end

@implementation SDWBoardsController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"didload");

    self.textColor = [NSColor whiteColor];
    [self setupBoards];
}

- (NSColor *)textColor {

    return [NSColor whiteColor];
}

- (void)setupBoards {

    [SDWBoard findAll:^(NSArray *objects, NSError *error) {

        if (!error) {

            NSLog(@"boards - %@",objects);

            self.boards = objects;
            [self.outlineView deselectAll:nil];
            [self.outlineView expandItem:nil expandChildren:YES];
            [self.outlineView reloadData];
        }
        else  {
            NSLog(@"err = %@",error.localizedDescription);
        }
    }];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {

    SDWBoard *board = item.representedObject;


    if (board.isLeaf) {

        SDWMainSplitController *main = (SDWMainSplitController *)self.parentViewController;
        [main.cardsVC setupCardsForList:board.boardID];
//
//        SDWCardsController *cardsVC = [self.storyboard instantiateControllerWithIdentifier:@"cardsVC"];
//        [cardsVC setupCardsForList:board.boardID];

        return YES;

    }
        return NO;
}

- (NSCell*)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {

    NSTextFieldCell *cell = [tableColumn dataCell];
    [cell setTextColor:[NSColor whiteColor]];

    return cell;

}

-(BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
    // replace this with your logic to determine whether the
    // disclosure triangle should be hidden for a particular item
    return NO;
}

//
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode *)item {

    if (item.isLeaf) {

        [cell setTextColor:[NSColor lightGrayColor]];
    }
    else {

        [cell setTextColor:[NSColor whiteColor]];
    }


}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   shouldExpandItem:(id)item {

    return YES;

}


@end
