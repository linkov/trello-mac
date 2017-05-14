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

    return mapping;
}


@end
