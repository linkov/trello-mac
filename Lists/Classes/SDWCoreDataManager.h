//
//  SDWCoreDataManager.h
//  Lists
//
//  Created by alex on 5/14/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface SDWCoreDataManager : NSObject


@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)manager;
//- (id)initWithCallback:(InitCallbackBlock)callback;
//- (void)save;

@end
