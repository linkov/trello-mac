// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMChecklist.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMCard;
@class SDWMChecklistItem;

@interface SDWMChecklistID : NSManagedObjectID {}
@end

@interface _SDWMChecklist : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMChecklistID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* position;

@property (atomic) int64_t positionValue;
- (int64_t)positionValue;
- (void)setPositionValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) NSString* uniqueIdentifier;

@property (nonatomic, strong, nullable) SDWMCard *card;

@property (nonatomic, strong, nullable) NSSet<SDWMChecklistItem*> *items;
- (nullable NSMutableSet<SDWMChecklistItem*>*)itemsSet;

@end

@interface _SDWMChecklist (ItemsCoreDataGeneratedAccessors)
- (void)addItems:(NSSet<SDWMChecklistItem*>*)value_;
- (void)removeItems:(NSSet<SDWMChecklistItem*>*)value_;
- (void)addItemsObject:(SDWMChecklistItem*)value_;
- (void)removeItemsObject:(SDWMChecklistItem*)value_;

@end

@interface _SDWMChecklist (CoreDataGeneratedPrimitiveAccessors)

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

- (SDWMCard*)primitiveCard;
- (void)setPrimitiveCard:(SDWMCard*)value;

- (NSMutableSet<SDWMChecklistItem*>*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet<SDWMChecklistItem*>*)value;

@end

@interface SDWMChecklistAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)position;
+ (NSString *)trelloID;
+ (NSString *)uniqueIdentifier;
@end

@interface SDWMChecklistRelationships: NSObject
+ (NSString *)card;
+ (NSString *)items;
@end

NS_ASSUME_NONNULL_END
