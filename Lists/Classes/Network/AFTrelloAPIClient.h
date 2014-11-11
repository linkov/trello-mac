//
//  AFTrelloAPIClient.h
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFTrelloAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
