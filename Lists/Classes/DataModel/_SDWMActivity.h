// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMActivity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMCard;

@interface SDWMActivityID : NSManagedObjectID {}
@end

@interface _SDWMActivity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMActivityID *objectID;

@property (nonatomic, strong, nullable) NSString* content;

@property (nonatomic, strong, nullable) NSString* memberInitials;

@property (nonatomic, strong, nullable) NSDate* time;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) SDWMCard *card;

@end

@interface _SDWMActivity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveContent;
- (void)setPrimitiveContent:(nullable NSString*)value;

- (nullable NSString*)primitiveMemberInitials;
- (void)setPrimitiveMemberInitials:(nullable NSString*)value;

- (nullable NSDate*)primitiveTime;
- (void)setPrimitiveTime:(nullable NSDate*)value;

- (nullable NSString*)primitiveTrelloID;
- (void)setPrimitiveTrelloID:(nullable NSString*)value;

- (SDWMCard*)primitiveCard;
- (void)setPrimitiveCard:(SDWMCard*)value;

@end

@interface SDWMActivityAttributes: NSObject 
+ (NSString *)content;
+ (NSString *)memberInitials;
+ (NSString *)time;
+ (NSString *)trelloID;
@end

@interface SDWMActivityRelationships: NSObject
+ (NSString *)card;
@end

NS_ASSUME_NONNULL_END
