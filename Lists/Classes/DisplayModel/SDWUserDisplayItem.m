//
//  SDWUserDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWUserDisplayItem.h"
#import "SDWMUser.h"

@interface SDWUserDisplayItem ()

@property (readwrite) SDWMUser *model;

@end

@implementation SDWUserDisplayItem

- (instancetype)initWithModel:(SDWMUser *)model {
    NSParameterAssert(model);
    self = [super init];
    
    if (self) {
        self.model = model;
        self.trelloID = model.trelloID;
        self.name = model.name;
        self.initials = model.initials;
        
        
        
    }
    return self;
    
}

- (NSString *)twoLetterIDFromName:(NSString *)name {
    
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

@end


