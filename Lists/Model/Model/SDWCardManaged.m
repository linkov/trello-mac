
#import "SDWCardManaged.h"

@interface SDWCardManaged ()

// Private interface goes here.

@end

@implementation SDWCardManaged

// Custom logic goes here.

@end

//*********************************************************************//

@implementation SDWCardManaged (Mapping)

- (instancetype)mappedObjectFromJSON:(NSDictionary *)json {
    self.name = json[@"name"];
    self.listsID = json[@"id"];

    return self;
}

@end