// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWBoardManagedAttributes {
	__unsafe_unretained NSString *listsID;
	__unsafe_unretained NSString *name;
} SDWBoardManagedAttributes;

@interface SDWBoardManagedID : NSManagedObjectID {}
@end

@interface _SDWBoardManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWBoardManagedID* objectID;

@property (nonatomic, strong) NSString* listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWBoardManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveListsID;
- (void)setPrimitiveListsID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
