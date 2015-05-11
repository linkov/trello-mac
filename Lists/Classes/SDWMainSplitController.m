//
//  SDWMainSplitController.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCardViewController.h"
#import "SDWCardsController.h"
#import "SDWBoardsController.h"
#import "SDWBoard.h"
#import "SDWCard.h"
#import "AFRecordPathManager.h"
#import "SDWMainSplitController.h"
#import "SDWLoginVC.h"

@interface SDWMainSplitController ()
@property (strong) IBOutlet NSSplitViewItem *boardsSplitItem;
@property (strong) IBOutlet NSSplitViewItem *cardsSplitItem;
@property (strong) IBOutlet NSSplitViewItem *cardDetailSplitItem;

@property (strong) SDWLoginVC *loginVC;
@property (strong) NSLayoutConstraint *sideBarWidth;
@property (strong) NSLayoutConstraint *cardDetailsWidth;

@end

@implementation SDWMainSplitController

- (void)viewDidLoad {
    [super viewDidLoad];

    SharedSettings.shouldFilter = NO;

    self.cardsVC = (SDWCardsController *)self.cardsSplitItem.viewController;
    self.boardsVC = (SDWBoardsController *)self.boardsSplitItem.viewController;
    self.cardDetailsVC = (SDWCardViewController *)self.cardDetailSplitItem.viewController;

    self.sideBarWidth = [NSLayoutConstraint constraintWithItem:self.boardsVC.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];

    [self.boardsVC.view addConstraint:self.sideBarWidth];

    self.cardDetailsWidth = [NSLayoutConstraint constraintWithItem:self.cardDetailsVC.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];

    [self.cardDetailsVC.view addConstraint:self.cardDetailsWidth];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidReceiveUserTokenNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^( NSNotification *note )
    {
        [self dismissLogin];
        [(SDWBoardsController *)self.boardsSplitItem.viewController loadBoards];
        self.cardsVC.onboardingImage.hidden = NO;
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidChangeSidebarStatusNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^( NSNotification *note ) {
        [self toggleSideBar];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidChangeCardDetailsStatusNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^( NSNotification *note ) {
        [self toggleCardDetails];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldReloadListNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^( NSNotification *note ) {
        [self.cardsVC reloadCards];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldReloadBoardsNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^( NSNotification *note ) {
        [self.cardsVC clearCards];
        [self.boardsVC reloadBoards:nil];
    }];
}

- (void)toggleCardDetails {
    if (self.cardDetailsWidth.constant != 0) {
        self.cardDetailsWidth.constant = 0;
    } else {
        self.cardDetailsWidth.constant = 300;
    }
}

- (void)toggleSideBar {
    if (self.sideBarWidth.constant != 0) {
        self.sideBarWidth.constant = 0;
    } else {
        self.sideBarWidth.constant = 200;
    }
}

- (void)dismissLogin  {
    [self dismissViewController:self.loginVC];
}

- (void)logout {
    if (!SharedSettings.userToken) {
        self.loginVC = [self.storyboard instantiateControllerWithIdentifier:@"loginVC"];
        [self presentViewControllerAsSheet:self.loginVC];
    }
}

- (void)viewDidAppear {
    [self logout];
}

@end
