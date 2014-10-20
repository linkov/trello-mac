//
//  Card.h
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property NSUInteger cardID;
@property (nonatomic, strong) NSString *name;
@property NSUInteger pos;
@property NSArray *members;
@property (nonatomic,strong) NSString *owner;
@property (strong) NSArray *labels;

+ (NSURLSessionDataTask *)fetchCardsForListID:(NSString *)listID withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
