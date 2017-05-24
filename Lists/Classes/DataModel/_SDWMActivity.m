// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMActivity.m instead.

#import "_SDWMActivity.h"

@implementation SDWMActivityID
@end

@implementation _SDWMActivity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMActivity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMActivity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMActivity" inManagedObjectContext:moc_];
}

- (SDWMActivityID*)objectID {
	return (SDWMActivityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic content;

@dynamic memberInitials;

@dynamic time;

@dynamic trelloID;

@dynamic card;

@end

@implementation SDWMActivityAttributes 
+ (NSString *)content {
	return @"content";
}
+ (NSString *)memberInitials {
	return @"memberInitials";
}
+ (NSString *)time {
	return @"time";
}
+ (NSString *)trelloID {
	return @"trelloID";
}
@end

@implementation SDWMActivityRelationships 
+ (NSString *)card {
	return @"card";
}
@end

