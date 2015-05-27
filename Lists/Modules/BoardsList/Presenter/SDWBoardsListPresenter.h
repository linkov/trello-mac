//
//  SDWBoardsListPresenter.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;
#import "SDWBoardsListUserInterface.h"
#import "SDWBoardsListModuleInterface.h"
#import "SDWBoardsListInteractorIO.h"

@class SDWBoardsListWireframe;

@interface SDWBoardsListPresenter : NSObject <SDWBoardsListModuleInterface, SDWBoardsListInteractorOutput>

@property (nonatomic, strong) id <SDWBoardsListInteractorInput>  listInteractor;
@property (nonatomic, weak) NSViewController <SDWBoardsListUserInterface> *userInterface;
@property (nonatomic, strong) SDWBoardsListWireframe *wireframe;

@end
