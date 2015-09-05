// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWBoardManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWBoardManagedAttributes {
    __unsafe_unretained NSString *isStarred;
    __unsafe_unretained NSString *listsID;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *updatedAt;
} SDWBoardManagedAttributes;

extern const struct SDWBoardManagedRelationships {
    __unsafe_unretained NSString *lists;
} SDWBoardManagedRelationships;

@class SDWListManaged;

@interface SDWBoardManagedID : NSManagedObjectID {}
@end

@interface _SDWBoardManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SDWBoardManagedID *objectID;

@property (nonatomic, strong) NSNumber *isStarred;

@property (atomic) BOOL isStarredValue;
- (BOOL)isStarredValue;
- (void)setIsStarredValue:(BOOL)value_;

//- (BOOL)validateIsStarred:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate *updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *lists;

- (NSMutableSet *)listsSet;

@end

@interface _SDWBoardManaged (ListsCoreDataGeneratedAccessors)
- (void)addLists:(NSSet *)value_;
- (void)removeLists:(NSSet *)value_;
- (void)addListsObject:(SDWListManaged *)value_;
- (void)removeListsObject:(SDWListManaged *)value_;

@end

@interface _SDWBoardManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveIsStarred;
- (void)      setPrimitiveIsStarred:(NSNumber *)value;

- (BOOL)primitiveIsStarredValue;
- (void)setPrimitiveIsStarredValue:(BOOL)value_;

- (NSString *)primitiveListsID;
- (void)      setPrimitiveListsID:(NSString *)value;

- (NSString *)primitiveName;
- (void)      setPrimitiveName:(NSString *)value;

- (NSDate *)primitiveUpdatedAt;
- (void)    setPrimitiveUpdatedAt:(NSDate *)value;

- (NSMutableSet *)primitiveLists;
- (void)          setPrimitiveLists:(NSMutableSet *)value;

@end
