//
//  SDWCheckItemTableCellView.m
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCheckItemTableCellView.h"
#import "SDWMChecklistItem.h"

@interface SDWCheckItemTableCellView () <NSTextFieldDelegate>
@property (strong) IBOutlet NSButton *addCheckItemButton;
@property (strong) IBOutlet NSImageView *handleImage;

@end

@implementation SDWCheckItemTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {

    self.wantsLayer = YES;
    self.textField.delegate = self;
    self.addCheckItemButton.hidden = self.handleImage.hidden = YES;
    self.addCheckItemButton.wantsLayer = self.handleImage.wantsLayer = YES;

    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
   NSTrackingArea *trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];

    [self addTrackingArea:trackingArea];
}
- (IBAction)checkBoxClicked:(AAPLCheckBox *)sender {

    self.textField.enabled = !sender.checked;
    [self.delegate checkItemDidCheck:self];
}
- (IBAction)addItemButtonClicked:(id)sender {

    [self.delegate checkItemShouldAddItem:self];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {

    self.trelloCheckItem.name = self.textField.stringValue;
    [self.delegate checkItemDidChangeName:self];
}

- (void)mouseEntered:(NSEvent *)theEvent {

    [self animateControlsOpacityIn:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {

    NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];

    if ( (clickPoint.x > self.frame.size.width || clickPoint.x < 0) || (clickPoint.y > self.checkBox.frame.size.height || clickPoint.y < 0)) {

        [self animateControlsOpacityIn:NO];
    }


}

- (void)animateControlsOpacityIn:(BOOL)shouldShow {

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
        context.duration = 0.35;
        context.allowsImplicitAnimation = YES;
        self.addCheckItemButton.animator.hidden = self.handleImage.animator.hidden = !shouldShow;

    } completionHandler:^{

    }];
}


@end
