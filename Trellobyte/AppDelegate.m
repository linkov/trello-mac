//
//  AppDelegate.m
//  testMacApp
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)

#import "CardInspectorVC.h"
#import "AppDelegate.h"
#import "Board.h"
#import "Card.h"
#import "User.h"
#import "AFTrelloAPIClient.h"
#import "AFNetworking.h"
#import "Xtrace.h"
#import "CardListView.h"
#import "CardListItemVC.h"
#import "NSImage+Util.h"

#import <Quartz/Quartz.h>

@interface AppDelegate () <NSCollectionViewDelegate>
@property (weak) IBOutlet NSLayoutConstraint *cardInspectorWidth;

@property (strong) NSArray *constr;
@property (strong) Board *parentBoard;
@property (strong) NSArray *users;
@property (strong) Board *selectedItem;
@property (weak) IBOutlet NSWindow *window;
@property BOOL animationInProgress;
@property NSUInteger activeOperations;
@property NSPoint dragPoint;


@property (strong) NSLayoutConstraint *inspectorWidthCopy;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {


    //[self.cardsArrayController xtrace];

    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

    NSSize minSize = NSMakeSize(0,40);
    [self.cardCollection setMaxItemSize:minSize];

    [self.progress startAnimation:nil];


    [Board fetchBoardsWithBlock:^(NSArray *posts, NSError *error) {
        if (error) {
            [[NSAlert alertWithMessageText:NSLocalizedString(@"Error", nil) defaultButton:NSLocalizedString(@"OK", nil) alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@",[error localizedDescription]] runModal];
        }
        

        //self.boardsArrayController.content = posts;
//        self.board = [[Board alloc]initWithAttributes:@{@"name":@"test"}];
//        self.board.isLeaf = NO;
//        self.board.children = posts;
        self.boards = posts;
        self.outlineView.delegate = self;
        [self.outlineView deselectAll:nil];
        [self.outlineView expandItem:nil expandChildren:YES];
        //self.outlineView ex
        //self.boardsTreeController.content = posts;
        [self.outlineView reloadData];



    }];

    self.cardCollection.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];


    self.cardInspectorWidth.constant = 0;
    [self.cardInspector layoutSubtreeIfNeeded];

    [self.cardCollection registerForDraggedTypes:@[@"MY_DRAG_TYPE"]];



}

- (void)awakeFromNib {

    [self.cardsArrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:nil];


}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualTo:@"selectionIndexes"]) {

        //True if in the array controller of the collection view really exists at least a selected object
        if([[self.cardsArrayController selectedObjects] count] > 0)
        {
            NSLog(@"Selected objects: %@", [self.cardsArrayController selectedObjects]);
            [self didSelectCard:[self.cardsArrayController selectedObjects].lastObject ];
        }
        else
        {
            NSLog(@"Observer called but no objects where selected.");
        }
    }
}


- (void)didSelectCard:(Card *)card {

    [self animateInspectorIn:YES];
    self.cardInspectorVC.activeCard = card;

}

- (void)animateInspectorIn:(BOOL)bringIn {


    self.rightView.wantsLayer = YES;
    self.rightView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

    [self.rightView updateConstraintsForSubtreeIfNeeded];
    self.cardInspectorWidth.constant = bringIn ? 250 : 0;
    [self.rightView setNeedsUpdateConstraints:YES];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:0.3];
        [context setAllowsImplicitAnimation:YES];

        [self.rightView layoutSubtreeIfNeeded];

    } completionHandler:^{

        
    }];
}

- (IBAction)didSelect:(NSOutlineView *)sender {

     [self animateInspectorIn:NO];

    if (self.selectedItem.isLeaf) {

        NSLog(@"selected %@ - ID = %@",self.selectedItem.name,self.selectedItem.boardID);

        self.cards = nil;
        self.cardsArrayController.content = nil;

        [User fetchUsersForBoardID:self.parentBoard.boardID WithBlock:^(NSArray *posts, NSError *error) {

            if (!error) {

                self.users = posts;

                [self fetchCards];
            }

        }];


    }


}

- (void)networkingOperationDidStart:(NSNotification *)note {

    self.activeOperations ++;

    if (!self.animationInProgress) {


        self.animationInProgress = YES;

        self.leftView.wantsLayer = YES;
        self.leftView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:0.3];
            [context setAllowsImplicitAnimation:YES];
            [self.leftView addConstraint:self.verticalBottomSpaceToProgress];
            [self.leftView layoutSubtreeIfNeeded];
            CGFloat rotation = M_PI * 2;
            self.progress.layer.transform = CATransform3DMakeRotation(rotation, 0.f, 0.f, 1.f);

        } completionHandler:^{

            self.animationInProgress = NO;
        }];





    }




    NSLog(@"start");

}

