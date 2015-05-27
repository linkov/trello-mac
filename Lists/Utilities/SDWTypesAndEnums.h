//
//  CNITypesAndEnums.h
//  ios-merchant
//
//  Created by Alex on 18/03/2015.
//  Copyright (c) 2015 Conichi. All rights reserved.
//

@import Foundation;

/** Contains Typedefs and enums */

#pragma mark - Enums

typedef NS_ENUM (NSInteger, SDWBoardsListSortType) {
    SDWBoardsListSortTypeStarredFirst,
    SDWBoardsListSortTypeNone
};

typedef NS_ENUM (NSInteger, SDWCardsListSortType) {
    SDWCardsListSortTypePosition,
    SDWCardsListSortTypeNone
};

#pragma mark - Blocks

typedef void (^SDWEmptyBlock)();
typedef void (^SDWDataErrorBlock)(id object, NSError *error);