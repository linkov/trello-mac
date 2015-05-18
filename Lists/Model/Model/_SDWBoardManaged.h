// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWBoardManagedAttributes {
	__unsafe_unretained NSString *listsID;
	__unsafe_unretained NSString *name;
} SDWBoardManagedAttributes;

extern const struct SDWBoardManagedRelationships {
	__unsafe_unretained NSString *lists;
} SDWBoardManagedRelationships;

@class SDWListManaged;

@interface SDWBoardManagedID : NSManagedObjectID {}
@end

@interface _SDWBoardManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWBoardManagedID* objectID;

@property (nonatomic, strong) NSNumber* listsID;

@property (atomic) int16_t listsIDValue;
- (int16_t)listsIDValue;
- (void)setListsIDValue:(int16_t)value_;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWListManaged *lists;

//- (BOOL)validateLists:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWBoardManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveListsID;
- (void)setPrimitiveListsID:(NSNumber*)value;

- (int16_t)primitiveListsIDValue;
- (void)setPrimitiveListsIDValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (SDWListManaged*)primitiveLists;
- (void)setPrimitiveLists:(SDWListManaged*)value;

@end
