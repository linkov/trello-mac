//
//  SDWDataModelManager.m
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWDataModelManager.h"
#import "SDWMacros.h"

NSString *const CNIDataModelManagerClassLogIdentifier = @"com.conichi.ios-merchant.CNIDataModelManager";

@interface SDWDataModelManager ()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, copy) NSString *databaseName;

@end

@implementation SDWDataModelManager

+ (SDWDataModelManager *)manager {
    static SDWDataModelManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SDWDataModelManager alloc] init];
    });
    return manager;
}

- (id)init {
    return [self initWithDBName:@"listsmodel"];
}

- (id)initWithDBName:(NSString *)databaseName {
    NSParameterAssert(databaseName);
    self = [super init];
    if (self) {
        self.databaseName = databaseName;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleManagedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
        [self setUpCoreDataStack];
    }
    return self;
}

- (void)handleManagedObjectContextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *managedObjectContext = [notification object];
    if (managedObjectContext != self.managedObjectContext) {
        // Fix/workaround from http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different/3927811#3927811
        for (NSManagedObject *object in [[notification userInfo] objectForKey : NSUpdatedObjectsKey]) {
            [[self.managedObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
        }
        
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }
}

- (void)deleteAllEntitiesWithName:(NSString *)entityName inContext:(NSManagedObjectContext *)context {
    
    [context performBlockAndWait:^{

        NSFetchRequest          *fetchRequest = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        
        [context executeRequest:deleteRequest error:nil];
        
    }];
}


#pragma mark - Fecth CoreData Entities



- (id)fetchSingleEntityForName:(NSString *)entityName
               sortDescriptors:(nullable NSArray <NSSortDescriptor *> *)sortDescriptors
                 withPredicate:(nullable NSPredicate *)predicate
                     inContext:(NSManagedObjectContext *)context {
    if (!context || !entityName) {
        return nil;
    }
    
    __block id fetchedEntity;
    
    [context performBlockAndWait:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        fetchRequest.fetchLimit = 1;
        fetchRequest.sortDescriptors = sortDescriptors;
        fetchRequest.predicate = predicate;
        results = [context executeFetchRequest:fetchRequest error:&error];
        if (error || !results.count) {
            fetchedEntity = nil;
        } else {
            fetchedEntity = results.lastObject;
        }
    }];
    
    if (fetchedEntity) {
        return fetchedEntity;
    }
    return nil;
}


- (void)fetchEntityForName:(NSString *)entityName
              withUID:(NSString *)conichiID
                 inContext:(NSManagedObjectContext *)context
            withCompletion:(void (^)(id fetchedEntity, NSError *))completion {
    if (!context || !entityName || !conichiID) {
        return;
    }
    
    [context performBlock:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSPredicate                     *predicate = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        predicate = [NSPredicate predicateWithFormat:@"uniqueIdentifier == %@", conichiID];
        fetchRequest.predicate = predicate;
        
        results = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            completion(nil, error);
        } else {
            completion(results.firstObject, nil);
        }
    }];
}

- (id)fetchEntityForName:(NSString *)entityName
            withUID:(NSString *)conichiID
               inContext:(NSManagedObjectContext *)context {
    if (!context || !entityName || !conichiID) {
        return nil;
    }
    
    __block id fetchedEntity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueIdentifier == %@", conichiID];
    fetchedEntity = [self fetchEntityForName:entityName withPredicate:predicate inContext:context];
    
    return fetchedEntity;
}


- (void)fetchEntityForName:(NSString *)entityName
             withTrelloID:(NSString *)conichiID
                 inContext:(NSManagedObjectContext *)context
            withCompletion:(void (^)(id fetchedEntity, NSError *))completion {
    if (!context || !entityName || !conichiID) {
        return;
    }
    
    [context performBlock:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSPredicate                     *predicate = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        predicate = [NSPredicate predicateWithFormat:@"trelloID == %@", conichiID];
        fetchRequest.predicate = predicate;
        
        results = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            completion(nil, error);
        } else {
            completion(results.firstObject, nil);
        }
    }];
}

- (id)fetchEntityForName:(NSString *)entityName
           withTrelloID:(NSString *)conichiID
               inContext:(NSManagedObjectContext *)context {
    if (!context || !entityName || !conichiID) {
        return nil;
    }
    
    __block id fetchedEntity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trelloID == %@", conichiID];
    fetchedEntity = [self fetchEntityForName:entityName withPredicate:predicate inContext:context];
    
    return fetchedEntity;
}

