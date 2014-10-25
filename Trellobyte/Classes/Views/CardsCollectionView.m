//
//  CardsCollectionView.m
//  Trellobyte
//
//  Created by alex on 10/25/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "CardsCollectionView.h"

@implementation CardsCollectionView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {

    return NSDragOperationEvery;
}

- (void)draggingSession:(NSDraggingSession *)session
       willBeginAtPoint:(NSPoint)screenPoint {


}

@end
