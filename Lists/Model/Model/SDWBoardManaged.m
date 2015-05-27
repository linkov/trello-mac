
#import "SDWBoardManaged.h"

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