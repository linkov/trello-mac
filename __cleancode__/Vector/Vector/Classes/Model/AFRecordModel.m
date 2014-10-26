//
//  AFRecordModel.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "AFRecordPathManager.h"
#import "AFRecordModel.h"

@implementation AFRecordModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {

    self = [super init];
    if (self) {

        self.attributes = attributes;
        [self mapAttributesToProperties];
    }
    return self;
}

+ (void)findAll:(AFRecordCallback)block {

    NSString *path = [[AFRecordPathManager manager] concretePathForPathType:@"findAll" forModel:[self class]];

    [[AFTrelloAPIClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {



            Class cl = [self class];
            AFRecordModel *model = [[cl alloc] initWithAttributes:attributes];
            [mutablePosts addObject:model];
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

- (void)mapAttributesToProperties {}

@end
