//
//  SDWLabel.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWLabel.h"

@implementation SDWLabel

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.color = [attributes valueForKeyPath:@"color"];
    self.name = [attributes valueForKeyPath:@"name"];

    return self;
}

@end
