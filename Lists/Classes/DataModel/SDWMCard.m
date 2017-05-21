#import "SDWMCard.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

#import "SDWMLabel.h"
#import "SDWMBoard.h"

@interface SDWMCard ()

// Private interface goes here.

@end

@implementation SDWMCard

- (NSArray *)members {
    return [NSArray array];
}

- (NSArray *)displayLabels {
    return self.labels.allObjects;
}

- (NSString *)cardID {
    return self.trelloID;
}
- (NSString *)boardID {
    return self.board.trelloID;
}

- (BOOL)hasOpenTodos {
    if (self.checkItemsCountValue - self.checkItemsCheckedCountValue > 0) {
        return YES;
    } else {
        return NO;
    }
    
}



@end

@implementation SDWMCard (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMCard"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"cardDescription" keyPath:@"description"];
    [mapping addAttributeWithProperty:@"position" keyPath:@"pos"];
    [mapping addAttributeWithProperty:@"checkItemsCount" keyPath:@"badges.checkItems"];
    [mapping addAttributeWithProperty:@"checkItemsCheckedCount" keyPath:@"badges.checkItemsChecked"];
    [mapping addAttribute:[FEMAttribute dateAttributeWithProperty:@"dueDate" keyPath:@"due"]];
    [mapping addToManyRelationshipMapping:[SDWMLabel defaultMapping] forProperty:@"labels" keyPath:@"labels"];
    
//    FEMAttribute *conichiID = [[FEMAttribute alloc] initWithProperty:@"members" keyPath:@"idMembers" map:^id (id value) {
//        NSString *guestID_prefereceID;
//
//        return guestID_prefereceID;
//    } reverseMap:^id (id value) {
//        return nil;
//    }];
//    
//    [mapping addAttribute:conichiID];
//    
//    FEMMapping *mm = [FEMMapping alloc]initWithEntityName:<#(nonnull NSString *)#> rootPath:<#(nullable NSString *)#>
    
    

//    FEMMapping *membersMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMUser"];
//    membersMapping.primaryKey = SDWMappingDefaultPrimaryKey;
////    [membersMapping addAttribute:[FEMAttribute listsIDAttribute] ];
//    [membersMapping addAttributeWithProperty:@"trelloID" keyPath:nil];
//
//    
//    FEMRelationship *membersRelationship = [[FEMRelationship alloc]initWithProperty:@"members" keyPath:@"idMembers" mapping:membersMapping];
//    membersRelationship.weak = YES;
//    membersRelationship.toMany = YES;
//    [mapping addRelationship:membersRelationship];
    
//    FEMMapping *listMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMList"];
//    listMapping.primaryKey = @"remoteID";
//    [listMapping addAttributeWithProperty:@"remoteID" keyPath:nil];
//    
//    FEMRelationship *listRelationship = [[FEMRelationship alloc]initWithProperty:@"list" keyPath:@"idList" mapping:listMapping];
//    listRelationship.weak = YES;
//    [mapping addRelationship:listRelationship];
//    
//    FEMMapping *boardMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMBoard"];
//    boardMapping.primaryKey = @"remoteID";
//    [boardMapping addAttributeWithProperty:@"remoteID" keyPath:nil];
//    
//    FEMRelationship *boardRelationship = [[FEMRelationship alloc]initWithProperty:@"board" keyPath:@"idBoard" mapping:boardMapping];
//    boardRelationship.weak = YES;
//    [mapping addRelationship:boardRelationship];
    
    

    return mapping;
}


@end