- (id)fetchEntityForName:(NSString *)entityName
           withPredicate:(NSPredicate *)predicate
               inContext:(NSManagedObjectContext *)context {
    if (!context || !entityName || !predicate) {
        return nil;
    }
    
    __block id fetchedEntity;
    
    [context performBlockAndWait:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        fetchRequest.predicate = predicate;
        
        results = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            fetchedEntity = nil;
        } else {
            fetchedEntity = results.firstObject;
        }
    }];
    
    return fetchedEntity;
}

- (id)fetchAllEntitiesForName:(NSString *)entityName
                withPredicate:(NSPredicate *)predicate
                    inContext:(NSManagedObjectContext *)context {
    __block NSArray *fetchedEntities;
    
    [context performBlockAndWait:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        fetchRequest.predicate = predicate;
        
        results = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            fetchedEntities = nil;
        } else {
            fetchedEntities = [results copy];
        }
    }];
    
    return fetchedEntities;
}

- (void)fetchAllEntitiesForName:(NSString *)entityName
                  withPredicate:(NSPredicate *)predicate
                      inContext:(NSManagedObjectContext *)context
                 withCompletion:(CNIIDErrorBlock)completion {
    [context performBlock:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        fetchRequest.predicate = predicate;
        
        results = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            SDWPerformBlock(completion, nil, error);
        } else {
            SDWPerformBlock(completion, results, nil);
        }
    }];
}

- (void)removeAllEntitiesForName:(NSString *)entityName
                   withPredicate:(nullable NSPredicate *)predicate
                       inContext:(NSManagedObjectContext *)context {
    [context performBlockAndWait:^{
        NSError                         *error = nil;
        NSArray                         *results = nil;
        NSFetchRequest          *fetchRequest = nil;
        NSEntityDescription     *entity = nil;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        fetchRequest.predicate = predicate;
        
        results = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject * object in results) {
            [context deleteObject:object];
        }
    }];
}

#pragma mark - CoreData stack

- (void)resetPersistentStore {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
    }];
    
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        [self.backgroundManagedObjectContext reset];
    }];
    
    NSError *localError;
    for (NSPersistentStore *store in self.persistentStoreCoordinator.persistentStores) {
        NSURL *URL = [self.persistentStoreCoordinator URLForPersistentStore:store];
        BOOL success = [self.persistentStoreCoordinator removePersistentStore:store error:&localError];
        if (success) {
            if ([URL isFileURL]) {
                if (![[NSFileManager defaultManager] removeItemAtURL:URL error:&localError]) {
//                    CNILogError(@"Failed to remove persistent store at URL %@: %@", URL, localError);
                    return;
                }
            } else {
//                CNILogInfo(@"Skipped removal of persistent store file: URL for persistent store is not a file URL. (%@)", URL);
            }
        } else {
//            CNILogError(@"Failed to remove persistent store. %@", [localError localizedDescription]);
        }
    }
    
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
    _backgroundManagedObjectContext = nil;
    _managedObjectModel = nil;
    
    [self setUpCoreDataStack];
}

- (void)saveToDisk {
    
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        NSError *backgroundSaveError = nil;
        BOOL didSaveBackground = [self.backgroundManagedObjectContext save:&backgroundSaveError];
        if (!didSaveBackground) {
//            CNILogError(@"backgroundManagedObjectContext save error:  %@", [backgroundSaveError localizedDescription]);
        }
    }];
}

- (void)saveContext {
    [self.managedObjectContext performBlockAndWait:^{
        NSError *saveError = nil;
        BOOL didSave = [self.managedObjectContext save:&saveError];
        if (!didSave) {
//            CNILogError(@"managedObjectContext save error:  %@", [saveError localizedDescription]);
        } else {
            [self saveToDisk];
        }
    }];
}

#pragma mark - Helpers

- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator {
    // Request Automatic Migration Using an Options Dictionary
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.databaseName]];
    if (getenv("CleanDataStore")) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    }
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    }
    return persistentStoreCoordinator;
}

- (NSManagedObjectModel *)createManagedObjectModel {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"listsmodel" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSManagedObjectContext *)createBackgroundManagedObjectContext {
    NSManagedObjectContext *backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    [backgroundManagedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    return backgroundManagedObjectContext;
}

- (NSManagedObjectContext *)createManagedObjectContext {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.parentContext = self.backgroundManagedObjectContext;
    [managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    return managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)setUpCoreDataStack {
    self.managedObjectModel = [self createManagedObjectModel];
    self.persistentStoreCoordinator = [self createPersistentStoreCoordinator];
    self.backgroundManagedObjectContext = [self createBackgroundManagedObjectContext];
    self.managedObjectContext = [self createManagedObjectContext];
}

@end
