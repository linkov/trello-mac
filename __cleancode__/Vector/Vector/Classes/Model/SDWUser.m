//
//  SDWUser.m
//  Vector
//
//  Created by alex on 11/2/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWUser.h"

@implementation SDWUser

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.userID = [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"fullName"];

    return self;
}


@end
