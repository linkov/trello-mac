//
//  LabelCloudView.m
//  Lists
//
//  Created by Alex Linkov on 1/29/20.
//  Copyright © 2020 SDWR. All rights reserved.
//

#import "LabelCloudView.h"
#import "LabelViewItem.h"
#import "SDWAppSettings.h"

@interface LabelCloudView () <NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout>

@property (strong) NSMutableSet *disabledLabels;
@property (strong) NSMutableSet *includedLabels;

@end


@implementation LabelCloudView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


#pragma mark init code

- (void)awakeFromNib {
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    self.bottomBorder = [CALayer layer];

    self.bottomBorder.backgroundColor = [[SDWAppSettings sharedSettings] appBackgroundColor].CGColor;

    [self.layer addSublayer:self.bottomBorder];
    self.bottomBorder.frame = CGRectMake(0.0f, 1.,self.collectionView.frame.size.width, 1.0f);
    [self initAll];
    
  
}

- (id)initWithFrame:(NSRect)frameRect {

    self = [super initWithFrame:frameRect];
    if (self) {
        
    

        
    }
    return self;
}


- (void)resetDisabledLabels {
    self.disabledLabels =[NSMutableSet set];
}


- (void)layout {
    [super layout];

    
}


-(void)initAll {
     
    
    self.disabledLabels = [NSMutableSet set];
    self.includedLabels = [NSMutableSet set];
    
    NSCollectionViewFlowLayout *layout = [NSCollectionViewFlowLayout new];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = NSEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = NSMakeSize(60, 20);
    

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.allowsMultipleSelection = false;
    self.collectionView.backgroundColors = @[[NSColor clearColor]];
    self.collectionView.selectable = YES;
    
    
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"LabelViewItem" bundle:nil];
    [self.collectionView registerNib:nib forItemWithIdentifier:@"labelCell"];
    
    
    
//
//    scrollView.documentView = self.collectionView;
//    [self addSubview:scrollView];
}


// NSCollectionViewDataSource, NSCollectionViewDelegate

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.labels.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelViewItem *cell = [collectionView makeItemWithIdentifier:@"labelCell" forIndexPath:indexPath];

    SDWLabelDisplayItem *label = self.labels[indexPath.item];
    cell.view.layer.backgroundColor = [[SDWAppSettings sharedSettings] colorForTrelloColor:label.color].CGColor;
    
    cell.mainTextField.stringValue = label.name.length > 0 ? label.name : label.color;
    if (label.name.length == 0) {
        cell.mainTextField.textColor = [[SDWAppSettings sharedSettings] colorForTrelloColor:label.color];
        
        
    } else {
        cell.mainTextField.textColor = [NSColor whiteColor];
    }
    

    
    if ([self.includedLabels containsObject:label]) {
         cell.view.layer.opacity = 1;
        
        
        cell.view.layer.shadowOpacity = 0.4;
        cell.view.layer.shadowColor = [SharedSettings colorForTrelloColor:label.color].CGColor;
        cell.view.layer.shadowOffset = NSMakeSize(0, 0);
        cell.view.layer.shadowRadius = 6;
        
        
    } else {
         cell.view.layer.opacity = 0.35;
    }
    
    
    return cell;
    
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSIndexPath *indexPath = indexPaths.allObjects.firstObject;
    SDWLabelDisplayItem *label = self.labels[indexPath.item];
       
    if ([self.includedLabels containsObject:label]) {
        [self.includedLabels removeObject:label];
    } else {
        

        [self.includedLabels addObject:label];
    }
    
    
    
    [self.collectionView reloadData];
    
    [self.delegate labelCloudDidUpdateDisabledLabels:self.disabledLabels includedLabels:self.includedLabels];
   
    

}

//func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//
//    let string = strings[indexPath.item]
//    let size = NSTextField(labelWithString: string).sizeThatFits(NSSize(width: 400, height: 800))
//
//    return NSSize(width: 400, height: size.height > 80 ? size.height : 80)
//}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(nonnull NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SDWLabelDisplayItem *label = self.labels[indexPath.item];
    NSString *text = label.name.length > 0 ? label.name : label.color;
    CGSize size = [[NSTextField labelWithString:text] sizeThatFits:CGSizeMake(800, 20)];
    
    return CGSizeMake(size.width > 50 ? size.width + 20 : 60, 20);
}


@end
