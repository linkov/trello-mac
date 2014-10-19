//
//  Board.h
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Board : NSObject

@property (nonatomic, strong) NSString *boardID;
@property (nonatomic, strong) NSString *name;

@property (strong) NSArray *children;
@property BOOL isLeaf;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)fetchBoardsWithBlock:(void (^)(NSArray *boards, NSError *error))block;

@end