- (void)networkingOperationDidFinish:(NSNotification *)note {


    self.activeOperations --;

    NSLog(@"active operations = %lu",(unsigned long)self.activeOperations);

    if (self.activeOperations == 0) {

        self.leftView.wantsLayer = YES;
        self.leftView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {

            [context setDuration:0.3];
            [context setAllowsImplicitAnimation:YES];
            [self.leftView removeConstraint:self.verticalBottomSpaceToProgress];
            [self.leftView layoutSubtreeIfNeeded];
            self.progress.layer.transform = CATransform3DMakeRotation(M_PI, 0.f, 0.f, 1.f);

        } completionHandler:^{


            self.animationInProgress = NO;
        }];
    }
}

- (void)animateCancel {

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {

        [context setDuration:2.0];
        [context setAllowsImplicitAnimation:YES];
        [self.leftView removeConstraint:self.verticalBottomSpaceToProgress];
        [self.leftView layoutSubtreeIfNeeded];

    } completionHandler:^{
    }];
}

- (void)animateProgressDown:(BOOL)down {

    if (down) {

        
      //  self.animationInProgress = YES;
       // [self.progress startAnimation:nil];

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {

            [context setDuration:2.0];
            [context setAllowsImplicitAnimation:YES];
            [self.leftView addConstraint:self.verticalBottomSpaceToProgress];
            [self.leftView layoutSubtreeIfNeeded];

        } completionHandler:^{

           // self.animationInProgress = NO;


        }];



//        [self.containerView removeConstraint:self.verticalBottomSpaceToProgress];



//
//        }];


    }
    else {

        if (!self.animationInProgress) {

            [self animateCancel];
        }







          //    [self.progress stopAnimation:nil];
      //  }];


    }
}

- (void)fetchCards {

    [Card fetchCardsForListID:self.selectedItem.boardID withBlock:^(NSArray *posts, NSError *error) {

        if (!error) {

            self.cards = [NSMutableArray arrayWithArray:posts];

            [self matchOwners];

        }
        else {

            NSLog(@"err = %@",error.localizedDescription);
        }
    }];
}

- (void)matchOwners {

    for (Card *card in self.cards) {

        card.owner = [self ownerForUserID:card.members.lastObject];
    }

    [self reloadCollection];
}


- (NSString *)ownerForUserID:(NSString *)userID {


    NSString *userName;

    for (User *user in self.users) {

        if ([user.userID isEqualToString:userID]) {

            userName = [self twoLetterIDFromName:user.name];
        }

    }

    return userName;
}

- (void)reloadCollection {

    self.cardsArrayController.content = self.cards;
    //[self.cardCollection setNeedsDisplay:YES];
}

