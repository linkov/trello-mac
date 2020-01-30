// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMBoard.m instead.

#import "_SDWMBoard.h"

@implementation SDWMBoardID
@end

@implementation _SDWMBoard

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMBoard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMBoard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMBoard" inManagedObjectContext:moc_];
}

- (SDWMBoardID*)objectID {
	return (SDWMBoardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"starredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"starred"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

@dynamic position;

- (int16_t)positionValue {
	NSNumber *result = [self position];
	return [result shortValue];
}

- (void)setPositionValue:(int16_t)value_ {
	[self setPosition:@(value_)];
}

- (int16_t)primitivePositionValue {
	NSNumber *result = [self primitivePosition];
	return [result shortValue];
}

- (void)setPrimitivePositionValue:(int16_t)value_ {
	[self setPrimitivePosition:@(value_)];
}

@dynamic starred;

- (BOOL)starredValue {
	NSNumber *result = [self starred];
	return [result boolValue];
}

- (void)setStarredValue:(BOOL)value_ {
	[self setStarred:@(value_)];
}

- (BOOL)primitiveStarredValue {
	NSNumber *result = [self primitiveStarred];
	return [result boolValue];
}

- (void)setPrimitiveStarredValue:(BOOL)value_ {
	[self setPrimitiveStarred:@(value_)];
}

@dynamic trelloID;

@dynamic uniqueIdentifier;

@dynamic cards;

- (NSMutableSet<SDWMCard*>*)cardsSet {
	[self willAccessValueForKey:@"cards"];

	NSMutableSet<SDWMCard*> *result = (NSMutableSet<SDWMCard*>*)[self mutableSetValueForKey:@"cards"];

	[self didAccessValueForKey:@"cards"];
	return result;
}

@dynamic labels;

- (NSMutableSet<SDWMLabel*>*)labelsSet {
	[self willAccessValueForKey:@"labels"];

	NSMutableSet<SDWMLabel*> *result = (NSMutableSet<SDWMLabel*>*)[self mutableSetValueForKey:@"labels"];

	[self didAccessValueForKey:@"labels"];
	return result;
}

@dynamic lists;

- (NSMutableSet<SDWMList*>*)listsSet {
	[self willAccessValueForKey:@"lists"];

	NSMutableSet<SDWMList*> *result = (NSMutableSet<SDWMList*>*)[self mutableSetValueForKey:@"lists"];

	[self didAccessValueForKey:@"lists"];
	return result;
}

@dynamic user;

@end

@implementation SDWMBoardAttributes 
+ (NSString *)name {
	return @"name";
}
+ (NSString *)position {
	return @"position";
}
+ (NSString *)starred {
	return @"starred";
}
+ (NSString *)trelloID {
	return @"trelloID";
}
+ (NSString *)uniqueIdentifier {
	return @"uniqueIdentifier";
}
@end

@implementation SDWMBoardRelationships 
+ (NSString *)cards {
	return @"cards";
}
+ (NSString *)labels {
	return @"labels";
}
+ (NSString *)lists {
	return @"lists";
}
+ (NSString *)user {
	return @"user";
}
@end

