#import "SDWMActivity.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

@interface SDWMActivity ()

// Private interface goes here.

@end

@implementation SDWMActivity

- (void)awakeFromInsert {
    [super awakeFromInsert];
    if (!self.uniqueIdentifier) {
        self.uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
    }
}

@end


@implementation SDWMActivity (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMActivity"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"content" keyPath:@"data.text"];
    [mapping addAttributeWithProperty:@"memberInitials" keyPath:@"memberCreator.initials"];
    [mapping addAttribute:[FEMAttribute dateAttributeWithProperty:@"time" keyPath:@"date"]];
    return mapping;
}



@end
