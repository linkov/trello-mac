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

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    // logging
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];

    CLS_LOG(@"%@ -%@ GET %@%@", [array objectAtIndex:3], [array objectAtIndex:4], AFAppTrelloAPIBaseURLString, paramsStr);

    return [super GET:paramsStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    // logging
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    CLS_LOG(@"%@ -%@ PUT %@%@", [array objectAtIndex:3], [array objectAtIndex:4], AFAppTrelloAPIBaseURLString, paramsStr);

    return [super PUT:paramsStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    // logging
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    CLS_LOG(@"%@ -%@ POST %@%@", [array objectAtIndex:3], [array objectAtIndex:4], AFAppTrelloAPIBaseURLString, paramsStr);

    return [super POST:paramsStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *params = [NSString stringWithFormat:@"&key=%@&token=%@", SharedSettings.appToken, SharedSettings.userToken];
    NSString *paramsStr = [URLString stringByAppendingString:params];

    // logging
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    CLS_LOG(@"%@ -%@ DELETE %@%@", [array objectAtIndex:3], [array objectAtIndex:4], AFAppTrelloAPIBaseURLString, paramsStr);

    return [super DELETE:paramsStr parameters:parameters success:success failure:failure];
}

@end
