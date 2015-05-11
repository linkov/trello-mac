// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWLabelManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWLabelManagedAttributes {
    __unsafe_unretained NSString *color;
    __unsafe_unretained NSString *listsID;
    __unsafe_unretained NSString *name;
} SDWLabelManagedAttributes;

@interface SDWLabelManagedID : NSManagedObjectID {}
@end

@interface _SDWLabelManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SDWLabelManagedID *objectID;

@property (nonatomic, strong) NSString *color;

//- (BOOL)validateColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWLabelManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveColor;
- (void)      setPrimitiveColor:(NSString *)value;

- (NSString *)primitiveListsID;
- (void)      setPrimitiveListsID:(NSString *)value;

- (NSString *)primitiveName;
- (void)      setPrimitiveName:(NSString *)value;

@end
