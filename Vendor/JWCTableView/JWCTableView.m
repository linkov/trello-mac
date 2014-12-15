//
//  JWCTableView.m
//  Table View Example
//
//  Created by Will Chilcutt on 3/23/14.
//  Copyright (c) 2014 NSWill. All rights reserved.
//

#import "JWCTableView.h"

@interface JWCTableView ()
{
    
}

@end

@implementation JWCTableView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self != nil)
    {
        [self setDelegate:self];
        [self setDataSource:self];
    }
    
    return self;
}

#pragma mark - Drag&Drop

//- (NSString *)objectIDForRow:(NSUInteger)row {
//
//    return nil;
//}
//
//- (BOOL)objectCanDrag {
//
//    return NO;
//}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{

    return [_jwcTableViewDelegate _jwcTableView:tv writeRowsWithIndexes:rowIndexes toPasteboard:pboard];
}

//- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
//
//    return NSDragOperationNone;
//}

//- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
//              row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
//
//    return NO;
//}



#pragma mark NSTableViewDataSource methods


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger numberOfSections = 1;
    
    if ([self.jwcTableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] == YES)
    {
        numberOfSections = [self.jwcTableViewDataSource numberOfSectionsInTableView:tableView];
    }
    
    NSInteger numberOfRows = 0;
    
    for (NSInteger section = 0; section < numberOfSections; section++)
    {
        NSInteger numberOfRowsInSection = [self.jwcTableViewDataSource tableView:tableView
                                                           numberOfRowsInSection:section];
        
        //Check if the section has a head view, and if so, then add 1 to the number of rows in that section.
        if ([self.jwcTableViewDataSource respondsToSelector:@selector(tableView:hasHeaderViewForSection:)]  == YES)
        {
            BOOL needsSectionHeaderView = [self.jwcTableViewDataSource tableView:tableView
                                                         hasHeaderViewForSection:section];
            
            if (needsSectionHeaderView == YES)
            {
                numberOfRowsInSection++;
            }
        }
        
        numberOfRows += numberOfRowsInSection;
    }
    
    return numberOfRows;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSView *view = nil;
    
    BOOL rowIsSectionHeader = NO;
    
    NSInteger section = [self tableView:tableView getSectionFromRow:row isSection:&rowIsSectionHeader];
    
    if (rowIsSectionHeader == YES)
    {
        view = [self.jwcTableViewDataSource tableView:tableView
                               viewForHeaderInSection:section];
    }
    else
    {
        NSIndexPath *indexPath = [self tableView:tableView
                                 indexPathForRow:row];
        
        view = [self.jwcTableViewDataSource tableView:tableView viewForIndexPath:indexPath];
    }
    
    return view;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    CGFloat rowHeight = 0;
    
    BOOL rowIsSectionHeader = NO;
    
    NSInteger section = [self tableView:tableView getSectionFromRow:row isSection:&rowIsSectionHeader];
    
    if (rowIsSectionHeader == YES)
    {
        rowHeight = [self.jwcTableViewDataSource tableView:tableView
                             heightForHeaderViewForSection:section];
    }
    else
    {
        NSIndexPath *indexPath = [self tableView:tableView
                                 indexPathForRow:row];
        
        rowHeight = [self.jwcTableViewDataSource tableView:tableView
                                   heightForRowAtIndexPath:indexPath];
    }
    
    return rowHeight;
}

#pragma mark NSTableViewDelegate methods

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    BOOL shouldSelect = NO;
    
    BOOL rowIsSectionHeader = NO;
    
    NSInteger section = [self tableView:tableView getSectionFromRow:row isSection:&rowIsSectionHeader];
    
    if (rowIsSectionHeader == YES &&
        [self.jwcTableViewDelegate respondsToSelector:@selector(tableView:shouldSelectSection:)] == YES)
    {
        shouldSelect = [self.jwcTableViewDelegate tableView:tableView
                                        shouldSelectSection:section];
    }
    else if (rowIsSectionHeader == NO &&
             [self.jwcTableViewDelegate respondsToSelector:@selector(tableView:shouldSelectRowAtIndexPath:)] == YES)
    {
        NSIndexPath *indexPath = [self tableView:tableView
                                 indexPathForRow:row];
        
        shouldSelect = [self.jwcTableViewDelegate tableView:tableView
                                 shouldSelectRowAtIndexPath:indexPath];
    }
    
    return shouldSelect;
}

#pragma mark Convert row index to NSIndexPath

