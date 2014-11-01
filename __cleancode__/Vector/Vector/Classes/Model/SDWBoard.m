//
//  SDWBoard.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWBoard.h"

@implementation SDWBoard

- (void)mapAttributesToProperties {

    self.boardID = self.attributes[@"id"];
    self.name = self.attributes[@"name"];

    if ([self.attributes valueForKeyPath:@"lists"]) {

        NSMutableArray *children = [NSMutableArray new];
        for (NSDictionary *att in [self.attributes valueForKeyPath:@"lists"]) {
            SDWBoard *post = [[SDWBoard alloc] initWithAttributes:att];
            [children addObject:post];
        }

        self.children = children;
        self.isLeaf = NO;
        self.fontSize = 14;
    }
    else {
        self.isLeaf = YES;
        self.fontSize = 11;
    }
}


@end
