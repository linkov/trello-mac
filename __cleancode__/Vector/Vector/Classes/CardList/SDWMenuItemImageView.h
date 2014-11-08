//
//  SDWMenuItemImageView.h
//  Vector
//
//  Created by alex on 11/7/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@protocol SDWMenuItemDelegate;

typedef enum {

    SDWMenuItemDropActionNone = 0,
    SDWMenuItemDropActionDelete,
} SDWMenuItemDropAction;

#import <Cocoa/Cocoa.h>

@interface SDWMenuItemImageView : NSImageView

@property (weak, nonatomic) id <SDWMenuItemDelegate> delegate;

@end


@protocol SDWMenuItemDelegate

@optional

- (void)menuItemShouldValidateDropWithAction:(SDWMenuItemDropAction)action objectID:(NSString *)objectID;

@end