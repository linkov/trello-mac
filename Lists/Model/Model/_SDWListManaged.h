// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWListManaged.h instead.

#import <CoreData/CoreData.h>

extern const struct SDWListManagedAttributes {
    __unsafe_unretained NSString *isCollapsed;
    __unsafe_unretained NSString *listsID;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *position;
} SDWListManagedAttributes;

extern const struct SDWListManagedRelationships {
    __unsafe_unretained NSString *board;
    __unsafe_unretained NSString *cards;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *user;
} SDWListManagedRelationships;

@class SDWBoardManaged;
@class SDWCardManaged;
@class NSManagedObject;
@class NSManagedObject;

@interface SDWListManagedID : NSManagedObjectID {}
@end

@interface _SDWListManaged : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SDWListManagedID *objectID;

@property (nonatomic, strong) NSNumber *isCollapsed;

@property (atomic) BOOL isCollapsedValue;
- (BOOL)isCollapsedValue;
- (void)setIsCollapsedValue:(BOOL)value_;

//- (BOOL)validateIsCollapsed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *listsID;

//- (BOOL)validateListsID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber *position;

@property (atomic) int16_t positionValue;
- (int16_t)positionValue;
- (void)   setPositionValue:(int16_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWBoardManaged *board;

//- (BOOL)validateBoard:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *cards;

- (NSMutableSet *)cardsSet;

@property (nonatomic, strong) NSSet *members;

- (NSMutableSet *)membersSet;

@property (nonatomic, strong) NSManagedObject *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWListManaged (CardsCoreDataGeneratedAccessors)
- (void)addCards:(NSSet *)value_;
- (void)removeCards:(NSSet *)value_;
- (void)addCardsObject:(SDWCardManaged *)value_;
- (void)removeCardsObject:(SDWCardManaged *)value_;

@end

@interface _SDWListManaged (MembersCoreDataGeneratedAccessors)
- (void)addMembers:(NSSet *)value_;
- (void)removeMembers:(NSSet *)value_;
- (void)addMembersObject:(NSManagedObject *)value_;
- (void)removeMembersObject:(NSManagedObject *)value_;

@end

@interface _SDWListManaged (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveIsCollapsed;
- (void)      setPrimitiveIsCollapsed:(NSNumber *)value;

- (BOOL)primitiveIsCollapsedValue;
- (void)setPrimitiveIsCollapsedValue:(BOOL)value_;

- (NSString *)primitiveListsID;
- (void)      setPrimitiveListsID:(NSString *)value;

- (NSString *)primitiveName;
- (void)      setPrimitiveName:(NSString *)value;

- (NSNumber *)primitivePosition;
- (void)      setPrimitivePosition:(NSNumber *)value;

- (int16_t)primitivePositionValue;
- (void)   setPrimitivePositionValue:(int16_t)value_;

- (SDWBoardManaged *)primitiveBoard;
- (void)             setPrimitiveBoard:(SDWBoardManaged *)value;

- (NSMutableSet *)primitiveCards;
- (void)          setPrimitiveCards:(NSMutableSet *)value;

- (NSMutableSet *)primitiveMembers;
- (void)          setPrimitiveMembers:(NSMutableSet *)value;

- (NSManagedObject *)primitiveUser;
- (void)             setPrimitiveUser:(NSManagedObject *)value;

@end
