//
//  User.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "AFTrelloAPIClient.h"
#import "User.h"

@implementation User

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.userID = [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"fullName"];


    return self;
}

#pragma mark -

+ (NSURLSessionDataTask *)fetchUsersForBoardID:(NSString *)boardID WithBlock:(void (^)(NSArray *posts, NSError *error))block {

    NSString *URL = [NSString stringWithFormat:@"boards/%@",boardID];
    NSString *URL2 = [NSString stringWithFormat:@"/members?key=6825229a76db5b6a5737eb97e9c4a923&token=19b58b73689c960cff5a07ceb0d9e3f848207e53059e892af1cadcbeb0174592"];

    NSString *URLF = [NSString stringWithFormat:@"%@%@",URL,URL2];

    return [[AFTrelloAPIClient sharedClient] GET:URLF parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            User *post = [[User alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }

        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {

        NSLog(@"%@",error.localizedDescription);
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
