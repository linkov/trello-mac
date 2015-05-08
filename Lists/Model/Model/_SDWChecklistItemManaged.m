// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistItemManaged.m instead.

#import "_SDWChecklistItemManaged.h"

const struct SDWChecklistItemManagedAttributes SDWChecklistItemManagedAttributes = {
	.listsID = @"listsID",
	.name = @"name",
};

@implementation SDWChecklistItemManagedID
@end

@implementation _SDWChecklistItemManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWChecklistItemManaged" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWChecklistItemManaged";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWChecklistItemManaged" inManagedObjectContext:moc_];
}

- (SDWChecklistItemManagedID*)objectID {
	return (SDWChecklistItemManagedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic listsID;

@dynamic name;

@end

