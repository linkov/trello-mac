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

- (NSArray *)members {
    return [NSArray array];
}

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
    

    
    FEMMapping *listMapping = [[FEMMapping alloc]initWithEntityName:@"SDWMList"];
    listMapping.primaryKey = @"trelloID";
    [listMapping addAttributeWithProperty:@"trelloID" keyPath:nil];
    
    FEMRelationship *listRelationship = [[FEMRelationship alloc]initWithProperty:@"list" keyPath:@"idList" mapping:listMapping];
    listRelationship.weak = YES;
    [mapping addRelationship:listRelationship];
    
    
    

    return mapping;
}


@end
