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

@interface SDWModalEditVC : NSViewController

@property (strong) NSString *valueString;
@property (strong) NSString *titleString;
@property (weak) SDWMainSplitController *delegate;


@end
