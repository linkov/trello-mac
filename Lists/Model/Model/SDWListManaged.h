
#import "_SDWListManaged.h"
#import "SDWSourceListItem.h"

@interface SDWListManaged : _SDWListManaged {}
// Custom logic goes here.
@end


@interface SDWListManaged (SourceListTree) <SDWSourceListItem>

@end