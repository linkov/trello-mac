//
//  SDWCardsListPresenter.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

#import "SDWCardsListUserInterface.h"
#import "SDWCardsListWireframe.h"
#import "SDWCardsListInteractorIO.h"
#import "SDWCardsListModuleInterface.h"

@interface SDWCardsListPresenter : NSObject <SDWCardsListModuleInterface,SDWCardsListInteractorOutput>

@property (nonatomic, strong) id <SDWCardsListInteractorInput>  listInteractor;
@property (nonatomic, weak) NSViewController <SDWCardsListUserInterface> *userInterface;
@property (nonatomic, strong) SDWCardsListWireframe *wireframe;

@end
