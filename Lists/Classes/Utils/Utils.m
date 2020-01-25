//
//  Utils.m
//  Lists
//
//  Created by alex on 11/8/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "Utils.h"


#import "SDWDataModelManager.h"
#import "SDWMBoard.h"
#import "SDWBoardDisplayItem.h"
#import "SDWLabelDisplayItem.h"


@implementation Utils

+ (NSString *)twoLetterIDFromName:(NSString *)name {

    NSArray *nameArr = [name componentsSeparatedByString:@" "];
    NSString *finalString;

    NSString *firstName = nameArr[0];

    if (nameArr.count>1) {

        NSString *lastName = nameArr[1];

        NSMutableArray *firstNameArr = [NSMutableArray new];

        [firstName enumerateSubstringsInRange: NSMakeRange(0,firstName.length)
                                      options: NSStringEnumerationByComposedCharacterSequences
                                   usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){

                                       [firstNameArr addObject: substring];
                                   }
         ];

        NSMutableArray *lastNameArr = [NSMutableArray new];

        [lastName enumerateSubstringsInRange: NSMakeRange(0,lastName.length)
                                     options: NSStringEnumerationByComposedCharacterSequences
                                  usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){

                                      [lastNameArr addObject: substring];
                                  }
         ];

        finalString = [NSString stringWithFormat:@"%@%@",firstNameArr[0],lastNameArr[0]];
    }
    else {

        finalString = @"";
    }
    
    
    return [finalString uppercaseString];
}

+ (NSDate *)stringToDate:(NSString *)string {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormat setLocale:[NSLocale currentLocale]];

    id dateIsNull = string;

    if (dateIsNull != [NSNull null]) {
        return [dateFormat dateFromString:string];
    }
    
    return nil;


}
+ (NSString *)dateToString:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    return [dateFormatter stringFromDate:date];
}

+ (NSMenuItem *)itemForCardLabelsMenuWithColorString:(NSString *)color {

    NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(2, 5, 5, 5)];

    NSMenuItem *item = [[NSMenuItem alloc]init];
    item.title = color;
    item.image = [NSImage imageFromBezierPath:ovalPath color:[SharedSettings colorForTrelloColor:color]];
    return item;
}


+ (NSMenuItem *)itemForCardLabelsMenuWithColorString:(NSString *)color name:(NSString *)name {

    NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(2, 5, 5, 5)];

    NSMenuItem *item = [[NSMenuItem alloc]init];
    item.title = name;
    item.image = [NSImage imageFromBezierPath:ovalPath color:[SharedSettings colorForTrelloColor:color]];
    return item;
}

+ (NSMenuItem *)itemForCardLabelsMenuWithHour:(NSNumber *)hour {
    
    NSMenuItem *item = [[NSMenuItem alloc]init];
    item.title = [NSString stringWithFormat:@"%@",hour];
    item.image = [NSImage imageNamed:@"dueSortDes"];
    return item;
}


+ (NSMenu *)labelsMenuForBoard:(NSString *)trelloID {

    NSMenu *menu = [[NSMenu alloc]init];
    menu.minimumWidth = 250.0;
    
    SDWMBoard *brd = [[SDWDataModelManager manager] fetchEntityForName:SDWMBoard.entityName withTrelloID:trelloID inContext:[SDWDataModelManager manager].managedObjectContext];
    SDWBoardDisplayItem *displayModel = [[SDWBoardDisplayItem alloc] initWithModel: brd];

    for (SDWLabelDisplayItem *lab in displayModel.labels) {

        NSMenuItem *label = [Utils itemForCardLabelsMenuWithColorString:lab.color name:lab.name.length > 0 ? lab.name : lab.color];
        [menu addItem:label];
    }


    return menu;
}

@end
