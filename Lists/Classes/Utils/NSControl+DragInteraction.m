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

static NSString const *interactionDelegateKey = @"com.sdwr.utils.interactionDelegateKey";

@interface NSControl ()

@property BOOL canPerformAction;

@end

@implementation NSControl (DragInteraction)

#pragma mark - NSDragging

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo> )sender {
    CIFilter *invert = [CIFilter filterWithName:@"CIColorInvert"];
    [invert setDefaults];

    self.layer.filters = @[invert];
    return NSDragOperationMove;
}

- (void)draggingEnded:(id <NSDraggingInfo> )sender {
    NSPoint clickPoint = [self convertPoint:sender.draggingLocation fromView:nil];

    if (CGRectContainsPoint( self.bounds, clickPoint )) {
        if ([(NSObject *)self.interactionDelegate respondsToSelector : @selector(control:didAcceptDropWithPasteBoard:)]) {
            [self.interactionDelegate control:self didAcceptDropWithPasteBoard:[sender draggingPasteboard]];
        }
    }

    self.layer.filters = @[];
}

- (void)draggingExited:(id <NSDraggingInfo> )sender {
    self.layer.filters = @[];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo> )sender {
    return YES;
}

#pragma mark - Associated objects

- (void)setInteractionDelegate:(id <NSControlInteractionDelegate> )interactionDelegate {
    objc_setAssociatedObject( self, (__bridge const void *)(interactionDelegateKey), interactionDelegate, OBJC_ASSOCIATION_ASSIGN );
}

- (id <NSControlInteractionDelegate> )interactionDelegate {
    return objc_getAssociatedObject( self, (__bridge const void *)(interactionDelegateKey));
}

@end
