//
//  SDWBoardsListWireframe.m
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWBoardsListWireframe.h"

/*-------View Controllers-------*/
#import "SDWBoardsListViewController.h"

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWBoardsListPresenter.h"
#import  "SDWBoardsListInteractor.h"

/*-------Models-------*/


@implementation SDWBoardsListWireframe

- (NSViewController *)boardsListUserInterfaceWithDelegate:(id<SDWBoardsListModuleDelegate>)delegate {

    SDWBoardsListViewController *boardsListViewController = [[SDWBoardsListViewController alloc]initWithNibName:NSStringFromClass([SDWBoardsListViewController class]) bundle:nil];

    SDWBoardsListPresenter *presenter = [SDWBoardsListPresenter new];
    presenter.userInterface = boardsListViewController;
    boardsListViewController.eventHandler = presenter;
    boardsListViewController.moduleDelegate = delegate;
    presenter.wireframe = self;

    SDWBoardsListInteractor *interactor = [SDWBoardsListInteractor new];
    interactor.output = presenter;
    presenter.listInteractor = interactor;

    return boardsListViewController;

}

@end
