//
//  NSControl+DragInteraction.m
//  Lists
//
//  Created by alex on 1/6/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import QuartzCore;
#import <objc/runtime.h>

#import "NSControl+DragInteraction.h"

static NSString const * interactionDelegateKey = @"interactionDelegateKey";
static NSString const * canPerformActionKey = @"canPerformActionKey";

@interface NSControl ()

@property BOOL canPerformAction;

@end

@implementation NSControl (DragInteraction)

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
        NSData *indexData = [pBoard dataForType:@"TRASH_DRAG_TYPE"];

        NSDictionary *cardDict = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        [self performActionForObjectID:cardDict[@"itemID"]];

        self.layer.filters = @[];

    }

}

- (void)performActionForObjectID:(NSString *)objectID {

    [self.interactionDelegate controlShouldValidateDropWithAction:NSControlInteractionDropActionDelete objectID:objectID];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    
    self.layer.filters = @[];
    self.canPerformAction = NO;
}



#pragma mark - Associated objects

- (void)setCanPerformAction:(BOOL)canPerformAction {

    objc_setAssociatedObject(self,(__bridge const void *)(canPerformActionKey), [NSNumber numberWithBool:canPerformAction], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)canPerformAction {

    NSNumber *canPerform = objc_getAssociatedObject(self, (__bridge const void *)(canPerformActionKey));
    return canPerform.boolValue;
}


- (void)setInteractionDelegate:(id<NSControlInteractionDelegate>)interactionDelegate {
    objc_setAssociatedObject(self,(__bridge const void *)(interactionDelegateKey), interactionDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<NSControlInteractionDelegate>)interactionDelegate {
    return objc_getAssociatedObject(self, (__bridge const void *)(interactionDelegateKey));
}


@end

