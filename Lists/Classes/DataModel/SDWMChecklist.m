#import "SDWMChecklist.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

#import "SDWMChecklistItem.h"

@interface SDWMChecklist ()

// Private interface goes here.

@end

@implementation SDWMChecklist


- (void)awakeFromInsert {
    [super awakeFromInsert];
    if (!self.uniqueIdentifier) {
        self.uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
    }
}

@end

@implementation SDWMChecklist (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMChecklist"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"position" keyPath:@"pos"];

    [mapping addToManyRelationshipMapping:[SDWMChecklistItem defaultMapping] forProperty:@"items" keyPath:@"checkItems"];
    
    return mapping;
}


@end
