
#import "_SDWBoardManaged.h"
#import "SDWSourceListItem.h"
#import "SDWJSONMapping.h"

@interface SDWBoardManaged : _SDWBoardManaged {}
// Custom logic goes here.
@end

@interface SDWBoardManaged (SourceListTree) <SDWSourceListItem>

@end

@interface SDWBoardManaged (Mapping) <SDWJSONMapping>

@end