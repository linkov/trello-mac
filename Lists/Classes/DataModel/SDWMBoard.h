#import "_SDWMBoard.h"
#import "SDWObjectMapping.h"

@interface SDWMBoard : _SDWMBoard

- (NSString *)boardID;
- (NSArray *)labels;
@end


@interface SDWMBoard (Mapping) <SDWObjectMapping>

@end
