// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.m instead.

#import "_SDWBoardManaged.h"

const struct SDWBoardManagedAttributes SDWBoardManagedAttributes = {
	.listsID = @"listsID",
	.name = @"name",
};

const struct SDWBoardManagedRelationships SDWBoardManagedRelationships = {
	.lists = @"lists",
};

@implementation SDWBoardManagedID
@end

@implementation _SDWBoardManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWBoardManaged" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWBoardManaged";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWBoardManaged" inManagedObjectContext:moc_];
}

- (SDWBoardManagedID*)objectID {
	return (SDWBoardManagedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"listsIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"listsID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic listsID;

- (int16_t)listsIDValue {
	NSNumber *result = [self listsID];
	return [result shortValue];
}

- (void)setListsIDValue:(int16_t)value_ {
	[self setListsID:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveListsIDValue {
	NSNumber *result = [self primitiveListsID];
	return [result shortValue];
}

- (void)setPrimitiveListsIDValue:(int16_t)value_ {
	[self setPrimitiveListsID:[NSNumber numberWithShort:value_]];
}

@dynamic name;

@dynamic lists;

@end

