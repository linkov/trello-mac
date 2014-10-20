//
//  Label.m
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "Label.h"

@implementation Label

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.color = [attributes valueForKeyPath:@"color"];
    self.name = [attributes valueForKeyPath:@"name"];


    return self;
}


@end
