//
//  SDWCardDetailInteractor.h
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWCardDetailInteractorIO.h"

@interface SDWCardDetailInteractor : NSObject <SDWCardDetailInteractorInput>

@property (nonatomic, weak) id<SDWCardDetailInteractorOutput> output;

@end
