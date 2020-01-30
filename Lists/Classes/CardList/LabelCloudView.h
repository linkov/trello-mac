//
//  LabelCloudView.h
//  Lists
//
//  Created by Alex Linkov on 1/29/20.
//  Copyright © 2020 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDWLabelDisplayItem.h"

NS_ASSUME_NONNULL_BEGIN


@protocol SDWLabelCloudViewDelegate

@optional

- (void)labelCloudDidUpdateDisabledLabels:(NSSet<SDWLabelDisplayItem *>*)labels;

@end


@interface LabelCloudView : NSView

@property (strong) NSArray<SDWLabelDisplayItem *> *labels;
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) id <SDWLabelCloudViewDelegate> delegate;
@property (strong) CALayer *bottomBorder;

- (void)resetDisabledLabels;

@end




NS_ASSUME_NONNULL_END
