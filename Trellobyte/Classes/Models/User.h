//
//  User.h
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;

+ (NSURLSessionDataTask *)fetchUsersForBoardID:(NSString *)boardID WithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
