#import "SDWMUser.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

@interface SDWMUser ()

// Private interface goes here.

@end

@implementation SDWMUser

- (void)awakeFromInsert {
    [super awakeFromInsert];
    if (!self.uniqueIdentifier) {
        self.uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
    }
}

@end


@implementation SDWMUser (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMUser"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
//    [mapping addAttributeWithProperty:@"status" keyPath:@"status"];
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    return mapping;
}


@end
