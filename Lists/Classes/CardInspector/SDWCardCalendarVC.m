//
//  SDWCardCalendarVC.m
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCardCalendarVC.h"

@interface SDWCardCalendarVC () <NSDatePickerCellDelegate>
@property (strong) IBOutlet NSDatePicker *calendarPicker;
@property (strong) IBOutlet NSButton *removeDueButton;

@end

@implementation SDWCardCalendarVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.calendarPicker setDateValue:self.currentDue ? :[NSDate date]];
    self.calendarPicker.delegate = self;

    if (!self.currentDue) {
        [self.removeDueButton removeFromSuperview];
    }
}

- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate *__autoreleasing *)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval
{
    NSDate *dd = *proposedDateValue;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidUpdateDueNotification object:nil userInfo:@{@"date" : dd}];
    [self dismissController:nil];
}

- (IBAction)removeDue:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidUpdateDueNotification object:nil userInfo:@{@"date": [NSNull null]}];
    [self dismissController:nil];
}

@end
