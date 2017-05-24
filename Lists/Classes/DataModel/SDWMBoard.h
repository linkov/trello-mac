#import "_SDWMBoard.h"
#import "SDWObjectMapping.h"

@interface SDWMBoard : _SDWMBoard

- (NSString *)boardID;

@end


@interface SDWMBoard (Mapping) <SDWObjectMapping>

@end
