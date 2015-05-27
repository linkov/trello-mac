//
//  SDWBoardsListInteractor.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWBoardsListInteractorIO.h"

@interface SDWBoardsListInteractor : NSObject <SDWBoardsListInteractorInput>

@property (nonatomic, weak) id<SDWBoardsListInteractorOutput> output;

@end
