// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMChecklist.m instead.

#import "_SDWMChecklist.h"

@implementation SDWMChecklistID
@end

@implementation _SDWMChecklist

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMChecklist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMChecklist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMChecklist" inManagedObjectContext:moc_];
}

- (SDWMChecklistID*)objectID {
	return (SDWMChecklistID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

@dynamic position;

- (int64_t)positionValue {
	NSNumber *result = [self position];
	return [result longLongValue];
}

- (void)setPositionValue:(int64_t)value_ {
	[self setPosition:@(value_)];
}

- (int64_t)primitivePositionValue {
	NSNumber *result = [self primitivePosition];
	return [result longLongValue];
}

- (void)setPrimitivePositionValue:(int64_t)value_ {
	[self setPrimitivePosition:@(value_)];
}

@dynamic trelloID;

@dynamic card;

@dynamic items;

- (NSMutableSet<SDWMChecklistItem*>*)itemsSet {
	[self willAccessValueForKey:@"items"];

	NSMutableSet<SDWMChecklistItem*> *result = (NSMutableSet<SDWMChecklistItem*>*)[self mutableSetValueForKey:@"items"];

	[self didAccessValueForKey:@"items"];
	return result;
}

@end

@implementation SDWMChecklistAttributes 
+ (NSString *)name {
	return @"name";
}
+ (NSString *)position {
	return @"position";
}
+ (NSString *)trelloID {
	return @"trelloID";
}
@end

@implementation SDWMChecklistRelationships 
+ (NSString *)card {
	return @"card";
}
+ (NSString *)items {
	return @"items";
}
@end

