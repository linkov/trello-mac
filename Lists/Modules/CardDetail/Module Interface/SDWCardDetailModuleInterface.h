//
//  SDWCardDetailModuleInterface.h
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDWCardDetailModuleInterface <NSObject>

- (void)updateUserInterface;

- (void)revealPanel;
- (void)hidePanel;

@end