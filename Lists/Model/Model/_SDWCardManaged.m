// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWCardManaged.m instead.

#import "_SDWCardManaged.h"

const struct SDWCardManagedAttributes SDWCardManagedAttributes = {
	.listsID = @"listsID",
	.name = @"name",
};

@implementation SDWCardManagedID
@end

@implementation _SDWCardManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWCardManaged" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWCardManaged";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWCardManaged" inManagedObjectContext:moc_];
}

- (SDWCardManagedID*)objectID {
	return (SDWCardManagedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic listsID;

@dynamic name;

@end

