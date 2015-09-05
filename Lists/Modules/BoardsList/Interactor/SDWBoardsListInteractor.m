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
#import "SDWCoreDataManager+Boards.h"
#import "KZAsserts.h"
#import "SDWLogger.h"
#import "NSObject+Logging.h"
#import "Constants.h"

/*-------Models-------*/
#import "SDWBoardManaged.h"

@implementation SDWBoardsListInteractor

- (BOOL)crownState {
    return ([[NSUserDefaults standardUserDefaults] boolForKey:SDWListsShouldUseCrownFilterKey] == YES);
}

- (SDWBoardManaged *)selectedBoard {

    return [SDWCoreDataManager manager].currentAdminUser.selectedList.board;
}

- (SDWListManaged *)selectedList {

    return [SDWCoreDataManager manager].currentAdminUser.selectedList;
}

- (void)selectList:(SDWListManaged *)list {
    /* check inputs */
    //??

    [SDWCoreDataManager manager].currentAdminUser.selectedList = list;

    /* check outputs */
    NSAssert([SDWCoreDataManager manager].currentAdminUser.selectedList, @"currentAdminUser.selectedList is nil");

    //TODO: save?
}

- (void)findAllBoardsSortedBy:(SDWBoardsListSortType)sortType {


    /* provide local data if available */
    NSArray *localBoards = [[SDWCoreDataManager manager] allBoards];
    if (localBoards.count) {
        NSArray *sortedBoards = [self boardsSortedByType:sortType fromBoards:localBoards];
        [self.output foundAllBoards:sortedBoards];
    }

    /* fetch remove data and update */
    [[AFTrelloAPIClient sharedClient] fetchBoardsAndListsWithCompletion:^(id object, NSError *error) {
        if (error) {
            [[SDWLogger sharedLogger] logError:[NSString stringWithFormat:@"%@: %@", self.classLogIdentifier, error.localizedDescription]];
            [self.output failedTofindAllBoardsWithError:error];
        } else {
            NSArray *boardsFromJSONasCoreDataObjects = [SDWMapper arrayOfObjectsOfClass:[SDWBoardManaged class] fromJSON:object];
            [[SDWCoreDataManager manager] save];

            NSArray *sortedBoards = [self boardsSortedByType:sortType fromBoards:boardsFromJSONasCoreDataObjects];

            if ([[NSUserDefaults standardUserDefaults] boolForKey:SDWListsShouldUseCrownFilterKey] == YES) {
                [[AFTrelloAPIClient sharedClient] fetchBoardsAndListsIDsWithCardsAssignedToCurrentUserWithCompletion:^(NSDictionary *objects, NSError *error) {
                        if (error) {
                            [[SDWLogger sharedLogger] logError:[NSString stringWithFormat:@"%@: %@", self.classLogIdentifier, error.localizedDescription]];
                            [self.output failedTofindAllBoardsWithError:error];
                        } else {
                            NSArray *crownFilteredBoardsAndLists = [self crownfilteredBoardsIDs:objects[@"crownBoardIDs"] andListIDs:objects[@"crownListIDs"] fromBoards:sortedBoards];
                            [self.output foundAllBoards:crownFilteredBoardsAndLists];
                        }
                    }];
            } else {
                [self.output foundAllBoards:sortedBoards];
            }
        }
    }];
}

- (NSArray *)crownfilteredBoardsIDs:(NSArray *)ids andListIDs:(NSArray *)lids fromBoards:(NSArray *)boardsUnfiltered {
    NSMutableArray *boards = [NSMutableArray array];

    for (SDWBoardManaged *board in boardsUnfiltered) {
        NSString *boardID = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", board.listsID]].firstObject;

        if (boardID) {
            NSMutableArray *lists = [NSMutableArray array];
            for (SDWListManaged *list in board.children) {
                NSString *listID = [lids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", list.listsID]].firstObject;

                if (listID) {
                    [lists addObject:list];
                }
            }
            [board addLists:[NSSet setWithArray:lists]];
            [boards addObject:board];
        }
    }
    return boards;
}

- (NSArray *)boardsSortedByType:(SDWBoardsListSortType)sortType fromBoards:(NSArray *)boardsUnsortedByStarred {
    NSSortDescriptor *sortDescriptor;

    if (sortType == SDWBoardsListSortTypeStarredFirst) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"isStarred" ascending:NO];
    } else if (sortType == SDWBoardsListSortTypeNone) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
    } else {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
    }


    NSSortDescriptor *updatedAtSort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
    NSArray *sortedArray = [boardsUnsortedByStarred sortedArrayUsingDescriptors:@[sortDescriptor,updatedAtSort]];
    return sortedArray;
}

- (NSArray *)boardsCrownFilteredFromBoards:(NSArray *)boards {
    return boards;
}

@end
