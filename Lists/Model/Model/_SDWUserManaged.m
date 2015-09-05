// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWUserManaged.m instead.

#import "_SDWUserManaged.h"

const struct SDWUserManagedAttributes SDWUserManagedAttributes = {
	.firstName = @"firstName",
	.isAdmin = @"isAdmin",
	.lastName = @"lastName",
	.listsID = @"listsID",
	.name = @"name",
	.shortName = @"shortName",
	.token = @"token",
};

const struct SDWUserManagedRelationships SDWUserManagedRelationships = {
	.assignedCards = @"assignedCards",
	.cards = @"cards",
	.lists = @"lists",
	.listsMemberships = @"listsMemberships",
	.selectedCard = @"selectedCard",
	.selectedList = @"selectedList",
};

@implementation SDWUserManagedID
@end

@implementation _SDWUserManaged

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWUserManaged" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWUserManaged";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWUserManaged" inManagedObjectContext:moc_];
}

- (SDWUserManagedID*)objectID {
	return (SDWUserManagedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isAdminValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isAdmin"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic firstName;

@dynamic isAdmin;

- (BOOL)isAdminValue {
	NSNumber *result = [self isAdmin];
	return [result boolValue];
}

- (void)setIsAdminValue:(BOOL)value_ {
	[self setIsAdmin:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsAdminValue {
	NSNumber *result = [self primitiveIsAdmin];
	return [result boolValue];
}

- (void)setPrimitiveIsAdminValue:(BOOL)value_ {
	[self setPrimitiveIsAdmin:[NSNumber numberWithBool:value_]];
}

@dynamic lastName;

@dynamic listsID;

@dynamic name;

@dynamic shortName;

@dynamic token;

@dynamic assignedCards;

- (NSMutableSet*)assignedCardsSet {
	[self willAccessValueForKey:@"assignedCards"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"assignedCards"];

	[self didAccessValueForKey:@"assignedCards"];
	return result;
}

@dynamic cards;

@dynamic lists;

@dynamic listsMemberships;

- (NSMutableSet*)listsMembershipsSet {
	[self willAccessValueForKey:@"listsMemberships"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"listsMemberships"];

	[self didAccessValueForKey:@"listsMemberships"];
	return result;
}

@dynamic selectedCard;

@dynamic selectedList;

@end

