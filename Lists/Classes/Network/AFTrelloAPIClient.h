//
//  AFTrelloAPIClient.h
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWTypesAndEnums.h"
#import "AFHTTPSessionManager.h"

@interface AFTrelloAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)fetchBoardsAndListsIDsWithCardsAssignedToCurrentUserWithCompletion:(SDWDataErrorBlock)block;
- (void)fetchBoardsAndListsWithCompletion:(SDWDataErrorBlock)block;
- (void)fetchCardsForListID:(NSString *)listID WithCompletion:(SDWDataErrorBlock)block;

@end
