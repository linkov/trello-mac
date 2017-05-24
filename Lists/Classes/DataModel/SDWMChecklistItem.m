#import "SDWMChecklistItem.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

@interface SDWMChecklistItem ()

// Private interface goes here.

@end

@implementation SDWMChecklistItem

// Custom logic goes here.

@end

@implementation SDWMChecklistItem (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMChecklistItem"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"position" keyPath:@"pos"];
    [mapping addAttributeWithProperty:@"state" keyPath:@"state"];
    
    
    return mapping;
}


@end
