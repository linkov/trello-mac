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

/*-------Helpers & Managers-------*/
#import "NSColor+AppColors.h"
#import "SDWCardsListDataSource.h"
#import "SDWCardsListDelegate.h"

/*-------Models-------*/

@interface SDWCardsListViewController ()
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSTextField *listNameLabel;

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

    NSLog(@"cards = %@",items);
//    self.tableView.dataSource = [[SDWCardsListDataSource alloc]initWithItems:items];
//    self.tableView.delegate = [[SDWCardsListDelegate alloc]initWithItems:items];
//    [self reloadEntries];
}

- (void)reloadEntries {
    [self.tableView reloadData];
}

@end
