// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMLabel.m instead.

#import "_SDWMLabel.h"

@implementation SDWMLabelID
@end

@implementation _SDWMLabel

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMLabel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMLabel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMLabel" inManagedObjectContext:moc_];
}

- (SDWMLabelID*)objectID {
	return (SDWMLabelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic color;

@dynamic name;

@dynamic trelloID;

@dynamic uniqueIdentifier;

@dynamic cards;

- (NSMutableSet<SDWMCard*>*)cardsSet {
	[self willAccessValueForKey:@"cards"];

	NSMutableSet<SDWMCard*> *result = (NSMutableSet<SDWMCard*>*)[self mutableSetValueForKey:@"cards"];

	[self didAccessValueForKey:@"cards"];
	return result;
}

@end

@implementation SDWMLabelAttributes 
+ (NSString *)color {
	return @"color";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)trelloID {
	return @"trelloID";
}
+ (NSString *)uniqueIdentifier {
	return @"uniqueIdentifier";
}
@end

@implementation SDWMLabelRelationships 
+ (NSString *)cards {
	return @"cards";
}
@end

