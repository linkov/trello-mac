//
//  SDWCardsListViewController.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListViewController.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/
#import "SDWSingleCardTableCellView.h"
#import "SDWCardListView.h"
#import "SDWCardsListCell.h"

/*-------Helpers & Managers-------*/
#import "NSColor+AppColors.h"
#import "SDWCardsListDataSource.h"
#import "SDWCardsListDelegate.h"
#import "JWCTableView.h"
#import "Constants.h"

/*-------Models-------*/
#import "SDWCardManaged.h"

@interface SDWCardsListViewController ()
@property (strong) IBOutlet JWCTableView *tableView;
@property (strong) IBOutlet NSTextField *listNameLabel;

@property SDWCardsListDataSource *tableViewDataSource;
@property SDWCardsListDelegate *tableViewDelegate;

@end

@implementation SDWCardsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerForDraggedTypes:@[SDWListsCardsListDragedTypesReorder]];
    [self.tableView setDraggingDestinationFeedbackStyle:NSTableViewDraggingDestinationFeedbackStyleGap];

    [self setupUI];
    [self.eventHandler showCardsForCurrentList];
}

- (void)setupUI {
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor appBackgroundColorDark] CGColor]];

    self.listNameLabel.textColor = [NSColor appBleakWhiteColor];
}

#pragma mark - Actions

- (IBAction)addCardDidClick:(id)sender {
}

#pragma mark - SDWCardsListUserInterface

- (void)showListTitle:(NSString *)title {
    self.listNameLabel.stringValue = title;
}

- (void)showNoContentMessage {
}

- (void)showContentWithItems:(NSArray *)items {
    self.tableViewDataSource = [[SDWCardsListDataSource alloc]initWithItems:items configureBlock:^id (id item) {
        SDWCardManaged *card = item;
        SDWCardsListCell *cell = [self.tableView makeViewWithIdentifier:@"cardCellView" owner:self];
        cell.textField.stringValue = card.name;

        __weak SDWCardsListCell *weakCell = cell;

        cell.rightClickBlock = ^(){
            __strong SDWCardsListCell *strongWeakCell = weakCell;

            NSLog(@"right clicked card %@ in view %@", card.name, strongWeakCell);
        };

        cell.returnBlock = ^(){
            __strong SDWCardsListCell *strongWeakCell = weakCell;

            NSLog(@"returned card %@ with change: %@", card.name, strongWeakCell.textField.stringValue);
        };

        return cell;
    }];

    self.tableViewDelegate = [[SDWCardsListDelegate alloc]initWithItems:items reorderBlock:^(NSUInteger fromIndex, NSUInteger toIndex, NSArray *itms) {
        // NSArray *reorderedItems = [self reorderedArrayWithFromIndex:fromIndex toIndex:toIndex inArray:itms];
        //[self reloadEntries];
    }];

    self.tableView.jwcTableViewDataSource = (id)self.tableViewDataSource;
    self.tableView.jwcTableViewDelegate = (id)self.tableViewDelegate;
    [self.tableView registerNib:[SDWCardsListCell nib] forIdentifier:@"cardCellView"];

    [self reloadEntries];
}

- (void)reloadEntries {
    [self.tableView reloadData];
}

/* goes to interactor */

//#pragma mark - Utils
//
//- (NSArray *)reorderedArrayWithFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inArray:(NSArray *)arr {
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:arr];
//
//    // 1. swap 2 elements
//    SDWCardManaged *movedCard = [mutableArray objectAtIndex:fromIndex];
//    SDWCardManaged *newSiblingCard = [mutableArray objectAtIndex:toIndex];
//
//    NSUInteger movedCardPos = [movedCard.position integerValue];
//    NSUInteger newSiblingCardPos = [newSiblingCard.position integerValue];
//
//    movedCard.position = @(newSiblingCardPos);
//    newSiblingCard.position = @(movedCardPos);
//
//    [mutableArray removeObject:movedCard];
//    [mutableArray insertObject:movedCard atIndex:toIndex];
//
//    // 2. set positions to all cards equal to cards' indexes in array
//    for (int i = 0; i < mutableArray.count; i++) {
//        SDWCardManaged *card = mutableArray[i];
//        card.position = @(i);
//    }
//
//    return mutableArray;
//}

@end
