//
//  Utils.m
//  Lists
//
//  Created by alex on 11/8/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "Utils.h"


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

+ (NSMenuItem *)itemForCardLabelsMenuWithHour:(NSNumber *)hour {
    
    NSMenuItem *item = [[NSMenuItem alloc]init];
    item.title = [NSString stringWithFormat:@"%@",hour];
    item.image = [NSImage imageNamed:@"dueSortDes"];
    return item;
}


+ (NSMenu *)labelsMenu {

    NSMenu *menu = [[NSMenu alloc]init];
    menu.minimumWidth = 250.0;

    NSMenuItem *greenLabel = [Utils itemForCardLabelsMenuWithColorString:@"green"];
    [menu addItem:greenLabel];

    NSMenuItem *redLabel = [Utils itemForCardLabelsMenuWithColorString:@"red"];
    [menu addItem:redLabel];

    NSMenuItem *yellowLabel = [Utils itemForCardLabelsMenuWithColorString:@"yellow"];
    [menu addItem:yellowLabel];

    NSMenuItem *blueLabel = [Utils itemForCardLabelsMenuWithColorString:@"blue"];
    [menu addItem:blueLabel];

    NSMenuItem *purpleLabel = [Utils itemForCardLabelsMenuWithColorString:@"purple"];
    [menu addItem:purpleLabel];

    NSMenuItem *orangeLabel = [Utils itemForCardLabelsMenuWithColorString:@"orange"];
    [menu addItem:orangeLabel];

    NSMenuItem *separator = [NSMenuItem separatorItem];
    [menu addItem:separator];

    NSMenuItem *blackLabel = [Utils itemForCardLabelsMenuWithColorString:@"black"];
    [menu addItem:blackLabel];

    NSMenuItem *limeLabel = [Utils itemForCardLabelsMenuWithColorString:@"lime"];
    [menu addItem:limeLabel];

    NSMenuItem *skyLabel = [Utils itemForCardLabelsMenuWithColorString:@"sky"];
    [menu addItem:skyLabel];

    NSMenuItem *pinkLabel = [Utils itemForCardLabelsMenuWithColorString:@"pink"];
    [menu addItem:pinkLabel];

    return menu;
}

@end
