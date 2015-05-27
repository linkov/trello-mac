//
//  SDWBoardsListInteractorIO.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWTypesAndEnums.h"

@protocol SDWBoardsListInteractorInput <NSObject>
- (void)findAllBoardsSortedBy:(SDWBoardsListSortType)sortType;
@end

@protocol SDWBoardsListInteractorOutput <NSObject>

- (void)foundAllBoards:(NSArray *)allBoards;

@end
