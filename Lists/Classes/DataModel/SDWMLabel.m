#import "SDWMLabel.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

@interface SDWMLabel ()

// Private interface goes here.

@end

@implementation SDWMLabel

// Custom logic goes here.

@end


@implementation SDWMLabel (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMLabel"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"color" keyPath:@"color"];
    
    return mapping;
}


@end
