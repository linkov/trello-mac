//
//  SDWObjectMapping.h
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//
@import Foundation;

#import <FastEasyMapping/FastEasyMapping.h>


NS_ASSUME_NONNULL_BEGIN

@protocol SDWObjectMapping <NSObject>

+ (FEMMapping *)defaultMapping;

@end

NS_ASSUME_NONNULL_END
