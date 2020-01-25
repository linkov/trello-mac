// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMChecklistItem.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMChecklist;

@interface SDWMChecklistItemID : NSManagedObjectID {}
@end

@interface _SDWMChecklistItem : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMChecklistItemID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* position;

@property (atomic) int64_t positionValue;
- (int64_t)positionValue;
- (void)setPositionValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* state;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) NSString* uniqueIdentifier;

@property (nonatomic, strong, nullable) SDWMChecklist *checklist;

@end

@interface _SDWMChecklistItem (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(nullable NSNumber*)value;

- (int64_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int64_t)value_;

- (nullable NSString*)primitiveState;
- (void)setPrimitiveState:(nullable NSString*)value;

- (nullable NSString*)primitiveTrelloID;
- (void)setPrimitiveTrelloID:(nullable NSString*)value;

- (nullable NSString*)primitiveUniqueIdentifier;
- (void)setPrimitiveUniqueIdentifier:(nullable NSString*)value;

- (nullable SDWMChecklist*)primitiveChecklist;
- (void)setPrimitiveChecklist:(nullable SDWMChecklist*)value;

@end

@interface SDWMChecklistItemAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)position;
+ (NSString *)state;
+ (NSString *)trelloID;
+ (NSString *)uniqueIdentifier;
@end

@interface SDWMChecklistItemRelationships: NSObject
+ (NSString *)checklist;
@end

NS_ASSUME_NONNULL_END
