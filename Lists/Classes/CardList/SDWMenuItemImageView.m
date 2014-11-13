//
//  SDWMenuItemImageView.m
//  Lists
//
//  Created by alex on 11/7/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@import QuartzCore;

#import "AFTrelloAPIClient.h"
#import "SDWMenuItemImageView.h"

@interface SDWMenuItemImageView ()

@property BOOL canPerformAction;

@end

@implementation SDWMenuItemImageView

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {

    self.canPerformAction = YES;
    CIFilter *invert = [CIFilter filterWithName: @"CIColorInvert"];
    [invert setDefaults];

    self.layer.filters = @[invert];
    return NSDragOperationMove;
}


- (void)draggingEnded:(id<NSDraggingInfo>)sender {

    if (self.canPerformAction) {

        NSPasteboard *pBoard = [sender draggingPasteboard];
        NSData *indexData = [pBoard dataForType:@"MY_DRAG_TYPE"];

        NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        [self performActionForObjectID:cardDict[@"cardID"]];

    }

}

- (void)performActionForObjectID:(NSString *)objectID {

     [self.delegate menuItemShouldValidateDropWithAction:SDWMenuItemDropActionDelete objectID:objectID];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {

    self.layer.filters = @[];
    self.canPerformAction = NO;
}


@end
