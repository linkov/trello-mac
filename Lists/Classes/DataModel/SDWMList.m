#import "SDWMList.h"
#import "SDWMappingConstants.h"
#import "FEMAttribute+listsAttributes.h"

@interface SDWMList ()

// Private interface goes here.

@end

@implementation SDWMList

// Custom logic goes here.

@end


@implementation SDWMList (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"SDWMList"];
    mapping.primaryKey = SDWMappingDefaultPrimaryKey;
    [mapping addAttribute:[FEMAttribute listsIDAttribute]];
    [mapping addAttributeWithProperty:@"name" keyPath:@"name"];
    [mapping addAttributeWithProperty:@"position" keyPath:@"pos"];
    return mapping;
}


@end



@implementation SDWMList (TreeView)

- (BOOL)isLeaf {
    return YES;
}

- (NSArray *)children {
    return nil;
}

@end
