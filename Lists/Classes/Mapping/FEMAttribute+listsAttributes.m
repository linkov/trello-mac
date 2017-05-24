//
//  FEMAttribute+listsAttributes.m
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "FEMAttribute+listsAttributes.h"

@implementation FEMAttribute (listsAttributes)


static NSDateFormatter * defaultMappingFormatter;
+ (NSDateFormatter *)defaultMappingFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultMappingFormatter = [[NSDateFormatter alloc] init];
        [defaultMappingFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSZ"];
        [defaultMappingFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [defaultMappingFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    });
    return defaultMappingFormatter;
}

+ (FEMAttribute *)listsIDAttribute {
    
    FEMAttribute *trelloID = [[FEMAttribute alloc] initWithProperty:@"trelloID" keyPath:@"id" map:^id (id value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        }
        return value;
    } reverseMap:^id (id value) {
        if ([value respondsToSelector:@selector(integerValue)]) {
            return @([value integerValue]);
        }
        return nil;
    }];
    return trelloID;
}

+ (FEMAttribute *)dateAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath {
    FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:property keyPath:keyPath map:^id(id value) {
        if ([value isKindOfClass:[NSString class]]) {
            return [[FEMAttribute defaultMappingFormatter] dateFromString:value];
        }
        return nil;
    } reverseMap:^id(id value) {
        return [[FEMAttribute defaultMappingFormatter] stringFromDate:value];
    }];
    return attribute;
}

+ (FEMAttribute *)stringAttributeWithProperty:(NSString *)property fromNumberKeyPath:(NSString *)keyPath {
    FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:property keyPath:keyPath map:^id (id value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        }
        return nil;
    } reverseMap:^id (id value) {
        if([value respondsToSelector:@selector(doubleValue)]){
            return [NSNumber numberWithDouble:[value doubleValue]];
        }
        return nil;
    }];
    return attribute;
}

@end
