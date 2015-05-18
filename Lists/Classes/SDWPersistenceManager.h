//
//  SDWCoreDataManager.h
//  Lists
//
//  Created by alex on 5/14/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWTypesAndEnums.h"

@import Foundation;
@import CoreData;

@interface SDWPersistenceManager : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)manager;
- (id)          setupCoreDataWithCompletion:(SDWEmptyBlock)completion;
- (void)        save;

- (id)fetchEntityName:(NSString *)entityName withListsID:(NSString *)listsID;

@end
