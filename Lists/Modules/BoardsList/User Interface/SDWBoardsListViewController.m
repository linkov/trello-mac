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
#import "ITSwitch.h"

/*-------Helpers & Managers-------*/
#import "NSColor+AppColors.h"
#import "SDWSourceListDataSource.h"
#import "SDWSourceListDelegate.h"
#import "KZAsserts.h"

/*-------Models-------*/

@interface SDWBoardsListViewController ()

@property (strong) IBOutlet NSOutlineView *outlineView;

@property SDWSourceListDataSource *outlineViewDatasource;
@property SDWSourceListDelegate *outlineViewDelegate;

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
    self.outlineViewDatasource = (id)[[SDWSourceListDataSource alloc] initWithItems : items];

    self.outlineViewDelegate = (id)[[SDWSourceListDelegate alloc] initWithItems : items
                                    cellDidClickBlock :^(id item)

    {
        [self.eventHandler selectList:item];
        [self.moduleDelegate boardsListModuleDidSelectList:item];
    }];

    self.outlineView.dataSource = (id)self.outlineViewDatasource;
    self.outlineView.delegate = (id)self.outlineViewDelegate;
    [self reloadEntries];
}

- (void)reloadEntries {
    [self.outlineView reloadData];
}

#pragma mark - Actions

- (IBAction)crownSwithDidChange:(ITSwitch *)sender  {
    [self.moduleDelegate boardsListModuleDidSwitchCrown:sender.isOn];
}

- (IBAction)logoutDidClick:(id)sender {
    [self.moduleDelegate boardsListModuleDidRequestLogout];
}

@end
