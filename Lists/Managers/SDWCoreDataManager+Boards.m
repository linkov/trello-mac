//
//  SDWCoreDataManager+Boards.m
//  Lists
//
//  Created by alex on 7/26/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCoreDataManager+Boards.h"
#import "SDWBoardManaged.h"

@implementation SDWCoreDataManager (Boards)

- (NSArray *)allBoards {

    return  [self fetchAllEntitiesWithName:[SDWBoardManaged entityName]];
}

@end
