//
//  SDWBoardsListRow.m
//  Lists
//
//  Created by alex on 11/5/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "NSColor+Util.h"
#import "SDWBoardsListRow.h"
#import "SDWCardDisplayItem.h"

@implementation SDWBoardsListRow

- (id)initWithFrame:(NSRect)frameRect {
   
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDWListsShouldReloadBoardsDatasourceNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        if(self.list)  {
            [self setNeedsDisplay:YES];
        }
    }];
    return  [super initWithFrame:frameRect];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if(self.list)  {
         [self loadCardNumbers];
        [self markListWithOverdueCards];
    }
    
    
   

}
- (void)markListWithOverdueCards {
    
    for (SDWCardDisplayItem * card in [self.list cards]) {
        
        
        NSDate *due = card.dueDate;
        if (due != nil && [due timeIntervalSinceNow] < 0.0) {
            NSGraphicsContext* gc = [NSGraphicsContext currentContext];
            
            // Save the current graphics context settings
            [gc saveGraphicsState];
            
            // Set the color in the current graphics context for future draw operations
            [[NSColor colorWithHexColorString:@"FA2A00"] setFill];
            
            // Create our circle path
            NSRect rect = NSMakeRect(10, 8.7, 4, 4);
            NSBezierPath* circlePath = [NSBezierPath bezierPath];
            [circlePath setLineWidth:1];
            [circlePath appendBezierPathWithOvalInRect: rect];
            
            // Outline and fill the path
            [circlePath fill];
            
            // Restore the context to what it was before we messed with it
            [gc restoreGraphicsState];
            
        } else if (due != nil && ([due timeIntervalSinceNow] > 0.0 && [due timeIntervalSinceNow] < 100000 ) ) {
            NSGraphicsContext* gc = [NSGraphicsContext currentContext];
            // Save the current graphics context settings
            [gc saveGraphicsState];
            
            // Set the color in the current graphics context for future draw operations
            [[NSColor colorWithHexColorString:@"FAB243"] setFill];
            
            // Create our circle path
            NSRect rect = NSMakeRect(10, 8.7, 4, 4);
            NSBezierPath* circlePath = [NSBezierPath bezierPath];
            [circlePath setLineWidth:1];
            [circlePath appendBezierPathWithOvalInRect: rect];
            
            // Outline and fill the path
            [circlePath fill];
            
            // Restore the context to what it was before we messed with it
            [gc restoreGraphicsState];
            
        } else {

        }
    }
    // Get the graphics context that we are currently executing under
    
}

- (void)loadCardNumbers  {
    
    if (self.list) {
        
        NSFont* font = [NSFont fontWithName:@"IBMPlexSans-Text" size:7];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary* stringAttrs = @{
                                      NSFontAttributeName : font,
                                      NSParagraphStyleAttributeName:paragraphStyle,
                                      NSForegroundColorAttributeName : [[SharedSettings appAccentDarkColor] colorWithAlphaComponent:0.3]
                                      
                                      
                                      };
        NSString *string = [NSString stringWithFormat:@" %lu ",(unsigned long)[[self.list cards] count]] ;
        NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:stringAttrs];
        
        [attrStr drawInRect:CGRectMake(10, 6, 30, 10)];
        
    }
}

- (void)drawDraggingDestinationFeedbackInRect:(NSRect)dirtyRect {

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[SharedSettings appHighlightGreenColor] set];
    [NSBezierPath fillRect:drawRect];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[SharedSettings appHighlightColor] set];
    [NSBezierPath fillRect:drawRect];

}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        [self.delegate boardRowDidDoubleClick:self];

    }
}

-(void)didAddSubview:(NSView *)subview {
    [super didAddSubview:subview];

    if ( [subview isKindOfClass:[NSButton class]] ) {
        [(NSButton *)subview setImage:[NSImage imageNamed:@"trian-closed"]];
        [(NSButton *)subview setAlternateImage:[NSImage imageNamed:@"trian-open"]];
    }
}


@end
