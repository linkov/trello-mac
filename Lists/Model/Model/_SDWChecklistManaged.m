// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistManaged.m instead.

#import "_SDWChecklistManaged.h"

const struct SDWChecklistManagedAttributes SDWChecklistManagedAttributes = {
    .ilstsID = @"ilstsID",
    .name = @"name",
    .position = @"position",
};

@implementation SDWChecklistManagedID
@end

@implementation _SDWChecklistManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SDWChecklistManaged" inManagedObjectContext:moc_];
}

+ (NSString *)entityName {
    return @"SDWChecklistManaged";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SDWChecklistManaged" inManagedObjectContext:moc_];
}

- (SDWChecklistManagedID *)objectID {
    return (SDWChecklistManagedID *)[super objectID];
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

@dynamic ilstsID;

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

@end

