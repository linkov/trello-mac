// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMChecklistItem.m instead.

#import "_SDWMChecklistItem.h"

@implementation SDWMChecklistItemID
@end

@implementation _SDWMChecklistItem

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMChecklistItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMChecklistItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMChecklistItem" inManagedObjectContext:moc_];
}

- (SDWMChecklistItemID*)objectID {
	return (SDWMChecklistItemID*)[super objectID];
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

@dynamic state;

@dynamic trelloID;

@dynamic checklist;

@end

@implementation SDWMChecklistItemAttributes 
+ (NSString *)name {
	return @"name";
}
+ (NSString *)position {
	return @"position";
}
+ (NSString *)state {
	return @"state";
}
+ (NSString *)trelloID {
	return @"trelloID";
}
@end

@implementation SDWMChecklistItemRelationships 
+ (NSString *)checklist {
	return @"checklist";
}
@end

