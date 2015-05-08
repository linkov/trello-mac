// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.m instead.

#import "_SDWBoardManaged.h"

const struct SDWBoardManagedAttributes SDWBoardManagedAttributes = {
	.listsID = @"listsID",
	.name = @"name",
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

	return keyPaths;
}

@dynamic listsID;

@dynamic name;

@end

