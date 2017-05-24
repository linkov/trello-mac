//
//  SDWMapper.h
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWObjectMapping.h"
@import CoreData;

@interface SDWMapper : NSObject


//+ (id)ez_objectOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSDictionary *)json context:(NSManagedObjectContext *)context;
+ (NSArray *)ez_arrayOfObjectsOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSArray *)json context:(NSManagedObjectContext *)context;

+ (id)ez_objectOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSDictionary *)json context:(NSManagedObjectContext *)context;

+ (NSArray *)ez_arrayOfObjectsOfClass:(Class<SDWObjectMapping>)objectClass fromJSON:(NSArray *)json;


@end
