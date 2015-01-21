//
//  NSControl+DragInteraction.h
//  Lists
//
//  Created by alex on 1/6/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
#import <Cocoa/Cocoa.h>


@protocol NSControlInteractionDelegate

@optional

- (void)control:(NSControl *)control didAcceptDropWithPasteBoard:(NSPasteboard *)pasteboard;

@end

@interface NSControl (DragInteraction)

@property (weak, nonatomic) id <NSControlInteractionDelegate> interactionDelegate;

@end
