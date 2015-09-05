//
//  SDWCoreDataManager.m
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCoreDataManager.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWLogger.h"
#import "NSObject+Logging.h"

/*-------Models-------*/
#import "SDWListManaged.h"
#import "SDWBoardManaged.h"

@interface SDWCoreDataManager ()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, readwrite) NSManagedObjectContext *privateContext;

@end

@implementation SDWCoreDataManager

+ (SDWCoreDataManager *)manager {
    static SDWCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SDWCoreDataManager alloc] init];
    });
    return manager;
}

- (void)setupCoreDataWithCompletion:(SDWEmptyBlock)completion {
    self.setupCompletion = completion;
    [self initializeCoreData];
}

- (void)initializeCoreData {
    if ([self managedObjectContext]) {
        return;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //ZAssert(mom, @"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    ZAssert(coordinator, @"Failed to initialize coordinator");

    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];

    self.privateContext.persistentStoreCoordinator = coordinator;
    self.managedObjectContext.parentContext = self.privateContext;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self privateContext] persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode": @"DELETE" };

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"Model.sqlite"];

        NSError *error = nil;
        ZAssert([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error], @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);

        if (!self.setupCompletion) {
            return;
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
                self.setupCompletion();
            });
    });
}

- (void)setupMockAdminUser {
    if ([self currentAdminUser]) {
        return;
    }

    SDWUserManaged *admin = [SDWUserManaged insertInManagedObjectContext:self.managedObjectContext];
    admin.isAdmin = @(YES);
}

- (SDWUserManaged *)currentAdminUser {
    SDWUserManaged *admin = [self fetchEntityWithName:[SDWUserManaged entityName] andPredicate:[NSPredicate predicateWithFormat:@"isAdmin == %@", @(YES)]];

    return admin;
}

- (NSArray *)fetchAllEntitiesWithName:(NSString *)entityName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [SDWLog logError:[NSString stringWithFormat:@"%@ Failed to fetch all entities with name %@, %@", self.classLogIdentifier, entityName, error]];
        return nil;
    }

    return fetchedObjects;
}

- (id)fetchEntityWithName:(NSString *)entityName andID:(NSString *)entityID {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listsID == %@", entityID];
    fetchRequest.predicate = predicate;

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [SDWLog logError:[NSString stringWithFormat:@"%@ Failed to fetch entity with ID %@, %@", self.classLogIdentifier, entityID, error]];

        return nil;
    }
    return [fetchedObjects firstObject];
}

- (id)fetchEntityWithName:(NSString *)entityName andPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;

    fetchRequest.predicate = predicate;

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [SDWLog logError:[NSString stringWithFormat:@"%@ Failed to fetch entity with predicate %@, %@", self.classLogIdentifier, predicate, error]];
        return nil;
    }
    return [fetchedObjects firstObject];
}

- (void)deleteAllEntitiesWithName:(NSString *)entName {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:entName inManagedObjectContext:context]];
    NSArray *result = [context executeFetchRequest:fetch error:nil];
    for (id basket in result) {
        [context deleteObject:basket];
    }
    [self save];
}

- (void)save {
    [[self managedObjectContext] performBlockAndWait:^{ // the save as calling save without block but guarantees that it's run on the thread that the MOC is in
        NSError *error = nil;

        ZAssert([[self managedObjectContext] save:&error], @"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);

        [[self privateContext] performBlock:^{
                NSError *privateError = nil;
                ZAssert([[self privateContext] save:&privateError], @"Error saving private context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
            }];
    }];
}

@end
