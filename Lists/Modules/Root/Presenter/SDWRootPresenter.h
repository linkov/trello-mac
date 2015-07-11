//
//  CNIRootPresenter.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

#import "SDWRootUserInterface.h"
#import "SDWRootWireframe.h"
#import "SDWRootModuleInterface.h"

@interface SDWRootPresenter : NSObject <SDWRootModuleInterface>

@property (nonatomic, weak) NSViewController<SDWRootUserInterface> *userInterface;
@property (nonatomic, strong) SDWRootWireframe *wireframe;

@end
