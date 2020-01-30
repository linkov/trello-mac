// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMCard.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMActivity;
@class SDWMBoard;
@class SDWMChecklist;
@class SDWMLabel;
@class SDWMList;
@class SDWMUser;
@class SDWMUser;

@interface SDWMCardID : NSManagedObjectID {}
@end

@interface _SDWMCard : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMCardID *objectID;

@property (nonatomic, strong, nullable) NSString* cardDescription;

@property (nonatomic, strong, nullable) NSNumber* checkItemsCheckedCount;

@property (atomic) int16_t checkItemsCheckedCountValue;
- (int16_t)checkItemsCheckedCountValue;
- (void)setCheckItemsCheckedCountValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSNumber* checkItemsCount;

@property (atomic) int16_t checkItemsCountValue;
- (int16_t)checkItemsCountValue;
- (void)setCheckItemsCountValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSDate* dueDate;

@property (nonatomic, strong, nullable) NSDate* lastUpdate;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* position;

@property (atomic) int64_t positionValue;
- (int64_t)positionValue;
- (void)setPositionValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) NSString* uniqueIdentifier;

@property (nonatomic, strong, nullable) NSSet<SDWMActivity*> *activities;
- (nullable NSMutableSet<SDWMActivity*>*)activitiesSet;

@property (nonatomic, strong, nullable) SDWMBoard *board;

@property (nonatomic, strong, nullable) NSSet<SDWMChecklist*> *checklists;
- (nullable NSMutableSet<SDWMChecklist*>*)checklistsSet;

@property (nonatomic, strong, nullable) NSSet<SDWMLabel*> *labels;
- (nullable NSMutableSet<SDWMLabel*>*)labelsSet;

@property (nonatomic, strong, nullable) SDWMList *list;

@property (nonatomic, strong, nullable) NSSet<SDWMUser*> *members;
- (nullable NSMutableSet<SDWMUser*>*)membersSet;

@property (nonatomic, strong, nullable) SDWMUser *user;

@end

@interface _SDWMCard (ActivitiesCoreDataGeneratedAccessors)
- (void)addActivities:(NSSet<SDWMActivity*>*)value_;
- (void)removeActivities:(NSSet<SDWMActivity*>*)value_;
- (void)addActivitiesObject:(SDWMActivity*)value_;
- (void)removeActivitiesObject:(SDWMActivity*)value_;

@end

@interface _SDWMCard (ChecklistsCoreDataGeneratedAccessors)
- (void)addChecklists:(NSSet<SDWMChecklist*>*)value_;
- (void)removeChecklists:(NSSet<SDWMChecklist*>*)value_;
- (void)addChecklistsObject:(SDWMChecklist*)value_;
- (void)removeChecklistsObject:(SDWMChecklist*)value_;

@end

@interface _SDWMCard (LabelsCoreDataGeneratedAccessors)
- (void)addLabels:(NSSet<SDWMLabel*>*)value_;
- (void)removeLabels:(NSSet<SDWMLabel*>*)value_;
- (void)addLabelsObject:(SDWMLabel*)value_;
- (void)removeLabelsObject:(SDWMLabel*)value_;

@end

@interface _SDWMCard (MembersCoreDataGeneratedAccessors)
- (void)addMembers:(NSSet<SDWMUser*>*)value_;
- (void)removeMembers:(NSSet<SDWMUser*>*)value_;
- (void)addMembersObject:(SDWMUser*)value_;
- (void)removeMembersObject:(SDWMUser*)value_;

@end

@interface _SDWMCard (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveCardDescription;
- (void)setPrimitiveCardDescription:(nullable NSString*)value;

- (nullable NSNumber*)primitiveCheckItemsCheckedCount;
- (void)setPrimitiveCheckItemsCheckedCount:(nullable NSNumber*)value;

- (int16_t)primitiveCheckItemsCheckedCountValue;
- (void)setPrimitiveCheckItemsCheckedCountValue:(int16_t)value_;

- (nullable NSNumber*)primitiveCheckItemsCount;
- (void)setPrimitiveCheckItemsCount:(nullable NSNumber*)value;

- (int16_t)primitiveCheckItemsCountValue;
- (void)setPrimitiveCheckItemsCountValue:(int16_t)value_;

- (nullable NSDate*)primitiveDueDate;
- (void)setPrimitiveDueDate:(nullable NSDate*)value;

- (nullable NSDate*)primitiveLastUpdate;
- (void)setPrimitiveLastUpdate:(nullable NSDate*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(nullable NSNumber*)value;

- (int64_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int64_t)value_;

- (nullable NSString*)primitiveTrelloID;
- (void)setPrimitiveTrelloID:(nullable NSString*)value;

- (nullable NSString*)primitiveUniqueIdentifier;
- (void)setPrimitiveUniqueIdentifier:(nullable NSString*)value;

- (NSMutableSet<SDWMActivity*>*)primitiveActivities;
- (void)setPrimitiveActivities:(NSMutableSet<SDWMActivity*>*)value;

- (nullable SDWMBoard*)primitiveBoard;
- (void)setPrimitiveBoard:(nullable SDWMBoard*)value;

- (NSMutableSet<SDWMChecklist*>*)primitiveChecklists;
- (void)setPrimitiveChecklists:(NSMutableSet<SDWMChecklist*>*)value;

- (NSMutableSet<SDWMLabel*>*)primitiveLabels;
- (void)setPrimitiveLabels:(NSMutableSet<SDWMLabel*>*)value;

- (nullable SDWMList*)primitiveList;
- (void)setPrimitiveList:(nullable SDWMList*)value;

- (NSMutableSet<SDWMUser*>*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet<SDWMUser*>*)value;

- (nullable SDWMUser*)primitiveUser;
- (void)setPrimitiveUser:(nullable SDWMUser*)value;

@end

@interface SDWMCardAttributes: NSObject 
+ (NSString *)cardDescription;
+ (NSString *)checkItemsCheckedCount;
+ (NSString *)checkItemsCount;
+ (NSString *)dueDate;
+ (NSString *)lastUpdate;
+ (NSString *)name;
+ (NSString *)position;
+ (NSString *)trelloID;
+ (NSString *)uniqueIdentifier;
@end

@interface SDWMCardRelationships: NSObject
+ (NSString *)activities;
+ (NSString *)board;
+ (NSString *)checklists;
+ (NSString *)labels;
+ (NSString *)list;
+ (NSString *)members;
+ (NSString *)user;
@end

NS_ASSUME_NONNULL_END
