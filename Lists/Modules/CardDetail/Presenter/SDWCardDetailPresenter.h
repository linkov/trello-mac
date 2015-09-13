//
//  SDWCardDetailPresenter.h
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWCardDetailWireframe.h"
#import "SDWCardDetailUserInterface.h"
#import "SDWCardDetailInteractor.h"
#import "SDWCardDetailInteractorIO.h"
#import "SDWCardDetailModuleInterface.h"

@interface SDWCardDetailPresenter : NSObject <SDWCardDetailModuleInterface, SDWCardDetailInteractorOutput>

@property (nonatomic, strong) id <SDWCardDetailInteractorInput>  interactor;
@property (nonatomic, weak) NSViewController <SDWCardDetailUserInterface> *userInterface;
@property (nonatomic, strong) SDWCardDetailWireframe *wireframe;

@end