-(NSIndexPath *)tableView:(NSTableView *)tableView indexPathForRow:(NSInteger)row
{
    NSIndexPath *indexPath = nil;
    
    NSInteger numberOfSections = 1;
    
    if ([self.jwcTableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] == YES)
    {
        numberOfSections = [self.jwcTableViewDataSource numberOfSectionsInTableView:tableView];
    }
    
    for (NSInteger section = 0; section < numberOfSections; section++)
    {
        NSInteger numberOfRowsInSection = [self.jwcTableViewDataSource tableView:tableView
                                                           numberOfRowsInSection:section];
        
        BOOL needsSectionHeaderView = NO;
        
        //Check if the section has a head view, and if so, then add 1 to the number of rows in that section.
        if ([self.jwcTableViewDataSource respondsToSelector:@selector(tableView:hasHeaderViewForSection:)]  == YES)
        {
            needsSectionHeaderView = [self.jwcTableViewDataSource tableView:tableView
                                                    hasHeaderViewForSection:section];
            
            if (needsSectionHeaderView == YES)
            {
                numberOfRowsInSection++;
            }
        }
        
        //If the row number is larger than or equal to the number of Rows in section, then the row is not in the current section
        if (row >= numberOfRowsInSection)
        {
            row -=numberOfRowsInSection;
        }
        //The row we want is in this section.
        else
        {
            NSInteger realRowIndex = row;
            
            //If the section has a header view then subtract 1
            if (needsSectionHeaderView == YES)
            {
                realRowIndex -=1;
            }
            
            indexPath = [NSIndexPath indexPathForRow:realRowIndex
                                                        inSection:section];
            
            //We can break out of the for loop because we have the indexPath!
            break;
        }
    }
    
    return indexPath;
}

#pragma mark Get section from row

-(NSInteger)tableView:(NSTableView *)tableView getSectionFromRow:(NSInteger)row isSection:(BOOL *)isSection
{
    NSInteger numberOfSections = 1;
    
    if ([self.jwcTableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] == YES)
    {
        numberOfSections = [self.jwcTableViewDataSource numberOfSectionsInTableView:tableView];
    }
    
    //If we see that the number of sections was only 1 and the row is not 0 (the section header index), then we can just stop now
    if (numberOfSections == 1 &&
        row != 0)
    {
        *isSection = NO;
        return 0;
    }
    //Else there are multiple sections and we need to determine which section the row is, if it is a section at all.
    else
    {
        for (NSInteger currentSection = 0; currentSection < numberOfSections; currentSection++)
        {
            NSInteger numberOfRowsInSection = [self.jwcTableViewDataSource tableView:tableView
                                                               numberOfRowsInSection:currentSection];
            
            BOOL sectionHasHeaderView = NO;
            
            //Check if the section has a head view, and if so, then add 1 to the number of rows in that section.
            if ([self.jwcTableViewDataSource respondsToSelector:@selector(tableView:hasHeaderViewForSection:)]  == YES)
            {
                sectionHasHeaderView = [self.jwcTableViewDataSource tableView:tableView
                                                        hasHeaderViewForSection:currentSection];
                
                if (sectionHasHeaderView == YES)
                {
                    numberOfRowsInSection++;
                }
            }
            
            //The section header should always be index 0, so if the section has a header view and the row index is 0, then we found the correct section
            if (sectionHasHeaderView == YES &&
                row == 0)
            {
                *isSection = YES;
                return currentSection;
            }
            //This is not the correct section, so we subtract the number of rows in this section from the row index to get the row index to try in the next section
            else
            {
                row -=numberOfRowsInSection;
            }
        }
    }
    
    return 0;
}

-(NSIndexPath *)indexPathForView:(NSView *)view
{
    NSInteger row = [super rowForView:view];
    
    //Minimum row has to be 0
    if (row < 0)
    {
        row = 0;
    }
    
    BOOL rowIsSectionHeader = NO;
    
    NSInteger section = [self tableView:self
                      getSectionFromRow:row
                              isSection:&rowIsSectionHeader];
    
    if (rowIsSectionHeader == YES)
    {
        //Not sure what I should do here as they really touched a section header and not a row...
        return nil;
    }
    else
    {
        NSIndexPath *indexPath = [self tableView:self
                                 indexPathForRow:row];
        
        return indexPath;
    }
}

@end

@implementation NSIndexPath (NSTableView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSUInteger path[2] = {section, row};
    return [self indexPathWithIndexes:path length:2];
}

- (NSInteger)row
{
    return [self indexAtPosition:1];
}

-(NSInteger)section
{
    return [self indexAtPosition:0];
}

@end
