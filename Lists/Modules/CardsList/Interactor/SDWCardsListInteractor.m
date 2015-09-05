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
    if (![self currentList]) {
        return;
    }

    /* provide local data if available */
    NSArray *localCards = [[self currentList].cards allObjects];
    if (localCards.count) {

        [self.output foundAllCards:localCards];
    }

    /* fetch remove data and update */
    [[AFTrelloAPIClient sharedClient] fetchCardsForListID:[self currentList].listsID WithCompletion:^(id object, NSError *error) {
        if (error) {
            [SDWLog logError:[NSString stringWithFormat:@"%@ Failed to fetch cards for list, %@ ", self.classLogIdentifier, error.localizedDescription]];
            return;
        }

        NSArray *cardsFromJSONasCoreDataObjects = [SDWMapper arrayOfObjectsOfClass:[SDWCardManaged class] fromJSON:object];
        [[self currentList].cardsSet addObjectsFromArray:cardsFromJSONasCoreDataObjects];


        [[SDWCoreDataManager manager] save];

        [self.output foundAllCards:[[self currentList].cards allObjects]];
    }];
}

- (void)moveCardFromPosition:(NSUInteger)from toPosition:(NSUInteger)to {

}

- (NSString *)currentListTitle {
    return [self currentList].name ? : @"No selection";
}

- (SDWListManaged *)currentList  {
    return [SDWCoreDataManager manager].currentAdminUser.selectedList;
}

@end
