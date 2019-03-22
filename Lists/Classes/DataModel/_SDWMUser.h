// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMUser.h instead.

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

@interface SDWMUserID : NSManagedObjectID {}
@end

@interface _SDWMUser : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMUserID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) NSString* uniqueIdentifier;

@property (nonatomic, strong, nullable) NSSet<SDWMBoard*> *boards;
- (nullable NSMutableSet<SDWMBoard*>*)boardsSet;

@property (nonatomic, strong, nullable) NSSet<SDWMCard*> *cards;
- (nullable NSMutableSet<SDWMCard*>*)cardsSet;

@end

@interface _SDWMUser (BoardsCoreDataGeneratedAccessors)
- (void)addBoards:(NSSet<SDWMBoard*>*)value_;
- (void)removeBoards:(NSSet<SDWMBoard*>*)value_;
- (void)addBoardsObject:(SDWMBoard*)value_;
- (void)removeBoardsObject:(SDWMBoard*)value_;

@end

@interface _SDWMUser (CardsCoreDataGeneratedAccessors)
- (void)addCards:(NSSet<SDWMCard*>*)value_;
- (void)removeCards:(NSSet<SDWMCard*>*)value_;
- (void)addCardsObject:(SDWMCard*)value_;
- (void)removeCardsObject:(SDWMCard*)value_;

@end

@interface _SDWMUser (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveTrelloID;
- (void)setPrimitiveTrelloID:(nullable NSString*)value;

- (nullable NSString*)primitiveUniqueIdentifier;
- (void)setPrimitiveUniqueIdentifier:(nullable NSString*)value;

- (NSMutableSet<SDWMBoard*>*)primitiveBoards;
- (void)setPrimitiveBoards:(NSMutableSet<SDWMBoard*>*)value;

- (NSMutableSet<SDWMCard*>*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet<SDWMCard*>*)value;

@end

@interface SDWMUserAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)trelloID;
+ (NSString *)uniqueIdentifier;
@end

@interface SDWMUserRelationships: NSObject
+ (NSString *)boards;
+ (NSString *)cards;
@end

NS_ASSUME_NONNULL_END
