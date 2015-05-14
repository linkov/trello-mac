// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistItemManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWChecklistItemManagedAttributes {
	__unsafe_unretained NSString *listsID;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *position;
	__unsafe_unretained NSString *state;
} SDWChecklistItemManagedAttributes;

extern const struct SDWChecklistItemManagedRelationships {
	__unsafe_unretained NSString *list;
} SDWChecklistItemManagedRelationships;

@class SDWChecklistManaged;

@interface SDWChecklistItemManagedID : NSManagedObjectID {}
@end

@interface _SDWChecklistItemManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWChecklistItemManagedID* objectID;

@property (nonatomic, strong) NSString* listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* position;

@property (atomic) int16_t positionValue;
- (int16_t)positionValue;
- (void)setPositionValue:(int16_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWChecklistManaged *list;

//- (BOOL)validateList:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWChecklistItemManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveListsID;
- (void)setPrimitiveListsID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (int16_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int16_t)value_;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (SDWChecklistManaged*)primitiveList;
- (void)setPrimitiveList:(SDWChecklistManaged*)value;

@end
