//
//  NSControl+DragInteraction.h
//  Lists
//
//  Created by alex on 1/6/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {

    NSControlInteractionDropActionNone = 0,
    NSControlInteractionDropActionDelete,
} NSControlInteractionDropAction;

@protocol NSControlInteractionDelegate

@optional

- (void)controlShouldValidateDropWithAction:(NSControlInteractionDropAction)action objectID:(NSString *)objectID;

@end

@interface NSControl (DragInteraction)

@property (weak, nonatomic) id <NSControlInteractionDelegate> interactionDelegate;

@end
