// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWLabelManaged.m instead.

#import "_SDWLabelManaged.h"

const struct SDWLabelManagedAttributes SDWLabelManagedAttributes = {
    .color = @"color",
    .listsID = @"listsID",
    .name = @"name",
};

const struct SDWLabelManagedRelationships SDWLabelManagedRelationships = {
    .cards = @"cards",
};

@implementation SDWLabelManagedID
@end

@implementation _SDWLabelManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SDWLabelManaged" inManagedObjectContext:moc_];
}

+ (NSString *)entityName {
    return @"SDWLabelManaged";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SDWLabelManaged" inManagedObjectContext:moc_];
}

- (SDWLabelManagedID *)objectID {
    return (SDWLabelManagedID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic color;

@dynamic listsID;

@dynamic name;

@dynamic cards;

- (NSMutableSet *)cardsSet {
    [self willAccessValueForKey:@"cards"];

    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"cards"];

    [self didAccessValueForKey:@"cards"];
    return result;
}

@end

