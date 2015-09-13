//
//  SDWCardsListPresenter.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListPresenter.h"

@implementation SDWCardsListPresenter

#pragma mark - SDWCardsListModuleInterface

- (void)updateUserInterface {
    [self showCardsForCurrentList];
}

- (void)showCardsForCurrentList {
    NSString *listTitle = [[self.listInteractor currentListTitle] capitalizedString];
    [self.userInterface showListTitle:listTitle];
    [self.listInteractor findAllCardsForCurrentListSortedBy:SDWCardsListSortTypeNone];
}

- (void)reloadCards {
}

#pragma mark - SDWCardsListInteractorOutput

- (void)didMoveCard {
}

- (void)foundAllCards:(NSArray *)allCards {
    if ([allCards count] == 0) {
        [self.userInterface showNoContentMessage];
    } else {
        [self.userInterface showContentWithItems:allCards];
    }
}

@end
