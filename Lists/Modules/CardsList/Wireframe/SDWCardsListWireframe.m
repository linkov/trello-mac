//
//  SDWCardsListWireframe.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListWireframe.h"

/*-------View Controllers-------*/
#import "SDWCardsListViewController.h"

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWCardsListPresenter.h"
#import "SDWCardsListInteractor.h"

/*-------Models-------*/

@implementation SDWCardsListWireframe

- (NSViewController *)cardsListUserInterfaceWithDelegate:(id<SDWCardsListModuleDelegate>)delegate {

    SDWCardsListViewController *cardsListViewController = [[SDWCardsListViewController alloc]initWithNibName:NSStringFromClass([SDWCardsListViewController class]) bundle:nil];

    SDWCardsListPresenter *presenter = [SDWCardsListPresenter new];
    presenter.userInterface = cardsListViewController;

    cardsListViewController.eventHandler = presenter;
    cardsListViewController.moduleDelegate = delegate;

    presenter.wireframe = self;

    SDWCardsListInteractor *interactor = [SDWCardsListInteractor new];
    interactor.output = presenter;
    presenter.listInteractor = interactor;

    return cardsListViewController;
}

@end
