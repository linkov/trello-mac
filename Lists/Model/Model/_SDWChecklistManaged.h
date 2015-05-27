// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWChecklistManagedAttributes {
	__unsafe_unretained NSString *ilstsID;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *position;
} SDWChecklistManagedAttributes;

extern const struct SDWChecklistManagedRelationships {
	__unsafe_unretained NSString *card;
	__unsafe_unretained NSString *listItems;
} SDWChecklistManagedRelationships;

@class SDWCardManaged;
@class SDWChecklistItemManaged;

@interface SDWChecklistManagedID : NSManagedObjectID {}
@end

@interface _SDWChecklistManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWChecklistManagedID* objectID;

@property (nonatomic, strong) NSString* ilstsID;

//- (BOOL)validateIlstsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* position;

@property (atomic) int16_t positionValue;
- (int16_t)positionValue;
- (void)setPositionValue:(int16_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWCardManaged *card;

//- (BOOL)validateCard:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *listItems;

- (NSMutableSet*)listItemsSet;

@end

@interface _SDWChecklistManaged (ListItemsCoreDataGeneratedAccessors)
- (void)addListItems:(NSSet*)value_;
- (void)removeListItems:(NSSet*)value_;
- (void)addListItemsObject:(SDWChecklistItemManaged*)value_;
- (void)removeListItemsObject:(SDWChecklistItemManaged*)value_;

@end

@interface _SDWChecklistManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIlstsID;
- (void)setPrimitiveIlstsID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (int16_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int16_t)value_;

- (SDWCardManaged*)primitiveCard;
- (void)setPrimitiveCard:(SDWCardManaged*)value;

- (NSMutableSet*)primitiveListItems;
- (void)setPrimitiveListItems:(NSMutableSet*)value;

@end
