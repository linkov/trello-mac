//
//  SDWBoardsListInteractor.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWBoardsListInteractor.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "AFTrelloAPIClient.h"
#import "SDWMapper.h"

/*-------Models-------*/
#import "SDWBoardManaged.h"

@implementation SDWBoardsListInteractor

- (void)findAllBoardsSortedBy:(SDWBoardsListSortType)sortType {
    [[AFTrelloAPIClient sharedClient] fetchBoardsAndListsWithCompletion:^(id object, NSError *error) {
        NSArray *boardsFromJSONasCoreDataObjects = [SDWMapper arrayOfObjectsOfClass:[SDWBoardManaged class] fromJSON:object];
        NSArray *sortedBoards = [self boardsSortedByType:sortType fromBoards:boardsFromJSONasCoreDataObjects];
        [self.output foundAllBoards:sortedBoards];
    }];
}

- (NSArray *)boardsSortedByType:(SDWBoardsListSortType)sortType fromBoards:(NSArray *)boardsUnsortedByStarred {
    NSSortDescriptor *sortDescriptor;

    if (sortType == SDWBoardsListSortTypeStarredFirst) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"starred" ascending:YES];
    } else if (sortType == SDWBoardsListSortTypeNone) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
    } else {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
    }

    NSArray *sortedArray = [boardsUnsortedByStarred sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

@end
