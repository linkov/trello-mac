
#import "SDWBoardManaged.h"
#import "SDWMapper.h"
#import "SDWListManaged.h"

@interface SDWBoardManaged ()

// Private interface goes here.

@end

@implementation SDWBoardManaged

// Custom logic goes here.

@end

//*********************************************************************//

@implementation SDWBoardManaged (SourceListTree)

- (BOOL)isLeaf {
    return NO;
}

- (NSArray *)children {
    return [self.lists allObjects];
}

- (id)childAtIndex:(NSUInteger)index {
    return [[self.lists allObjects] objectAtIndex:index];
}

- (NSString *)itemName {
    return self.name;
}

@end

//*********************************************************************//

@implementation SDWBoardManaged (Mapping)

- (instancetype)mappedObjectFromJSON:(NSDictionary *)json {
    self.name = json[@"name"];
    self.listsID = json[@"id"];
    self.isStarred = json[@"starred"];
    //  self.updatedAt = json

    if (json[@"lists"]) {
        NSArray *lists = [SDWMapper arrayOfObjectsOfClass:[SDWListManaged class] fromJSON:json[@"lists"]];
        [self.listsSet addObjectsFromArray:lists];
    }

    return self;
}

@end