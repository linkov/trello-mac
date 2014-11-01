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
@property (strong) IBOutlet NSSplitViewItem *inspectorSplitItem;

@property (strong) SDWLoginVC *loginVC;

@end

@implementation SDWMainSplitController

- (void)viewDidLoad {
    [super viewDidLoad];

    SDWBoardsController *boardsVC = [self.storyboard instantiateControllerWithIdentifier:@"boardsVC"];
    self.cardsVC = [self.storyboard instantiateControllerWithIdentifier:@"cardsVC"];
    self.inspectorVC = [self.storyboard instantiateControllerWithIdentifier:@"singleCardVC"];

    self.boardsSplitItem = [NSSplitViewItem new];
    [self.boardsSplitItem setViewController:boardsVC];
    //self.boardsSplitItem.holdingPriority = NSLayoutPriorityDefaultLow;

    self.cardsSplitItem = [NSSplitViewItem new];
    [self.cardsSplitItem setViewController:self.cardsVC];
    //self.cardsSplitItem.holdingPriority = NSLayoutPriorityRequired;

    self.inspectorSplitItem = [NSSplitViewItem new];
    [self.inspectorSplitItem setViewController:self.inspectorVC];
    self.inspectorSplitItem.collapsed = YES;



    [self addSplitViewItem:self.boardsSplitItem];
    [self addSplitViewItem:self.cardsSplitItem];
    [self addSplitViewItem:self.inspectorSplitItem];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"com.sdwr.trello-mac.didReceiveUserTokenNotification"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {

        [self dismissLogin];
        [self.boardsVC loadBoards];

    }];

   // self.firstSplitItem = [self splitViewItemForViewController:boardsVC];

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
