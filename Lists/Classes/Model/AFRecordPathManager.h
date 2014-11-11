//
//  AFRecordPathManager.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class AFRecordModel;
#import <Foundation/Foundation.h>

@interface AFRecordPathManager : NSObject

@property (strong) NSMutableArray *models;
@property (strong) NSMutableDictionary *path_pathtype;

+ (instancetype)manager;

- (void)setAFRecordMethod:(NSString *)method
                 forModel:(id)model
           toConcretePath:(NSString *)httpPath;

- (NSString *)concretePathForPathType:(NSString *)pathType
                             forModel:(id)model;

@end
