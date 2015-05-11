//
//  SDWCard.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWLabel.h"
#import "SDWCard.h"
#import "Utils.h"

@implementation SDWCard

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    NSNumber *pos = attributes[@"pos"];

    self.position = pos.integerValue;
    self.boardID = [attributes valueForKeyPath:@"idList"];
    self.cardID = [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"name"];
    self.members = [attributes valueForKeyPath:@"idMembers"];
    self.lastUpdate = [attributes valueForKeyPath:@"dateLastActivity"];
    self.cardDescription = attributes[@"desc"];
    self.commentsCount = [attributes[@"badges"][@"comments"] integerValue];

    NSUInteger checkItems = [attributes[@"badges"][@"checkItems"] integerValue];
    NSUInteger checkItemsChecked = [attributes[@"badges"][@"checkItemsChecked"] integerValue];

    if (checkItems - checkItemsChecked > 0) {
        self.hasOpenTodos = YES;
    } else {
        self.hasOpenTodos = NO;
    }

    self.dueDate = [Utils stringToDate:attributes[@"badges"][@"due"]];
    self.isSynced = YES;

    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSDictionary *labelDict in [attributes valueForKeyPath : @"labels"]) {
        SDWLabel *label = [[SDWLabel alloc]initWithAttributes:labelDict];
        [mutableArray addObject:label];
    }

    self.labels = mutableArray;

    return self;
}

@end
