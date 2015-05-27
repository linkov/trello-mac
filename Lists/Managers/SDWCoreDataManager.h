//
//  SDWCoreDataManager.h
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
#define ALog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while (0)

@import CoreData;
#import <Foundation/Foundation.h>

typedef void (^SDWEmptyBlock)();

@interface SDWCoreDataManager : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly) NSManagedObjectContext *privateContext;
@property (copy) SDWEmptyBlock setupCompletion;

+ (instancetype)manager;
- (void)        setupCoreDataWithCompletion:(SDWEmptyBlock)completion;

- (void)add;

- (NSArray *)fetchAllEntitiesWithName:(NSString *)entityName;
- (id)fetchEntityWithName:(NSString *)entityName andID:(NSString *)entityID;
- (void)deleteAllEntitiesWithName:(NSString *)entName;

@end
