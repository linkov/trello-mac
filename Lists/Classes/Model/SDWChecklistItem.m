//
//  SDWChecklistItem.m
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWChecklistItem.h"

@implementation SDWChecklistItem

- (void)mapAttributesToProperties {
    self.state = self.attributes[@"state"];
    self.itemID = self.attributes[@"id"];
    self.name = self.attributes[@"name"];

    NSNumber *pos = self.attributes[@"pos"];
    self.position = pos.integerValue;
}

@end
