#import "_SDWMCard.h"
#import "SDWObjectMapping.h"

@interface SDWMCard : _SDWMCard

- (NSArray *)displayLabels;
- (NSArray *)members;

- (NSString *)cardID;
- (NSString *)boardID;

- (BOOL)hasOpenTodos;

@end



@interface SDWMCard (Mapping) <SDWObjectMapping>

@end
