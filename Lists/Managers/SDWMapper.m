//
//  SDWMapper.m
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/18/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWMapper.h"
#import "SDWCoreDataManager.h"
#import "KZAsserts.h"

@implementation SDWMapper

+ (id __nonnull)objectOfClass:(Class __nonnull)objectClass fromJSON:(NSDictionary *__nonnull)json {
    if (![objectClass conformsToProtocol:@protocol(SDWJSONMapping)]) {
        return nil;
    }
    if (!json) {
        return nil;
    }

    NSString *primaryJSONValue = json[@"id"];
//    if (!primaryJSONValue) {
//        return nil;
//    }

    id object = [[SDWCoreDataManager manager] fetchEntityWithName:[objectClass entityName] andID:primaryJSONValue];
    if (!object) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[objectClass entityName]
                                               inManagedObjectContext:[SDWCoreDataManager manager].managedObjectContext];
    }

//    if ([object shouldUpdateWithJSON:json]) {
//        object = [object updateWithJSON:json];
//        [[CNIDataModelManager manager] saveContext];
//        return object;
//    } else {
//        return object;
//    }

    object = [object mappedObjectFromJSON:json];

    return object;
}

+ (NSArray *__nonnull)arrayOfObjectsOfClass:(Class __nonnull)objectClass fromJSON:(NSArray *__nonnull)json {
    AssertTrueOr([objectClass conformsToProtocol:@protocol(SDWJSONMapping)], return nil; );
    AssertTrueOr(json, return nil; );
    AssertTrueOr([json isKindOfClass:[NSArray class]], return nil; );

    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *objectJSON in json) {
        id object = [self objectOfClass:objectClass fromJSON:objectJSON];
        if (object) {
            [result addObject:object];
        }
    }

    return result;
}

@end