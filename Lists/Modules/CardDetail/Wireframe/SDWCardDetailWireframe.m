//
//  SDWCardDetailWireframe.m
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardDetailWireframe.h"

/*-------View Controllers-------*/
#import "SDWCardDetailViewController.h"

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWCardDetailPresenter.h"
#import "SDWCardDetailInteractor.h"
#import "SDWCardDetailModuleDelegate.h"

/*-------Models-------*/

@implementation SDWCardDetailWireframe

- (NSViewController *)cardDetailUserInterfaceWithDelegate:(id<SDWCardDetailModuleDelegate>)delegate {
    SDWCardDetailViewController *viewController = [[SDWCardDetailViewController alloc]initWithNibName:NSStringFromClass([SDWCardDetailViewController class]) bundle:nil];

    SDWCardDetailPresenter *presenter = [SDWCardDetailPresenter new];
    presenter.userInterface = viewController;

    viewController.eventHandler = presenter;
    viewController.moduleDelegate = delegate;

    presenter.wireframe = self;

    SDWCardDetailInteractor *interactor = [SDWCardDetailInteractor new];
    interactor.output = presenter;
    presenter.listInteractor = interactor;

    return viewController;
}

@end
