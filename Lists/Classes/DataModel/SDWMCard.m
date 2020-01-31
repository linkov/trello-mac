#import "SDWMCard.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

#import "SDWMLabel.h"
#import "SDWMBoard.h"
#import "SDWMUser.h"

@interface SDWMCard ()

// Private interface goes here.

@end

@implementation SDWMCard

- (NSArray *)displayLabels {
    return self.labels.allObjects;
}

- (NSString *)cardID {
    return self.trelloID;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    if (!self.uniqueIdentifier) {
        self.uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
    }
}


@end

@implementation SDWMCard (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMCard"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"cardDescription" keyPath:@"desc"];
    [mapping addAttributeWithProperty:@"position" keyPath:@"pos"];
    [mapping addAttributeWithProperty:@"checkItemsCount" keyPath:@"badges.checkItems"];
    [mapping addAttributeWithProperty:@"checkItemsCheckedCount" keyPath:@"badges.checkItemsChecked"];
    [mapping addAttribute:[FEMAttribute dateAttributeWithProperty:@"dueDate" keyPath:@"due"]];
    [mapping addToManyRelationshipMapping:[SDWMLabel defaultMapping] forProperty:@"labels" keyPath:@"labels"];
//    [mapping addToManyRelationshipMapping:[SDWMUser defaultMapping] forProperty:@"members" keyPath:@"members"];
    

    
    FEMMapping *listMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMList"];
    listMapping.primaryKey = @"trelloID";
    [listMapping addAttributeWithProperty:@"trelloID" keyPath:nil];
    
    FEMRelationship *listRelationship = [[FEMRelationship alloc]initWithProperty:@"list" keyPath:@"idList" mapping:listMapping];
    listRelationship.weak = YES;
    [mapping addRelationship:listRelationship];
    
    
    
//    FEMMapping *bMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMBoard"];
//    bMapping.primaryKey = @"trelloID";
//    [bMapping addAttributeWithProperty:@"trelloID" keyPath:nil];
//    
//    FEMRelationship *bRelationship = [[FEMRelationship alloc]initWithProperty:@"board" keyPath:@"idBoard" mapping:bMapping];
//    bRelationship.weak = YES;
//    [mapping addRelationship:bRelationship];
    

    FEMMapping *userMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMUser"];
    userMapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [userMapping addAttribute:[FEMAttribute listsIDAttribute]];
    [userMapping addAttributeWithProperty:@"name" keyPath:@"fullName"];
    [userMapping addAttributeWithProperty:@"initials" keyPath:@"initials"];
    
    FEMRelationship *userRelationship = [[FEMRelationship alloc]initWithProperty:@"members" keyPath:@"members" mapping:userMapping];
    userRelationship.weak = YES;
    [userRelationship setToMany:YES];
    [mapping addRelationship:userRelationship];

    
    
    
    return mapping;
}


@end
