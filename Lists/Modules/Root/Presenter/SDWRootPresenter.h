//
//  CNIRootPresenter.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

#import "CNIRootUserInterface.h"

@interface SDWRootPresenter : NSObject

@property (nonatomic, weak) NSViewController<CNIRootUserInterface> *userInterface;
@property (nonatomic, strong) SDWRootWireframe *wireframe;

@end
