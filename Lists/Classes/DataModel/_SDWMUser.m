// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMUser.m instead.

#import "_SDWMUser.h"

@implementation SDWMUserID
@end

@implementation _SDWMUser

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMUser" inManagedObjectContext:moc_];
}

- (SDWMUserID*)objectID {
	return (SDWMUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic initials;

@dynamic name;

@dynamic trelloID;

@dynamic uniqueIdentifier;

@dynamic boards;

- (NSMutableSet<SDWMBoard*>*)boardsSet {
	[self willAccessValueForKey:@"boards"];

	NSMutableSet<SDWMBoard*> *result = (NSMutableSet<SDWMBoard*>*)[self mutableSetValueForKey:@"boards"];

	[self didAccessValueForKey:@"boards"];
	return result;
}

@dynamic cards;

- (NSMutableSet<SDWMCard*>*)cardsSet {
	[self willAccessValueForKey:@"cards"];

	NSMutableSet<SDWMCard*> *result = (NSMutableSet<SDWMCard*>*)[self mutableSetValueForKey:@"cards"];

	[self didAccessValueForKey:@"cards"];
	return result;
}

@end

@implementation SDWMUserAttributes 
+ (NSString *)initials {
	return @"initials";
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

@implementation SDWMUserRelationships 
+ (NSString *)boards {
	return @"boards";
}
+ (NSString *)cards {
	return @"cards";
}
@end

