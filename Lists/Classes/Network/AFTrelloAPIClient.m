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
#import "SDWMacros.h"
#import "KZAsserts.h"

static NSString *const AFAppTrelloAPIBaseURLString = @"https://api.trello.com/1/";

@implementation AFTrelloAPIClient

+ (instancetype)sharedClient {
    static AFTrelloAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFTrelloAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppTrelloAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObject:@"POST"];
    });

    return _sharedClient;
}

- (void)fetchBoardsAndListsWithCompletion:(SDWDataErrorBlock)block {
    [[AFTrelloAPIClient sharedClient] GET:@"members/me/boards?filter=open&fields=name,starred&lists=open"
                               parameters:nil
                                  success:^(NSURLSessionDataTask *__unused task, id JSON) {
        if (![JSON isKindOfClass:[NSArray class]]) {
            NSLog(@"JSON is not array");
            // handle error
            return;
        }

        SDWPerformBlock(block, [NSArray arrayWithArray:JSON], nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        SDWPerformBlock(block, nil, error);
    }];
}

- (void)fetchCardsForListID:(NSString *)listID WithCompletion:(SDWDataErrorBlock)block {
    NSString *URLPart1 = [NSString stringWithFormat:@"lists/%@/cards", listID];
    NSString *URLPart2 = [NSString stringWithFormat:@"?lists=open&cards=open"];
    NSString *URL = [NSString stringWithFormat:@"%@%@", URLPart1, URLPart2];

    [[AFTrelloAPIClient sharedClient] GET:URL
                               parameters:nil
                                  success:^(NSURLSessionDataTask *__unused task, id JSON) {
        if (![JSON isKindOfClass:[NSArray class]]) {
            NSLog(@"JSON is not array");
            // handle error
            return;
        }

        SDWPerformBlock(block, [NSArray arrayWithArray:JSON], nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        SDWPerformBlock(block, nil, error);
    }];
}

- (void)fetchBoardsAndListsIDsWithCardsAssignedToCurrentUserWithCompletion:(SDWDataErrorBlock)block {
    [[AFTrelloAPIClient sharedClient] GET:@"members/me?fields=none&cards=all&card_fields=idBoard,idList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SharedSettings.userID = responseObject[@"id"];
        NSArray *crownBoardIDs = [responseObject[@"cards"] valueForKeyPath:@"idBoard"];
        NSArray *crownListIDs = [responseObject[@"cards"] valueForKeyPath:@"idList"];

        AssertTrueOr(crownBoardIDs, SDWPerformBlock(block, nil, nil));
        AssertTrueOr(crownListIDs, SDWPerformBlock(block, nil, nil));

        SDWPerformBlock(block, @{@"crownBoardIDs": crownBoardIDs, @"crownListIDs": crownListIDs}, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SDWPerformBlock(block, nil, error);
    }];
}

// remove

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    return [super GET:paramsStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    return [super PUT:paramsStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    return [super POST:paramsStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    return [super DELETE:paramsStr parameters:parameters success:success failure:failure];
}

@end
