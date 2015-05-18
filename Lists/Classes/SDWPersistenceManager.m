//
//  SDWCoreDataManager.m
//  Lists
//
//  Created by alex on 5/14/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWPersistenceManager.h"
#import "KZAsserts.h"
#import "SDWLogger.h"

NSString *const SDWPersistenceManagerClassLogIdentifier = @"com.sdwr.trello-mac.SDWPersistenceManager";

@interface SDWPersistenceManager ()

//If we need to display something to the user, we use this context. If the user is going to edit something, we use this context. No exceptions.
@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;

// avoids locking the UI on save
@property (strong) NSManagedObjectContext *privateContext;

@property (copy) SDWEmptyBlock setupCompletion;

@end

@implementation SDWPersistenceManager

+ (SDWPersistenceManager *)manager {
    static SDWPersistenceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SDWPersistenceManager alloc] init];
    });
    return manager;
}

- (id)setupCoreDataWithCompletion:(SDWEmptyBlock)completion {
    [self initializeCoreData];
}

- (void)initializeCoreData {
    if ([self managedObjectContext]) {
        return;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    ZAssert(mom, @"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));

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

- (void)save {
    if (![[self privateContext] hasChanges] && ![[self managedObjectContext] hasChanges]) {
        return;
    }

    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;

        ZAssert([[self managedObjectContext] save:&error], @"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);

        [[self privateContext] performBlock:^{
                NSError *privateError = nil;
                ZAssert([[self privateContext] save:&privateError], @"Error saving private context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
            }];
    }];
}

- (id)fetchEntityName:(NSString *)entityName withListsID:(NSString *)listsID {
    if (!entityName || !listsID) {
        return nil;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listsID == %@", conichiID];
    fetchRequest.predicate = predicate;

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        SDWLogError(@"%@ Failed to fetch %@ with listsID = %@ in context %@. %@", SDWPersistenceManagerClassLogIdentifier, entityName, listsID, context, [error localizedDescription]);
        return nil;
    }
    return [fetchedObjects firstObject];
}

@end
