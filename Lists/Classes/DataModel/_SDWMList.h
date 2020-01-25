// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMList.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMBoard;
@class SDWMCard;

@interface SDWMListID : NSManagedObjectID {}
@end

@interface _SDWMList : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMListID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* position;

@property (atomic) int64_t positionValue;
- (int64_t)positionValue;
- (void)setPositionValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) NSString* uniqueIdentifier;

@property (nonatomic, strong, nullable) SDWMBoard *board;

@property (nonatomic, strong, nullable) NSSet<SDWMCard*> *cards;
- (nullable NSMutableSet<SDWMCard*>*)cardsSet;

@end

@interface _SDWMList (CardsCoreDataGeneratedAccessors)
- (void)addCards:(NSSet<SDWMCard*>*)value_;
- (void)removeCards:(NSSet<SDWMCard*>*)value_;
- (void)addCardsObject:(SDWMCard*)value_;
- (void)removeCardsObject:(SDWMCard*)value_;

@end

@interface _SDWMList (CoreDataGeneratedPrimitiveAccessors)

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

- (nullable SDWMBoard*)primitiveBoard;
- (void)setPrimitiveBoard:(nullable SDWMBoard*)value;

- (NSMutableSet<SDWMCard*>*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet<SDWMCard*>*)value;

@end

@interface SDWMListAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)position;
+ (NSString *)trelloID;
+ (NSString *)uniqueIdentifier;
@end

@interface SDWMListRelationships: NSObject
+ (NSString *)board;
+ (NSString *)cards;
@end

NS_ASSUME_NONNULL_END
