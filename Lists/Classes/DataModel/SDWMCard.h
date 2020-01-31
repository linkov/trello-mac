#import "_SDWMCard.h"
#import "SDWObjectMapping.h"

@interface SDWMCard : _SDWMCard

- (NSArray *)displayLabels;
- (NSString *)cardID;

@end



@interface SDWMCard (Mapping) <SDWObjectMapping>

@end
