//
//  AFTrelloAPIClient.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFTrelloAPIClient.h"
#import "AFURLRequestSerialization.h"
#import "SDWAppSettings.h"

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

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@",SharedSettings.appToken,SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    return [super GET:paramsStr parameters:parameters success:success failure:failure];
}

@end
