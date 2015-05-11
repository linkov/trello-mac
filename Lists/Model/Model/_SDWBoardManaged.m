// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.m instead.

#import "_SDWBoardManaged.h"

const struct SDWBoardManagedAttributes SDWBoardManagedAttributes = {
    .listsID = @"listsID",
    .name = @"name",
    .position = @"position",
};

@implementation SDWBoardManagedID
@end

@implementation _SDWBoardManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SDWBoardManaged" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"SDWBoardManaged";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SDWBoardManaged" inManagedObjectContext:moc_];
}

- (SDWBoardManagedID *)objectID
{
    return (SDWBoardManagedID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
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

- (int16_t)positionValue
{
    NSNumber *result = [self position];
    return [result shortValue];
}

- (void)setPositionValue:(int16_t)value_
{
    [self setPosition:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePositionValue
{
    NSNumber *result = [self primitivePosition];
    return [result shortValue];
}

- (void)setPrimitivePositionValue:(int16_t)value_
{
    [self setPrimitivePosition:[NSNumber numberWithShort:value_]];
}

@end

