//
//  SDWBoardsListPresenter.m
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWBoardsListPresenter.h"
#import "SDWBoardManaged.h"

@implementation SDWBoardsListPresenter

#pragma mark - SDWBoardsListModuleInterface

- (void)updateUserInterface {
    [self.listInteractor findAllBoardsSortedBy:SDWBoardsListSortTypeStarredFirst];
    [self.userInterface showLoadingIndicator];
    BOOL crownIsOn = [self.listInteractor crownState];
    id selectedBoard = (id<SDWSourceListItem>)[self.listInteractor selectedBoard];

    if (selectedBoard) {
        [self.userInterface expandToSelectedList:selectedBoard];
    }

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

    for (SDWBoardManaged *board in allBoards) {
        NSLog(@"%@ - starred: %i", board.name, [board.isStarred boolValue]);
    }

    if ([allBoards count] == 0) {
        [self.userInterface showNoContentMessage];
    } else {
        [self.userInterface showContentWithItems:allBoards];
    }
}

@end
