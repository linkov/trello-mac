//
//  SDWMapping.h
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/18/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import CoreData;

@protocol SDWJSONMapping <NSObject>

- (instancetype)mappedObjectFromJSON:(NSDictionary *)json;

//- (BOOL)shouldUpdateWithJSON:(NSDictionary *)json;
//
//+ (NSString *)primaryAttributeName;
//+ (NSString *)primaryAttributeValueFromJSON:(NSDictionary *)json;

@end

