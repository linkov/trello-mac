// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWListManaged.m instead.

#import "_SDWListManaged.h"

const struct SDWListManagedAttributes SDWListManagedAttributes = {
	.isCollapsed = @"isCollapsed",
	.listsID = @"listsID",
	.name = @"name",
	.position = @"position",
};

const struct SDWListManagedRelationships SDWListManagedRelationships = {
	.board = @"board",
	.cards = @"cards",
	.members = @"members",
	.selectedByUser = @"selectedByUser",
	.user = @"user",
};

@implementation SDWListManagedID
@end

@implementation _SDWListManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWListManaged" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWListManaged";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWListManaged" inManagedObjectContext:moc_];
}

- (SDWListManagedID*)objectID {
	return (SDWListManagedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isCollapsedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isCollapsed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic isCollapsed;

- (BOOL)isCollapsedValue {
	NSNumber *result = [self isCollapsed];
	return [result boolValue];
}

- (void)setIsCollapsedValue:(BOOL)value_ {
	[self setIsCollapsed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsCollapsedValue {
	NSNumber *result = [self primitiveIsCollapsed];
	return [result boolValue];
}

- (void)setPrimitiveIsCollapsedValue:(BOOL)value_ {
	[self setPrimitiveIsCollapsed:[NSNumber numberWithBool:value_]];
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

@dynamic board;

@dynamic cards;

- (NSMutableSet*)cardsSet {
	[self willAccessValueForKey:@"cards"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"cards"];

	[self didAccessValueForKey:@"cards"];
	return result;
}

@dynamic members;

- (NSMutableSet*)membersSet {
	[self willAccessValueForKey:@"members"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"members"];

	[self didAccessValueForKey:@"members"];
	return result;
}

@dynamic selectedByUser;

@dynamic user;

@end

