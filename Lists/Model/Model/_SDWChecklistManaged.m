// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistManaged.m instead.

#import "_SDWChecklistManaged.h"

const struct SDWChecklistManagedAttributes SDWChecklistManagedAttributes = {
	.ilstsID = @"ilstsID",
	.name = @"name",
};

@implementation SDWChecklistManagedID
@end

@implementation _SDWChecklistManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWChecklistManaged" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWChecklistManaged";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWChecklistManaged" inManagedObjectContext:moc_];
}

- (SDWChecklistManagedID*)objectID {
	return (SDWChecklistManagedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic ilstsID;

@dynamic name;

@end