- (NSString *)twoLetterIDFromName:(NSString *)name {

    NSString *finalString;

    NSArray *nameArr = [name componentsSeparatedByString:@" "];

    NSString *firstName = nameArr[0];

    if (nameArr.count>1) {

        NSString *lastName = nameArr[1];

        NSMutableArray *firstNameArr = [NSMutableArray new];

        [firstName enumerateSubstringsInRange: NSMakeRange(0,firstName.length)
                                      options: NSStringEnumerationByComposedCharacterSequences
                                   usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                       // If you want to see the way the string has been split
                                       //NSLog(@"%@", substring);
                                       [firstNameArr addObject: substring];
                                   }
         ];

        NSMutableArray *lastNameArr = [NSMutableArray new];

        [lastName enumerateSubstringsInRange: NSMakeRange(0,firstName.length)
                                     options: NSStringEnumerationByComposedCharacterSequences
                                  usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                      // If you want to see the way the string has been split
                                      //NSLog(@"%@", substring);
                                      [lastNameArr addObject: substring];
                                  }
         ];
        
        finalString = [NSString stringWithFormat:@"%@%@",firstNameArr[0],lastNameArr[0]];
    }
    else {

        finalString = @"";
    }


    return [finalString uppercaseString];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(NSTreeNode *)item {

    self.parentBoard = item.parentNode.representedObject;
    self.selectedItem = item.representedObject;

    if (self.selectedItem.isLeaf) {

        return YES;
    }

    return NO;

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


#pragma mark - NSCollectionViewDelegate

-(NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {

   // [self.cardsArrayController setSelectionIndexes:[NSIndexSet new]];

    NSLog(@"Validate Drop");
    return NSDragOperationMove;
}

- (void)collectionView:(NSCollectionView *)collectionView updateDraggingItemsForDrag:(id<NSDraggingInfo>)draggingInfo {

    NSLog(@"info - %@",draggingInfo);

    NSPoint dragPoint = draggingInfo.draggingLocation;
    NSLog(@"drag y - %f",dragPoint.y);

    self.dragPoint = dragPoint;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event {








    NSLog(@"Can Drag");
    return YES;
}

/*To convert NSImage in CGImage*/


- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset {




    CardListItemVC *selectedView = (CardListItemVC *)[collectionView itemAtIndex:indexes.lastIndex];
    NSImage *dragImage = [[NSImage alloc] initWithData:[selectedView.view dataWithPDFInsideRect:[selectedView.view bounds]]];

    NSImage *tintedImage = [dragImage grayscaleImageWithAlphaValue:1.0 saturationValue:.7 brightnessValue:0.5 contrastValue:.4];

    NSGraphicsContext *context;
    context = [NSGraphicsContext currentContext];
    NSRect rect = NSMakeRect(0, 0, dragImage.size.width, dragImage.size.height);
    CGImageRef cgImage = [tintedImage CGImageForProposedRect:&rect
                                    context:context
                                      hints:NULL];

    CALayer *syncFirst = [CALayer layer];

///    NSPoint point = CGPointMake(200, 0);
 ///   dragImageOffset = &point;
    //animatated content size init
    syncFirst.bounds =  selectedView.view.layer.bounds;
    syncFirst.position = CGPointMake(selectedView.view.layer.position.x+250, selectedView.view.layer.position.y);// selectedView.view.layer.position;
    syncFirst.contents =(__bridge id)(cgImage);

    [selectedView.view.superview setWantsLayer:YES];

    [selectedView.view.superview.layer addSublayer:syncFirst];

    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(-3)];
    rotationAnimation.duration = 0.2f;
    rotationAnimation.repeatCount= 0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [rotationAnimation setFillMode:kCAFillModeForwards];
    [rotationAnimation setRemovedOnCompletion:NO];

    //syncFirst.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-3), 0, 0, 1);
//    [syncFirst addAnimation:rotationAnimation forKey:@"rotateAnimation"];



    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            //[CATransaction setDisableActions:YES];
           // [syncFirst removeFromSuperlayer];
            [syncFirst setOpacity:0.f];
            //syncFirst.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-3), 0, 0, 1);
        }];

        [syncFirst addAnimation:rotationAnimation forKey:@"rotateAnimation"];

    } [CATransaction commit];


    return [dragImage imageRotatedByDegrees:3];

}


-(BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard {
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:indexes];
//    [pasteboard setDraggedTypes:@[@"MY_DRAG_TYPE"]];
    [pasteboard setData:indexData forType:@"MY_DRAG_TYPE"];
     // Here we temporarily store the index of the Cell,
     // being dragged to pasteboard.
     return YES;
     }

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {

    NSPoint dropPoint = draggingInfo.draggingLocation;
    NSLog(@"drop y - %f",dropPoint.y);

    if (dropOperation == NSCollectionViewDropBefore) {

        NSPasteboard *pBoard = [draggingInfo draggingPasteboard];
        NSData *indexData = [pBoard dataForType:@"MY_DRAG_TYPE"];
        NSIndexSet *indexes = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        NSInteger draggedCell = [indexes firstIndex];

        NSLog(@"Accept Drag");

//        NSLog(@"active card - %@",self.cardInspectorVC.activeCard.name);
//        NSLog(@"dragged card - %@",[[self.cardsArrayController.arrangedObjects objectAtIndex:draggedCell] name]);

        if (self.dragPoint.y < dropPoint.y) {

            [self.cardsArrayController  removeObjectAtArrangedObjectIndex:draggedCell];
        }
        //
        [self.cardsArrayController  insertObject: self.cardInspectorVC.activeCard atArrangedObjectIndex: index];


        if (self.dragPoint.y > dropPoint.y)  {

            [self.cardsArrayController  removeObjectAtArrangedObjectIndex:draggedCell];
        }

        
        
        return YES;
    }


    return NO;
     }

@end
