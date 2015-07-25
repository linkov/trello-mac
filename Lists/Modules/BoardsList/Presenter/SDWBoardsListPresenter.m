//
//  SDWBoardsListPresenter.m
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWBoardsListPresenter.h"

@implementation SDWBoardsListPresenter

#pragma mark - SDWBoardsListModuleInterface

- (void)updateUserInterface {
    [self.listInteractor findAllBoardsSortedBy:SDWBoardsListSortTypeStarredFirst];
    [self.userInterface showLoadingIndicator];
    BOOL crownIsOn = [self.listInteractor crownState];

    [self.userInterface setCrown:crownIsOn];
}

- (void)selectList:(SDWListManaged *)list {
    [self.listInteractor selectList:list];
}

#pragma mark - SDWBoardsListInteractorOutput

- (void)failedTofindAllBoardsWithError:(NSError *)error {
    [self.userInterface showNoContentMessage];
}

- (void)foundAllBoards:(NSArray *)allBoards {
    [self.userInterface dismissLoadingIndicator];

    if ([allBoards count] == 0) {
        [self.userInterface showNoContentMessage];
    } else {
        [self.userInterface showContentWithItems:allBoards];
    }
}

@end
