//
//  LabelViewItem.h
//  Lists
//
//  Created by Alex Linkov on 1/29/20.
//  Copyright © 2020 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelViewItem : NSCollectionViewItem

@property (weak) IBOutlet NSTextField *mainTextField;

@end

NS_ASSUME_NONNULL_END
