//
//  NSObject+Logging.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "NSObject+Logging.h"

@implementation NSObject (Logging)

- (NSString *)classLogIdentifier {
    return [NSString stringWithFormat:@"com.sdwr.lists.%@", NSStringFromClass([self class])];
}

@end
