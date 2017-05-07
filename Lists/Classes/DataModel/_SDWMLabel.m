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

@dynamic card;

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
@end

@implementation SDWMLabelRelationships 
+ (NSString *)card {
	return @"card";
}
@end

