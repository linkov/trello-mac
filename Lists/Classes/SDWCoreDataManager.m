//
//  SDWCoreDataManager.m
//  Lists
//
//  Created by alex on 5/14/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCoreDataManager.h"

@interface SDWCoreDataManager ()

//If we need to display something to the user, we use this context. If the user is going to edit something, we use this context. No exceptions.
@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;

// avoids locking the UI on save
@property (strong) NSManagedObjectContext *privateContext;

@end

@implementation SDWCoreDataManager

static SDWCoreDataManager *manager;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SDWCoreDataManager new];
    });
    return manager;
}

@end
