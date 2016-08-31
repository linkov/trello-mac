//
//  SDWddNamedItemVC.h
//  Lists
//
//  Created by alex on 8/31/16.
//  Copyright © 2016 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Utils.h"
#import "SDWMainSplitController.h"

@interface SDWAddNamedItemVC : NSViewController

@property (strong) NSString *titleString;
@property (weak) SDWMainSplitController *delegate;


@end
