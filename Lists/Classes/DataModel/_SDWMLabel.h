// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SDWMLabel.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class SDWMCard;

@interface SDWMLabelID : NSManagedObjectID {}
@end

@interface _SDWMLabel : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SDWMLabelID *objectID;

@property (nonatomic, strong, nullable) NSString* color;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* trelloID;

@property (nonatomic, strong, nullable) SDWMCard *card;

@end

@interface _SDWMLabel (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveColor;
- (void)setPrimitiveColor:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveTrelloID;
- (void)setPrimitiveTrelloID:(nullable NSString*)value;

- (SDWMCard*)primitiveCard;
- (void)setPrimitiveCard:(SDWMCard*)value;

@end

@interface SDWMLabelAttributes: NSObject 
+ (NSString *)color;
+ (NSString *)name;
+ (NSString *)trelloID;
@end

@interface SDWMLabelRelationships: NSObject
+ (NSString *)card;
@end

NS_ASSUME_NONNULL_END
