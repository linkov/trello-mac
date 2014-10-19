//
//  Card.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "AFTrelloAPIClient.h"
#import "Card.h"

@implementation Card

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.cardID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.name = [attributes valueForKeyPath:@"name"];
    self.members = [attributes valueForKeyPath:@"idMembers"];


    return self;
}

#pragma mark -

+ (NSURLSessionDataTask *)fetchCardsForListID:(NSString *)listID withBlock:(void (^)(NSArray *posts, NSError *error))block {

    NSString *URL = [NSString stringWithFormat:@"lists/%@",listID];
    NSString *URL2 = [NSString stringWithFormat:@"?key=6825229a76db5b6a5737eb97e9c4a923&token=19b58b73689c960cff5a07ceb0d9e3f848207e53059e892af1cadcbeb0174592&lists=open&cards=open&card_fields=name,pos,idMembers"];

    NSString *URLF = [NSString stringWithFormat:@"%@%@",URL,URL2];

    return [[AFTrelloAPIClient sharedClient] GET:URLF parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"cards"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            Card *post = [[Card alloc] initWithAttributes:attributes];
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
