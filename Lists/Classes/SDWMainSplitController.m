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
#import "SDWModalEditVC.h"

#import "SDWMainSplitController.h"
#import "SDWLoginVC.h"
#import "SDWTrelloStore.h"
#import "SDWBoardDisplayItem.h"

@interface SDWMainSplitController ()
@property (strong) IBOutlet NSSplitViewItem *boardsSplitItem;
@property (strong) IBOutlet NSSplitViewItem *cardsSplitItem;
@property (strong) IBOutlet NSSplitViewItem *cardDetailSplitItem;

@property (strong) SDWModalEditVC *addItemVC;
@property (strong) SDWLoginVC *loginVC;
@property (strong) NSLayoutConstraint *sideBarWidth;
@property (strong) NSLayoutConstraint *cardDetailsWidth;
@property (strong) SDWBoardDisplayItem *currentlyEditedBoardList;
@property (strong) SDWBoardDisplayItem *parentBoardForNewList;

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
    self.boardsVC.delegate = self;

    self.cardDetailsWidth = [NSLayoutConstraint constraintWithItem:self.cardDetailsVC.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];

    [self.cardDetailsVC.view addConstraint:self.cardDetailsWidth];

	[[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidReceiveUserTokenNotification
	                                                  object:nil
	                                                   queue:[NSOperationQueue mainQueue]
	                                              usingBlock:^(NSNotification *note)
	{

	    [self dismissLogin];
	    [(SDWBoardsController *)self.boardsSplitItem.viewController loadBoards];
        self.cardsVC.onboardingImage.hidden = NO;
	}];


    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidChangeSidebarStatusNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

	    [self toggleSideBar];
	}];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsDidChangeCardDetailsStatusNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self toggleCardDetails];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldReloadListNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        [self.cardsVC reloadCards];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SDWListsShouldReloadBoardsNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

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

- (void)openAddItem {




}

- (void)logout {

    if (!SharedSettings.userToken) {

        self.loginVC = [self.storyboard instantiateControllerWithIdentifier:@"loginVC"];
        [self presentViewControllerAsSheet:self.loginVC];
    }
}

- (void)viewDidAppear {
    [self toggleCardDetails];
    [self logout];
}


# pragma mark - Delegate methods

- (void)addItemVCDidFinishWithName:(NSString *)name didCancel:(BOOL)didCancel {

    self.currentlyEditedBoardList.name = name;

    [self dismissViewController:self.addItemVC];

    if (didCancel) {
        return;
    }

    if (self.currentlyEditedBoardList) {

        if (self.currentlyEditedBoardList.isLeaf) {

            [[SDWTrelloStore store] renameList:self.currentlyEditedBoardList];
            self.currentlyEditedBoardList = nil;
            [self.boardsVC reloadBoards:nil];

        } else {

            [[SDWTrelloStore store] renameBoard:self.currentlyEditedBoardList];
            self.currentlyEditedBoardList = nil;
            [self.boardsVC reloadBoards:nil];
        }



    } else if (self.parentBoardForNewList) {
        
        [[SDWTrelloStore store] createListWithName:name inBoard:self.parentBoardForNewList position:@(0) updatedList:^(id object) {
           
            self.parentBoardForNewList = nil;
            [self.boardsVC reloadBoards:nil];
        }];


        
    }


    else {

        [[SDWTrelloStore store] createBoardWithName:name updatedBoard:^(id object) {
            [self.boardsVC reloadBoards:nil];
        }];
        
    }





}

- (void)boardsListVCDidRequestBoardEdit:(SDWBoardDisplayItem *)board {

    self.currentlyEditedBoardList = board;

    NSString *title;

    if (self.currentlyEditedBoardList.isLeaf) {
        title = @"Rename list";
    } else {
        title = @"Rename board";
    }

    self.addItemVC = [self.storyboard instantiateControllerWithIdentifier:@"SDWModalEditVC"];
    self.addItemVC.delegate = self;
    self.addItemVC.titleString = title;
    self.addItemVC.valueString = board.name;
    [self presentViewControllerAsSheet:self.addItemVC];
    
}


- (void)boardsListVCDidRequestAddListToBoard:(SDWBoardDisplayItem *)board {

    self.parentBoardForNewList = board;

    self.addItemVC = [self.storyboard instantiateControllerWithIdentifier:@"SDWModalEditVC"];
    self.addItemVC.delegate = self;
    self.addItemVC.titleString = @"Add list";
    [self presentViewControllerAsSheet:self.addItemVC];
}

- (void)boardsListVCDidRequestAddItem {

    self.addItemVC = [self.storyboard instantiateControllerWithIdentifier:@"SDWModalEditVC"];
    self.addItemVC.delegate = self;
    self.addItemVC.titleString = @"Add board";
    [self presentViewControllerAsSheet:self.addItemVC];

}



@end
