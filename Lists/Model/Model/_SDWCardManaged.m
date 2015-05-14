// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWCardManaged.m instead.

#import "_SDWCardManaged.h"

const struct SDWCardManagedAttributes SDWCardManagedAttributes = {
    .dueDate = @"dueDate",
    .listsDescription = @"listsDescription",
    .listsID = @"listsID",
    .name = @"name",
    .position = @"position",
    .updatedAt = @"updatedAt",
};

const struct SDWCardManagedRelationships SDWCardManagedRelationships = {
    .board = @"board",
    .checkLists = @"checkLists",
    .labels = @"labels",
    .user = @"user",
};

@implementation SDWCardManagedID
@end

@implementation _SDWCardManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SDWCardManaged" inManagedObjectContext:moc_];
}

+ (NSString *)entityName {
    return @"SDWCardManaged";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SDWCardManaged" inManagedObjectContext:moc_];
}

- (SDWCardManagedID *)objectID {
    return (SDWCardManagedID *)[super objectID];
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

@dynamic dueDate;

@dynamic listsDescription;

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

@dynamic updatedAt;

@dynamic board;

@dynamic checkLists;

- (NSMutableSet *)checkListsSet {
    [self willAccessValueForKey:@"checkLists"];

    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"checkLists"];

    [self didAccessValueForKey:@"checkLists"];
    return result;
}

@dynamic labels;

- (NSMutableSet *)labelsSet {
    [self willAccessValueForKey:@"labels"];

    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"labels"];

    [self didAccessValueForKey:@"labels"];
    return result;
}

@dynamic user;

@end

