//
//  SDWMainSplitController.m
//  Vector
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

@property (strong) SDWLoginVC *loginVC;
@property (strong) NSLayoutConstraint *sideBarWidth;

@end

@implementation SDWMainSplitController

- (void)viewDidLoad {
	[super viewDidLoad];

//   // NSWindowController *winCon = [self.storyboard instantiateInitialController];
//   // NSWindow *window = [NSApplication sharedApplication].keyWindow;
//  //  window.styleMask = window.styleMask | NSFullSizeContentViewWindowMask;
//
//  //  [NSApplication sharedApplication].keyWindow.titlebarAppearsTransparent = YES;
//
//    SDWBoardsController *boardsVC = [self.storyboard instantiateControllerWithIdentifier:@"boardsVC"];
//    self.cardsVC = [self.storyboard instantiateControllerWithIdentifier:@"cardsVC"];
//
//    self.boardsSplitItem = [NSSplitViewItem new];
//    [self.boardsSplitItem setViewController:boardsVC];
//    //self.boardsSplitItem.holdingPriority = NSLayoutPriorityDefaultLow;
//
//    self.cardsSplitItem = [NSSplitViewItem new];
//    [self.cardsSplitItem setViewController:self.cardsVC];
//    //self.cardsSplitItem.holdingPriority = NSLayoutPriorityRequired;
//
//    [self addSplitViewItem:self.boardsSplitItem];
//    [self addSplitViewItem:self.cardsSplitItem];
//

	//  NSSplitViewItem *cardsItem = self.splitViewItems[1];

//    NSLog(@"split item vc - %@",self.cardsSplitItem.viewController);


	self.cardsVC = (SDWCardsController *)self.cardsSplitItem.viewController;
	self.boardsVC = (SDWBoardsController *)self.boardsSplitItem.viewController;

	self.sideBarWidth = [NSLayoutConstraint constraintWithItem:self.boardsVC.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];

	[self.boardsVC.view addConstraint:self.sideBarWidth];

	[[NSNotificationCenter defaultCenter] addObserverForName:@"com.sdwr.trello-mac.didReceiveUserTokenNotification"
	                                                  object:nil
	                                                   queue:[NSOperationQueue mainQueue]
	                                              usingBlock:^(NSNotification *note)
	{

	    [self dismissLogin];
	    [(SDWBoardsController *)self.boardsSplitItem.viewController loadBoards];
	}];


	[[NSNotificationCenter defaultCenter] addObserverForName:@"com.sdwr.trello-mac.didChangeSidebarStatusNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

	    [self toggleSideBar];
	}];

	// self.firstSplitItem = [self splitViewItemForViewController:boardsVC];
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

- (void)viewDidAppear {

    if (!SharedSettings.userToken) {

        self.loginVC = [self.storyboard instantiateControllerWithIdentifier:@"loginVC"];
        [self presentViewControllerAsSheet:self.loginVC];
    }
}

//- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
//
//
//}

@end
