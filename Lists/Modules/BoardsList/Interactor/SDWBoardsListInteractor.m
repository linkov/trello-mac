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
#import "SDWCoreDataManager.h"
#import "KZAsserts.h"

/*-------Models-------*/
#import "SDWBoardManaged.h"

@implementation SDWBoardsListInteractor


- (void)selectList:(SDWListManaged *)list {

    /* check inputs */
    //??

    [SDWCoreDataManager manager].currentAdminUser.selectedList = list;


    /* check outputs */
    NSAssert([SDWCoreDataManager manager].currentAdminUser.selectedList, @"should have list");


    //TODO: save?
}

- (void)findAllBoardsSortedBy:(SDWBoardsListSortType)sortType {
    [[AFTrelloAPIClient sharedClient] fetchBoardsAndListsWithCompletion:^(id object, NSError *error) {
        NSArray *boardsFromJSONasCoreDataObjects = [SDWMapper arrayOfObjectsOfClass:[SDWBoardManaged class] fromJSON:object];
        NSArray *sortedBoards = [self boardsSortedByType:sortType fromBoards:boardsFromJSONasCoreDataObjects];
        [self.output foundAllBoards:sortedBoards];

        //TODO: save?, set currentList for currentUser
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
