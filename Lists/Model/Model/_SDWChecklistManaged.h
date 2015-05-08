// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWChecklistManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWChecklistManagedAttributes {
	__unsafe_unretained NSString *ilstsID;
	__unsafe_unretained NSString *name;
} SDWChecklistManagedAttributes;

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

@end

@interface _SDWChecklistManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIlstsID;
- (void)setPrimitiveIlstsID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
