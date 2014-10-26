//
//  AFTrelloAPIClient.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFTrelloAPIClient.h"

static NSString * const AFAppTrelloAPIBaseURLString = @"https://api.trello.com/1/";

@implementation AFTrelloAPIClient

+ (instancetype)sharedClient {
    static AFTrelloAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFTrelloAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppTrelloAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });

    return _sharedClient;
}

@end
