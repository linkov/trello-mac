// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistItemManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWChecklistItemManagedAttributes {
	__unsafe_unretained NSString *listsID;
	__unsafe_unretained NSString *name;
} SDWChecklistItemManagedAttributes;

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

@end

@interface _SDWChecklistItemManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveListsID;
- (void)setPrimitiveListsID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
