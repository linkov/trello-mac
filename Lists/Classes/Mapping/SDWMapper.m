//
//  SDWMapper.m
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWMapper.h"
#import <FastEasyMapping/FastEasyMapping.h>


@implementation SDWMapper

//+ (id)ez_objectOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSDictionary *)json context:(nonnull NSManagedObjectContext *)context {
//    if (objectClass == [CNIGuest class]) {
//        return [FEMDeserializer objectFromRepresentation:json mapping:[objectClass defaultMappingWithJSONValues:json] context:context];
//    }
//    return [FEMDeserializer objectFromRepresentation:json mapping:[objectClass defaultMapping] context:context];
//}

+ (NSArray *)ez_arrayOfObjectsOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSArray *)json context:(NSManagedObjectContext *)context {
    return [FEMDeserializer collectionFromRepresentation:json mapping:[objectClass defaultMapping] context:context];
}

+ (id)ez_objectOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSDictionary *)json context:(NSManagedObjectContext *)context {
    return [FEMDeserializer objectFromRepresentation:json mapping:[objectClass defaultMapping] context:context];
}

+ (NSArray *)ez_arrayOfObjectsOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSArray *)json {
    return [FEMDeserializer collectionFromRepresentation:json mapping:[objectClass defaultMapping]];
}


@end
