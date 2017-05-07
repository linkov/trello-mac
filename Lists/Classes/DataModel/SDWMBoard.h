#import "_SDWMBoard.h"
#import "SDWObjectMapping.h"
#import "SDWTreeView.h"

@interface SDWMBoard : _SDWMBoard

- (NSString *)boardID;

@end


@interface SDWMBoard (Mapping) <SDWObjectMapping>

@end


@interface SDWMBoard (TreeView) <SDWTreeView>

@end
