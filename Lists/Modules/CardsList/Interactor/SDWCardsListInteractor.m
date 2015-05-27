//
//  SDWCardsListInteractor.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListInteractor.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "AFTrelloAPIClient.h"
#import "SDWCoreDataManager.h"
#import "SDWMapper.h"
#import "SDWLogger.h"
#import "NSObject+Logging.h"

/*-------Models-------*/
#import "SDWCardManaged.h"
#import "SDWListManaged.h"

@implementation SDWCardsListInteractor

- (void)findAllCardsForCurrentListSortedBy:(SDWCardsListSortType)sortType {

    [[AFTrelloAPIClient sharedClient] fetchCardsForListID:[self currentList].listsID WithCompletion:^(id object, NSError *error) {
        if (error) {
            [SDWLog logError:[NSString stringWithFormat:@"%@ Failed to fetch cards for list, %@ ", self.classLogIdentifier, error.localizedDescription]];
            return;
        }

        NSArray *cardsFromJSONasCoreDataObjects = [SDWMapper arrayOfObjectsOfClass:[SDWCardManaged class] fromJSON:object];
        [[self currentList].cardsSet addObjectsFromArray:cardsFromJSONasCoreDataObjects];
        // save ?

        [self.output foundAllCards:[[self currentList].cards allObjects]];
    }];
}

- (NSString *)currentListTitle {
    return [self currentList].name;
}

- (SDWListManaged *)currentList  {

    //TODO:
    return nil;
}

@end
