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

extern const struct SDWCardManagedRelationships {
    __unsafe_unretained NSString *assignees;
    __unsafe_unretained NSString *checkLists;
    __unsafe_unretained NSString *labels;
    __unsafe_unretained NSString *list;
    __unsafe_unretained NSString *selectedByUser;
    __unsafe_unretained NSString *user;
} SDWCardManagedRelationships;

@class SDWUserManaged;
@class SDWChecklistManaged;
@class SDWLabelManaged;
@class SDWListManaged;
@class SDWUserManaged;
@class SDWUserManaged;

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

@property (nonatomic, strong) NSSet *assignees;

- (NSMutableSet *)assigneesSet;

@property (nonatomic, strong) NSSet *checkLists;

- (NSMutableSet *)checkListsSet;

@property (nonatomic, strong) NSSet *labels;

- (NSMutableSet *)labelsSet;

@property (nonatomic, strong) SDWListManaged *list;

//- (BOOL)validateList:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWUserManaged *selectedByUser;

//- (BOOL)validateSelectedByUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SDWUserManaged *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _SDWCardManaged (AssigneesCoreDataGeneratedAccessors)
- (void)addAssignees:(NSSet *)value_;
- (void)removeAssignees:(NSSet *)value_;
- (void)addAssigneesObject:(SDWUserManaged *)value_;
- (void)removeAssigneesObject:(SDWUserManaged *)value_;

@end

@interface _SDWCardManaged (CheckListsCoreDataGeneratedAccessors)
- (void)addCheckLists:(NSSet *)value_;
- (void)removeCheckLists:(NSSet *)value_;
- (void)addCheckListsObject:(SDWChecklistManaged *)value_;
- (void)removeCheckListsObject:(SDWChecklistManaged *)value_;

@end

@interface _SDWCardManaged (LabelsCoreDataGeneratedAccessors)
- (void)addLabels:(NSSet *)value_;
- (void)removeLabels:(NSSet *)value_;
- (void)addLabelsObject:(SDWLabelManaged *)value_;
- (void)removeLabelsObject:(SDWLabelManaged *)value_;

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

- (NSMutableSet *)primitiveAssignees;
- (void)          setPrimitiveAssignees:(NSMutableSet *)value;

- (NSMutableSet *)primitiveCheckLists;
- (void)          setPrimitiveCheckLists:(NSMutableSet *)value;

- (NSMutableSet *)primitiveLabels;
- (void)          setPrimitiveLabels:(NSMutableSet *)value;

- (SDWListManaged *)primitiveList;
- (void)            setPrimitiveList:(SDWListManaged *)value;

- (SDWUserManaged *)primitiveSelectedByUser;
- (void)            setPrimitiveSelectedByUser:(SDWUserManaged *)value;

- (SDWUserManaged *)primitiveUser;
- (void)            setPrimitiveUser:(SDWUserManaged *)value;

@end
