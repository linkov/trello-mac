// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWCardManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWCardManagedAttributes {
    __unsafe_unretained NSString *dueDate;
    __unsafe_unretained NSString *listsDescription;
    __unsafe_unretained NSString *listsID;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *position;
    __unsafe_unretained NSString *updatedAt;
} SDWCardManagedAttributes;

@interface SDWCardManagedID : NSManagedObjectID {}
@end

@interface _SDWCardManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SDWCardManagedID *objectID;

@property (nonatomic, strong) NSDate *dueDate;

//- (BOOL)validateDueDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *listsDescription;

//- (BOOL)validateListsDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber *position;

@property (atomic) int16_t positionValue;
- (int16_t)positionValue;
- (void)   setPositionValue:(int16_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate *updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWCardManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSDate *)primitiveDueDate;
- (void)    setPrimitiveDueDate:(NSDate *)value;

- (NSString *)primitiveListsDescription;
- (void)      setPrimitiveListsDescription:(NSString *)value;

- (NSString *)primitiveListsID;
- (void)      setPrimitiveListsID:(NSString *)value;

- (NSString *)primitiveName;
- (void)      setPrimitiveName:(NSString *)value;

- (NSNumber *)primitivePosition;
- (void)      setPrimitivePosition:(NSNumber *)value;

- (int16_t)primitivePositionValue;
- (void)   setPrimitivePositionValue:(int16_t)value_;

- (NSDate *)primitiveUpdatedAt;
- (void)    setPrimitiveUpdatedAt:(NSDate *)value;

@end
