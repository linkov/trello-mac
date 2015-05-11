// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistItemManaged.m instead.

#import "_SDWChecklistItemManaged.h"

const struct SDWChecklistItemManagedAttributes SDWChecklistItemManagedAttributes = {
    .listsID = @"listsID",
    .name = @"name",
    .position = @"position",
    .state = @"state",
};

@implementation SDWChecklistItemManagedID
@end

@implementation _SDWChecklistItemManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert( moc_ );
    return [NSEntityDescription insertNewObjectForEntityForName:@"SDWChecklistItemManaged" inManagedObjectContext:moc_];
}

+ (NSString *)entityName {
    return @"SDWChecklistItemManaged";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert( moc_ );
    return [NSEntityDescription entityForName:@"SDWChecklistItemManaged" inManagedObjectContext:moc_];
}

- (SDWChecklistItemManagedID *)objectID {
    return (SDWChecklistItemManagedID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"positionValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"position"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic listsID;

@dynamic name;

@dynamic position;

- (int16_t)positionValue {
    NSNumber *result = [self position];
    return [result shortValue];
}

- (void)setPositionValue:(int16_t)value_ {
    [self setPosition:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePositionValue {
    NSNumber *result = [self primitivePosition];
    return [result shortValue];
}

- (void)setPrimitivePositionValue:(int16_t)value_ {
    [self setPrimitivePosition:[NSNumber numberWithShort:value_]];
}

@dynamic state;

@end

