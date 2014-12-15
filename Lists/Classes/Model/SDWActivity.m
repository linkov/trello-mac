//
//  SDWActivity.m
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "Utils.h"
#import "SDWActivity.h"

@implementation SDWActivity

- (void)mapAttributesToProperties {

    self.activityID = self.attributes[@"id"];
    self.content = self.attributes[@"data"][@"text"];
    self.memberInitials = self.attributes[@"memberCreator"][@"initials"];
    self.time = [Utils stringToDate:self.attributes[@"date"]];


//    if ([self.attributes valueForKeyPath:@"lists"]) {
//
//        NSMutableArray *children = [NSMutableArray new];
//        for (NSDictionary *att in [self.attributes valueForKeyPath:@"lists"]) {
//            SDWBoard *post = [[SDWBoard alloc] initWithAttributes:att];
//            [children addObject:post];
//        }
//
//        self.children = children;
//        self.isLeaf = NO;
//        self.fontSize = 14;
//    }
//    else {
//        self.isLeaf = YES;
//        self.fontSize = 11;
//    }
}

- (NSString *)timeString {

    return [Utils dateToString:self.time];
}

@end
