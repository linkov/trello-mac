//
//  AFRecordPathManager.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "AFRecordPathManager.h"
#import <objc/runtime.h>

@interface ModelPath : NSObject

@property (strong) NSString *modelClass;
@property (strong) NSDictionary *recordMethod_modelPath;

@end

@implementation ModelPath

@end

@implementation AFRecordPathManager

+ (instancetype)manager
{
    static AFRecordPathManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFRecordPathManager new];
        _manager.models = [NSMutableArray array];
    });

    return _manager;
}

// findAll for class SDWBoard is /fdkslfkd/fsfds
- (void)setAFRecordMethod:(NSString *)method forModel:(id)model toConcretePath:(NSString *)httpPath
{
    ModelPath *newObjectMapping = [ModelPath new];
    newObjectMapping.modelClass = NSStringFromClass([model class]);
    newObjectMapping.recordMethod_modelPath = @{
        method: httpPath
    };

    [self.models addObject:newObjectMapping];
}

- (NSString *)concretePathForPathType:(NSString *)pathType forModel:(id)model
{
    NSString *classString = NSStringFromClass([model class]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"modelClass == %@", classString];
    ModelPath *objectMapping = [self.models filteredArrayUsingPredicate:predicate].lastObject;
    NSString *httpPath = objectMapping.recordMethod_modelPath[pathType];

    return httpPath;
}

@end
