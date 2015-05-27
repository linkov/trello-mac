//
//  SDWCardsListInteractor.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWCardsListInteractorIO.h"

@interface SDWCardsListInteractor : NSObject <SDWCardsListInteractorInput>

@property (nonatomic, weak) id<SDWCardsListInteractorOutput> output;

@end
