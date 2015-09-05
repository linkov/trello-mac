// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.m instead.

#import "_SDWBoardManaged.h"

const struct SDWBoardManagedAttributes SDWBoardManagedAttributes = {
    .isStarred = @"isStarred",
    .listsID = @"listsID",
    .name = @"name",
    .updatedAt = @"updatedAt",
};

const struct SDWBoardManagedRelationships SDWBoardManagedRelationships = {
    .lists = @"lists",
};

@implementation SDWBoardManagedID
@end

@implementation _SDWBoardManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SDWBoardManaged" inManagedObjectContext:moc_];
}

+ (NSString *)entityName {
    return @"SDWBoardManaged";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SDWBoardManaged" inManagedObjectContext:moc_];
}

- (SDWBoardManagedID *)objectID {
    return (SDWBoardManagedID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"isStarredValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"isStarred"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic isStarred;

- (BOOL)isStarredValue {
    NSNumber *result = [self isStarred];
    return [result boolValue];
}

- (void)setIsStarredValue:(BOOL)value_ {
    [self setIsStarred:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsStarredValue {
    NSNumber *result = [self primitiveIsStarred];
    return [result boolValue];
}

- (void)setPrimitiveIsStarredValue:(BOOL)value_ {
    [self setPrimitiveIsStarred:[NSNumber numberWithBool:value_]];
}

@dynamic listsID;

@dynamic name;

@dynamic updatedAt;

@dynamic lists;

- (NSMutableSet *)listsSet {
    [self willAccessValueForKey:@"lists"];

    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"lists"];

    [self didAccessValueForKey:@"lists"];
    return result;
}

@end

