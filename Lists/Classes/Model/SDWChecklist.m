//
//  SDWChecklist.m
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWChecklist.h"
#import "SDWChecklistItem.h"

@implementation SDWChecklist

- (void)mapAttributesToProperties
{
    self.listBoardID = self.attributes[@"idBoard"];
    self.listCardID = self.attributes[@"idCard"];
    self.listID = self.attributes[@"id"];
    self.name = self.attributes[@"name"];

    NSNumber *pos = self.attributes[@"pos"];
    self.position = pos.integerValue;

    if ([self.attributes valueForKeyPath:@"checkItems"]) {
        NSMutableArray *children = [NSMutableArray new];
        for (NSDictionary *att in [self.attributes valueForKeyPath : @"checkItems"]) {
            SDWChecklistItem *post = [[SDWChecklistItem alloc] initWithAttributes:att];
            post.listID = self.listID;
            post.listName = self.name;
            [children addObject:post];
        }

        self.items = children;
    }
}

@end
