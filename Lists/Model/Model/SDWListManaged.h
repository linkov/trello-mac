
#import "_SDWListManaged.h"
#import "SDWSourceListItem.h"
#import "SDWJSONMapping.h"

@interface SDWListManaged : _SDWListManaged {}
// Custom logic goes here.
@end

@interface SDWListManaged (SourceListTree) <SDWSourceListItem>

@end

@interface SDWListManaged (Mapping) <SDWJSONMapping>

@end