// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMBoard.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMCard;
@class SDWMLabel;
@class SDWMList;
@class SDWMUser;
@class SDWMUser;

@interface SDWMBoardID : NSManagedObjectID {}
@end

@interface _SDWMBoard : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMBoardID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* position;

@property (atomic) int16_t positionValue;
- (int16_t)positionValue;
- (void)setPositionValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSNumber* starred;

@property (atomic) BOOL starredValue;
- (BOOL)starredValue;
- (void)setStarredValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) NSString* uniqueIdentifier;

@property (nonatomic, strong, nullable) NSSet<SDWMCard*> *cards;
- (nullable NSMutableSet<SDWMCard*>*)cardsSet;

@property (nonatomic, strong, nullable) NSSet<SDWMLabel*> *labels;
- (nullable NSMutableSet<SDWMLabel*>*)labelsSet;

@property (nonatomic, strong, nullable) NSSet<SDWMList*> *lists;
- (nullable NSMutableSet<SDWMList*>*)listsSet;

@property (nonatomic, strong, nullable) NSSet<SDWMUser*> *members;
- (nullable NSMutableSet<SDWMUser*>*)membersSet;

@property (nonatomic, strong, nullable) SDWMUser *user;

@end

@interface _SDWMBoard (CardsCoreDataGeneratedAccessors)
- (void)addCards:(NSSet<SDWMCard*>*)value_;
- (void)removeCards:(NSSet<SDWMCard*>*)value_;
- (void)addCardsObject:(SDWMCard*)value_;
- (void)removeCardsObject:(SDWMCard*)value_;

@end

@interface _SDWMBoard (LabelsCoreDataGeneratedAccessors)
- (void)addLabels:(NSSet<SDWMLabel*>*)value_;
- (void)removeLabels:(NSSet<SDWMLabel*>*)value_;
- (void)addLabelsObject:(SDWMLabel*)value_;
- (void)removeLabelsObject:(SDWMLabel*)value_;

@end

@interface _SDWMBoard (ListsCoreDataGeneratedAccessors)
- (void)addLists:(NSSet<SDWMList*>*)value_;
- (void)removeLists:(NSSet<SDWMList*>*)value_;
- (void)addListsObject:(SDWMList*)value_;
- (void)removeListsObject:(SDWMList*)value_;

@end

@interface _SDWMBoard (MembersCoreDataGeneratedAccessors)
- (void)addMembers:(NSSet<SDWMUser*>*)value_;
- (void)removeMembers:(NSSet<SDWMUser*>*)value_;
- (void)addMembersObject:(SDWMUser*)value_;
- (void)removeMembersObject:(SDWMUser*)value_;

@end

@interface _SDWMBoard (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(nullable NSNumber*)value;

- (int16_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int16_t)value_;

- (nullable NSNumber*)primitiveStarred;
- (void)setPrimitiveStarred:(nullable NSNumber*)value;

- (BOOL)primitiveStarredValue;
- (void)setPrimitiveStarredValue:(BOOL)value_;

- (nullable NSString*)primitiveTrelloID;
- (void)setPrimitiveTrelloID:(nullable NSString*)value;

- (nullable NSString*)primitiveUniqueIdentifier;
- (void)setPrimitiveUniqueIdentifier:(nullable NSString*)value;

- (NSMutableSet<SDWMCard*>*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet<SDWMCard*>*)value;

- (NSMutableSet<SDWMLabel*>*)primitiveLabels;
- (void)setPrimitiveLabels:(NSMutableSet<SDWMLabel*>*)value;

- (NSMutableSet<SDWMList*>*)primitiveLists;
- (void)setPrimitiveLists:(NSMutableSet<SDWMList*>*)value;

- (NSMutableSet<SDWMUser*>*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet<SDWMUser*>*)value;

- (nullable SDWMUser*)primitiveUser;
- (void)setPrimitiveUser:(nullable SDWMUser*)value;

@end

@interface SDWMBoardAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)position;
+ (NSString *)starred;
+ (NSString *)trelloID;
+ (NSString *)uniqueIdentifier;
@end

@interface SDWMBoardRelationships: NSObject
+ (NSString *)cards;
+ (NSString *)labels;
+ (NSString *)lists;
+ (NSString *)members;
+ (NSString *)user;
@end

NS_ASSUME_NONNULL_END
