#import "SDWListManaged.h"

@interface SDWListManaged ()

// Private interface goes here.

@end

@implementation SDWListManaged

// Custom logic goes here.

@end

//*********************************************************************//

@implementation SDWListManaged (SourceListTree)

- (BOOL)isLeaf {
    return YES;
}

- (NSArray *)children {
    return nil;
}

- (id)childAtIndex:(NSUInteger)index {
    return nil;
}

- (NSString *)itemName {
    return self.name;
}

@end

//*********************************************************************//


@implementation SDWListManaged (Mapping)


- (instancetype)mappedObjectFromJSON:(NSDictionary *)json {

    self.name = json[@"name"];
    self.listsID = json[@"id"];

    return self;
}

@end


