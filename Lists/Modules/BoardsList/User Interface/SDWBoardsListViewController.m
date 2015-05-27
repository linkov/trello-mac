//
//  SDWBoardsListViewController.m
//  Lists
//
//  Created by alex on 5/26/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWBoardsListViewController.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/
#import "WSCBoardsOutlineView.h"

/*-------Helpers & Managers-------*/
#import "NSColor+AppColors.h"
#import "SDWSourceListDataSource.h"
#import "SDWSourceListDelegate.h"

/*-------Models-------*/

@interface SDWBoardsListViewController ()

@property (strong) IBOutlet NSOutlineView *outlineView;

@end

@implementation SDWBoardsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.eventHandler updateUserInterface];
    [self setupUI];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    //
}

- (void)setupUI {
    self.outlineView.intercellSpacing = CGSizeMake(0, 5);
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor appBackgroundColorDark] CGColor]];
}

#pragma mark - SDWBoardsListUserInterface

- (void)showNoContentMessage {
}

- (void)showContentWithItems:(NSArray *)items {
    self.outlineView.dataSource = (id)[[SDWSourceListDataSource alloc] initWithItems : items];
    self.outlineView.delegate = (id)[[SDWSourceListDelegate alloc] initWithItems : items];
    [self reloadEntries];
}

- (void)reloadEntries {
    [self.outlineView reloadData];
}

@end
