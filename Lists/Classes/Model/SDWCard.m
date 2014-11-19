//
//  SDWCard.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWLabel.h"
#import "SDWCard.h"

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
    self.isSynced = YES;

    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSDictionary *labelDict in [attributes valueForKeyPath:@"labels"]) {

        SDWLabel *label = [[SDWLabel alloc]initWithAttributes:labelDict];
        [mutableArray addObject:label];
    }

    self.labels = mutableArray;
    
    
    return self;
}

@end
