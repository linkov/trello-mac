//
//  SDWMapper.h
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/18/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWJSONMapping.h"

@interface SDWMapper : NSObject

/**
 * Creates new instance or takes existed one from core data
 * Map given json to the instance of the given class
 * @param objectClas - which class objects we've received in json
 * @param json - received json
 * @return instance of the given class
 */
+ (id)objectOfClass:(Class<SDWJSONMapping>)objectClass fromJSON:(NSDictionary *)json;

/**
 * Creates array of new instances or existed from core data
 * Map given json to the instances of the given class
 * @param objectClas - which class objects we've received in json
 * @param json - received json array
 * @return array of instances of the given class
 */
+ (NSArray *)arrayOfObjectsOfClass:(Class<SDWJSONMapping>)objectClass fromJSON:(NSArray *)json;

@end
