//
//  SDWRootWireframe.m
//  Lists
//
//  Created by alex on 5/24/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWRootWireframe.h"

/*-------View Controllers-------*/
#import "SDWMainSplitController.h"
#import "SDWMainWindowController.h"
#import "SDWCardsListWireframe.h"

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "NSStoryboard+Utilities.h"
#import "SDWRootPresenter.h"
#import "SDWBoardsListWireframe.h"

/*-------Models-------*/

@implementation SDWRootWireframe

- (void)showRootUserInterfaceInWindow:(NSWindow *)window {
    SDWMainWindowController *windowController = [[SDWMainWindowController alloc]initWithWindow:window];
    SDWMainSplitController *splitViewController = [[SDWMainSplitController alloc]init];

    SDWRootPresenter *presenter = [[SDWRootPresenter alloc] init];
    presenter.userInterface = splitViewController;
    splitViewController.eventHandler = presenter;
    presenter.wireframe = self;

    [splitViewController addChildViewController:[self boardsListUserInterfaceWithModuleDelegate:splitViewController]];
    [splitViewController addChildViewController:[self cardsListUserInterfaceWithModuleDelegate:splitViewController]];
    //[splitViewController addChildViewController:[self cardDetailsUserInterfaceWithModuleDelegate:splitViewController]];

    [windowController setContentViewController:splitViewController];

//    NSWindowController *mainController = [[NSWindowController alloc]initWithWindow:self.window];
//
//    MainSplitViewController *splitVC = [[MainSplitViewController alloc]init];
//
//    LeftMenuVC *leftVC = [[LeftMenuVC alloc]initWithNibName:NSStringFromClass([LeftMenuVC class]) bundle:nil];
//    MainContentVC *rightVC = [[MainContentVC alloc]initWithNibName:NSStringFromClass([MainContentVC class]) bundle:nil];
//
//
//    [splitVC addChildViewController:leftVC];
//    [splitVC addChildViewController:rightVC];
//
//    [mainController setContentViewController:splitVC];
}

#pragma mark - Helpers

- (NSViewController *)boardsListUserInterfaceWithModuleDelegate:(nullable id)delegate {
    SDWBoardsListWireframe *wireframe = [[SDWBoardsListWireframe alloc] init];
    return [wireframe boardsListUserInterfaceWithDelegate:delegate];
}

- (NSViewController *)cardsListUserInterfaceWithModuleDelegate:(nullable id)delegate {
    SDWCardsListWireframe *wireframe = [[SDWCardsListWireframe alloc]init];
    return [wireframe cardsListUserInterfaceWithDelegate:delegate];
}

- (NSViewController *)cardDetailsUserInterfaceWithModuleDelegate:(nullable id)delegate {
//    CNIGuestDetailsWireframe *wireframe = [[CNIGuestDetailsWireframe alloc] init];
//    return [wireframe guestDetailsUserInterfaceWithGuest:guest moduleDelegate:delegate];
    return nil;
}

@end
