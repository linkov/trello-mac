#import "SDWMBoard.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

#import "SDWMList.h"
#import "SDWMLabel.h"
#import "SDWMUser.h"
@interface SDWMBoard ()



@end

@implementation SDWMBoard

- (NSString *)boardID {
    return self.trelloID;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    if (!self.uniqueIdentifier) {
        self.uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
    }
}

@end


@implementation SDWMBoard (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMBoard"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"starred" keyPath:@"starred"];
    
    [mapping addToManyRelationshipMapping:[SDWMList defaultMapping] forProperty:@"lists" keyPath:@"lists"];
    [mapping addToManyRelationshipMapping:[SDWMLabel defaultMapping] forProperty:@"labels" keyPath:@"labels"];
    [mapping addToManyRelationshipMapping:[SDWMUser defaultMapping] forProperty:@"members" keyPath:@"members"];
    return mapping;
}


@end
