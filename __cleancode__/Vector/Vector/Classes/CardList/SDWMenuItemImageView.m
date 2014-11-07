//
//  SDWMenuItemImageView.m
//  Vector
//
//  Created by alex on 11/7/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "AFTrelloAPIClient.h"
#import "SDWMenuItemImageView.h"

@implementation SDWMenuItemImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {

    NSLog(@"entered");

    return NSDragOperationMove;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender {

    NSPasteboard *pBoard = [sender draggingPasteboard];
    NSData *indexData = [pBoard dataForType:@"MY_DRAG_TYPE"];

    NSString *cardID = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
    NSLog(@"cardID = %@",cardID);
    [self deleteCard:cardID];

    NSLog(@"ended");

}

- (void)draggingExited:(id<NSDraggingInfo>)sender {

    NSLog(@"exited");
}

- (void)deleteCard:(NSString *)cardID {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"com.sdwr.trello-mac.didRemoveCardNotification" object:nil userInfo:nil];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"err - %@",error.localizedDescription);
    }];
}

@end
