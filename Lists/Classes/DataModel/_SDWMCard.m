// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMCard.m instead.

#import "_SDWMCard.h"

@implementation SDWMCardID
@end

@implementation _SDWMCard

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SDWMCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SDWMCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SDWMCard" inManagedObjectContext:moc_];
}

- (SDWMCardID*)objectID {
	return (SDWMCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"attachmentsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"attachmentsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"checkItemsCheckedCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"checkItemsCheckedCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"checkItemsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"checkItemsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"commentsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"commentsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic attachmentsCount;

- (int16_t)attachmentsCountValue {
	NSNumber *result = [self attachmentsCount];
	return [result shortValue];
}

- (void)setAttachmentsCountValue:(int16_t)value_ {
	[self setAttachmentsCount:@(value_)];
}

- (int16_t)primitiveAttachmentsCountValue {
	NSNumber *result = [self primitiveAttachmentsCount];
	return [result shortValue];
}

- (void)setPrimitiveAttachmentsCountValue:(int16_t)value_ {
	[self setPrimitiveAttachmentsCount:@(value_)];
}

@dynamic cardDescription;

@dynamic checkItemsCheckedCount;

- (int16_t)checkItemsCheckedCountValue {
	NSNumber *result = [self checkItemsCheckedCount];
	return [result shortValue];
}

- (void)setCheckItemsCheckedCountValue:(int16_t)value_ {
	[self setCheckItemsCheckedCount:@(value_)];
}

- (int16_t)primitiveCheckItemsCheckedCountValue {
	NSNumber *result = [self primitiveCheckItemsCheckedCount];
	return [result shortValue];
}

- (void)setPrimitiveCheckItemsCheckedCountValue:(int16_t)value_ {
	[self setPrimitiveCheckItemsCheckedCount:@(value_)];
}

@dynamic checkItemsCount;

- (int16_t)checkItemsCountValue {
	NSNumber *result = [self checkItemsCount];
	return [result shortValue];
}

- (void)setCheckItemsCountValue:(int16_t)value_ {
	[self setCheckItemsCount:@(value_)];
}

- (int16_t)primitiveCheckItemsCountValue {
	NSNumber *result = [self primitiveCheckItemsCount];
	return [result shortValue];
}

- (void)setPrimitiveCheckItemsCountValue:(int16_t)value_ {
	[self setPrimitiveCheckItemsCount:@(value_)];
}

@dynamic commentsCount;

- (int16_t)commentsCountValue {
	NSNumber *result = [self commentsCount];
	return [result shortValue];
}

- (void)setCommentsCountValue:(int16_t)value_ {
	[self setCommentsCount:@(value_)];
}

- (int16_t)primitiveCommentsCountValue {
	NSNumber *result = [self primitiveCommentsCount];
	return [result shortValue];
}

- (void)setPrimitiveCommentsCountValue:(int16_t)value_ {
	[self setPrimitiveCommentsCount:@(value_)];
}

@dynamic dueDate;

@dynamic lastUpdate;

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

@dynamic trelloID;

@dynamic uniqueIdentifier;

@dynamic activities;

- (NSMutableSet<SDWMActivity*>*)activitiesSet {
	[self willAccessValueForKey:@"activities"];

	NSMutableSet<SDWMActivity*> *result = (NSMutableSet<SDWMActivity*>*)[self mutableSetValueForKey:@"activities"];

	[self didAccessValueForKey:@"activities"];
	return result;
}

@dynamic board;

@dynamic checklists;

- (NSMutableSet<SDWMChecklist*>*)checklistsSet {
	[self willAccessValueForKey:@"checklists"];

	NSMutableSet<SDWMChecklist*> *result = (NSMutableSet<SDWMChecklist*>*)[self mutableSetValueForKey:@"checklists"];

	[self didAccessValueForKey:@"checklists"];
	return result;
}

@dynamic labels;

- (NSMutableSet<SDWMLabel*>*)labelsSet {
	[self willAccessValueForKey:@"labels"];

	NSMutableSet<SDWMLabel*> *result = (NSMutableSet<SDWMLabel*>*)[self mutableSetValueForKey:@"labels"];

	[self didAccessValueForKey:@"labels"];
	return result;
}

@dynamic list;

@dynamic members;

- (NSMutableSet<SDWMUser*>*)membersSet {
	[self willAccessValueForKey:@"members"];

	NSMutableSet<SDWMUser*> *result = (NSMutableSet<SDWMUser*>*)[self mutableSetValueForKey:@"members"];

	[self didAccessValueForKey:@"members"];
	return result;
}

@dynamic user;

@end

@implementation SDWMCardAttributes 
+ (NSString *)attachmentsCount {
	return @"attachmentsCount";
}
+ (NSString *)cardDescription {
	return @"cardDescription";
}
+ (NSString *)checkItemsCheckedCount {
	return @"checkItemsCheckedCount";
}
+ (NSString *)checkItemsCount {
	return @"checkItemsCount";
}
+ (NSString *)commentsCount {
	return @"commentsCount";
}
+ (NSString *)dueDate {
	return @"dueDate";
}
+ (NSString *)lastUpdate {
	return @"lastUpdate";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)position {
	return @"position";
}
+ (NSString *)trelloID {
	return @"trelloID";
}
+ (NSString *)uniqueIdentifier {
	return @"uniqueIdentifier";
}
@end

@implementation SDWMCardRelationships 
+ (NSString *)activities {
	return @"activities";
}
+ (NSString *)board {
	return @"board";
}
+ (NSString *)checklists {
	return @"checklists";
}
+ (NSString *)labels {
	return @"labels";
}
+ (NSString *)list {
	return @"list";
}
+ (NSString *)members {
	return @"members";
}
+ (NSString *)user {
	return @"user";
}
@end

