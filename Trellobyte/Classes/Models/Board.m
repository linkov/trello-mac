//
//  Board.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "Board.h"
#import "AFTrelloAPIClient.h"

@implementation Board

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.boardID = [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"name"];

    if ([attributes valueForKeyPath:@"lists"]) {

        NSMutableArray *chieldren = [NSMutableArray new];
        for (NSDictionary *att in [attributes valueForKeyPath:@"lists"]) {
            Board *post = [[Board alloc] initWithAttributes:att];
            [chieldren addObject:post];
        }

        self.children = chieldren;
        self.isLeaf = NO;
    }
    else {
        self.isLeaf = YES;
    }


    return self;
}

#pragma mark -

+ (NSURLSessionDataTask *)fetchBoardsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    return [[AFTrelloAPIClient sharedClient] GET:@"member/alexlink2/boards?key=6825229a76db5b6a5737eb97e9c4a923&token=19b58b73689c960cff5a07ceb0d9e3f848207e53059e892af1cadcbeb0174592&fields=name&lists=open" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            Board *post = [[Board alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }

        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}


@end
