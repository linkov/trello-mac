// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMList.m instead.

#import "_SDWMList.h"

@implementation SDWMListID
@end

@implementation _SDWMList

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMList" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMList";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMList" inManagedObjectContext:moc_];
}

- (SDWMListID*)objectID {
	return (SDWMListID*)[super objectID];
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

@dynamic board;

@dynamic cards;

- (NSMutableSet<SDWMCard*>*)cardsSet {
	[self willAccessValueForKey:@"cards"];

	NSMutableSet<SDWMCard*> *result = (NSMutableSet<SDWMCard*>*)[self mutableSetValueForKey:@"cards"];

	[self didAccessValueForKey:@"cards"];
	return result;
}

@end

@implementation SDWMListAttributes 
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

@implementation SDWMListRelationships 
+ (NSString *)board {
	return @"board";
}
+ (NSString *)cards {
	return @"cards";
}
@end

