// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWUserManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWUserManagedAttributes {
    __unsafe_unretained NSString *firstName;
    __unsafe_unretained NSString *isAdmin;
    __unsafe_unretained NSString *lastName;
    __unsafe_unretained NSString *listsID;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *shortName;
    __unsafe_unretained NSString *token;
} SDWUserManagedAttributes;

extern const struct SDWUserManagedRelationships {
    __unsafe_unretained NSString *assignedCards;
    __unsafe_unretained NSString *cards;
    __unsafe_unretained NSString *lists;
    __unsafe_unretained NSString *listsMemberships;
    __unsafe_unretained NSString *selectedCard;
    __unsafe_unretained NSString *selectedList;
} SDWUserManagedRelationships;

@class SDWCardManaged;
@class SDWCardManaged;
@class SDWListManaged;
@class SDWListManaged;
@class SDWCardManaged;
@class SDWListManaged;

@interface SDWUserManagedID : NSManagedObjectID {}
@end

@interface _SDWUserManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SDWUserManagedID *objectID;

@property (nonatomic, strong) NSString *firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber *isAdmin;

@property (atomic) BOOL isAdminValue;
- (BOOL)isAdminValue;
- (void)setIsAdminValue:(BOOL)value_;

//- (BOOL)validateIsAdmin:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *shortName;

//- (BOOL)validateShortName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *token;

//- (BOOL)validateToken:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *assignedCards;

- (NSMutableSet *)assignedCardsSet;

@property (nonatomic, strong) SDWCardManaged *cards;

//- (BOOL)validateCards:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWListManaged *lists;

//- (BOOL)validateLists:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *listsMemberships;

- (NSMutableSet *)listsMembershipsSet;

@property (nonatomic, strong) SDWCardManaged *selectedCard;

//- (BOOL)validateSelectedCard:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWListManaged *selectedList;

//- (BOOL)validateSelectedList:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWUserManaged (AssignedCardsCoreDataGeneratedAccessors)
- (void)addAssignedCards:(NSSet *)value_;
- (void)removeAssignedCards:(NSSet *)value_;
- (void)addAssignedCardsObject:(SDWCardManaged *)value_;
- (void)removeAssignedCardsObject:(SDWCardManaged *)value_;

@end

@interface _SDWUserManaged (ListsMembershipsCoreDataGeneratedAccessors)
- (void)addListsMemberships:(NSSet *)value_;
- (void)removeListsMemberships:(NSSet *)value_;
- (void)addListsMembershipsObject:(SDWListManaged *)value_;
- (void)removeListsMembershipsObject:(SDWListManaged *)value_;

@end

@interface _SDWUserManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveFirstName;
- (void)      setPrimitiveFirstName:(NSString *)value;

- (NSNumber *)primitiveIsAdmin;
- (void)      setPrimitiveIsAdmin:(NSNumber *)value;

- (BOOL)primitiveIsAdminValue;
- (void)setPrimitiveIsAdminValue:(BOOL)value_;

- (NSString *)primitiveLastName;
- (void)      setPrimitiveLastName:(NSString *)value;

- (NSString *)primitiveListsID;
- (void)      setPrimitiveListsID:(NSString *)value;

- (NSString *)primitiveName;
- (void)      setPrimitiveName:(NSString *)value;

- (NSString *)primitiveShortName;
- (void)      setPrimitiveShortName:(NSString *)value;

- (NSString *)primitiveToken;
- (void)      setPrimitiveToken:(NSString *)value;

- (NSMutableSet *)primitiveAssignedCards;
- (void)          setPrimitiveAssignedCards:(NSMutableSet *)value;

- (SDWCardManaged *)primitiveCards;
- (void)            setPrimitiveCards:(SDWCardManaged *)value;

- (SDWListManaged *)primitiveLists;
- (void)            setPrimitiveLists:(SDWListManaged *)value;

- (NSMutableSet *)primitiveListsMemberships;
- (void)          setPrimitiveListsMemberships:(NSMutableSet *)value;

- (SDWCardManaged *)primitiveSelectedCard;
- (void)            setPrimitiveSelectedCard:(SDWCardManaged *)value;

- (SDWListManaged *)primitiveSelectedList;
- (void)            setPrimitiveSelectedList:(SDWListManaged *)value;

@end
