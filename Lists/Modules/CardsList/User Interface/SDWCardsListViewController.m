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

/*-------Helpers & Managers-------*/
#import "NSColor+AppColors.h"
#import "SDWCardsListDataSource.h"
#import "SDWCardsListDelegate.h"
#import "JWCTableView.h"

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

    [self setupUI];
    [self.eventHandler showCardsForCurrentList];
}

- (void)setupUI {
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor appBackgroundColorDark] CGColor]];
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
    NSLog(@"cards = %@", items);


    self.tableViewDataSource = [[SDWCardsListDataSource alloc]initWithItems:items configureBlock:^id(id item) {

        SDWCardManaged *card = item;
        NSTableCellView *cell = [self.tableView makeViewWithIdentifier:@"cardCellView" owner:self];
        cell.textField.stringValue = card.name;

        return cell;

    }];

    self.tableViewDelegate = [[SDWCardsListDelegate alloc]initWithItems:items clickBlock:^(id cell, id item) {

        //

    } doubleClickBlock:^(id cell, id item) {

        //

    } rightClickBlock:^(id cell, id item) {

        //
    }];

    self.tableView.jwcTableViewDataSource = (id)self.tableViewDataSource;
    self.tableView.jwcTableViewDelegate = (id)self.tableViewDelegate;

    [self reloadEntries];
}

- (void)reloadEntries {
    [self.tableView reloadData];
}

@end
