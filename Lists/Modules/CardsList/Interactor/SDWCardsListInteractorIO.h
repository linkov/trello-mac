//
//  SDWCardsListInteractorIO.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWTypesAndEnums.h"

@protocol SDWCardsListInteractorInput <NSObject>
- (void)findAllCardsForCurrentListSortedBy:(SDWCardsListSortType)sortType;
- (NSString *)currentListTitle;
@end


@protocol SDWCardsListInteractorOutput <NSObject>

- (void)foundAllCards:(NSArray *)allCards;

@end
