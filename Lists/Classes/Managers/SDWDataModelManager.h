//
//  SDWDataModelManager.h
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

@import Foundation;
@import CoreData;

typedef void (^CNIIDErrorBlock)(id _Nullable object, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface SDWDataModelManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SDWDataModelManager *)manager;

- (instancetype)initWithDBName:(NSString *)databaseName;

- (void)resetPersistentStore;
- (void)saveContext;
- (void)saveToDisk;

- (void)deleteAllEntitiesWithName:(NSString *)entityName
                        inContext:(NSManagedObjectContext *)context;

- (id)fetchEntityForName:(NSString *)entityName
            withUID:(NSString *)conichiID
               inContext:(NSManagedObjectContext *)context;

- (id)fetchEntityForName:(NSString *)entityName
            withTrelloID:(NSString *)conichiID
               inContext:(NSManagedObjectContext *)context;

- (id)fetchEntityForName:(NSString *)entityName
           withPredicate:(nullable NSPredicate *)predicate
               inContext:(NSManagedObjectContext *)context;

- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName
                       withPredicate:(nullable NSPredicate *)predicate
                           inContext:(NSManagedObjectContext *)context;

- (void)fetchAllEntitiesForName:(NSString *)entityName
                  withPredicate:(nullable NSPredicate *)predicate
                      inContext:(NSManagedObjectContext *)context
                 withCompletion:(CNIIDErrorBlock)completion;

- (void)removeAllEntitiesForName:(NSString *)entityName
                   withPredicate:(nullable NSPredicate *)predicate
                       inContext:(NSManagedObjectContext *)context;

- (id)fetchSingleEntityForName:(NSString *)entityName
               sortDescriptors:(nullable NSArray <NSSortDescriptor *> *)sortDescriptors
                 withPredicate:(nullable NSPredicate *)predicate
                     inContext:(NSManagedObjectContext *)context;

@end


NS_ASSUME_NONNULL_END
