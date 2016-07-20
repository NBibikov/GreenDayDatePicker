//
//  NBViewController.m
//  GreenDayDatePicker
//
//  Created by Nick Bibikov on 07/20/2016.
//  Copyright (c) 2016 Nick Bibikov. All rights reserved.
//

#import "NBViewController.h"
#import <GreenDayDatePicker/GreenDayDatePicker-umbrella.h>

@interface NBViewController ()
@property (strong, nonatomic) DayDatePickerView* dayDatePicker;
@end

@implementation NBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDayDatePicker];
}


- (void) addDayDatePicker
{
    //    self.dayDatePicker = [[DayDatePickerView alloc] initWithType:DayDatePickerCenterType onView:self.view];
    self.dayDatePicker = [[DayDatePickerView alloc] initWithType:DayDatePickerBottomType onView:self.view];
    self.dayDatePicker.fontForRow = [UIFont fontWithName:@"AvenirNext-Regular" size:16.f];
    
    //    self.dayDatePicker.datePickerSelectionColor = [UIColor colorWithRed:0.4458 green:0.6509 blue:0.0125 alpha:1.0];
    
    //    self.dayDatePicker.saveButtonTitle = @"Сохранить";
    //    self.dayDatePicker.todayButtonTitle = @"Сегодня";
    
    //    self.dayDatePicker.textColorForRow = [UIColor whiteColor];
    //    self.dayDatePicker.backgroundColorForRow = [UIColor darkGrayColor];
    
    
    [self.dayDatePicker setSaveDateButtonPressedBlock:^(UIBarButtonItem *sender, NSDate *date)
     {
         NSLog(@"save date: %@", date);
     }];
    
    [self.dayDatePicker setDidSelectDateBlock:^(NSDate *date)
     {
         NSLog(@"select date: %@", date);
     }];
    
}

- (IBAction)showDatePickerButtonPressed:(UIButton *)sender
{
    [self.dayDatePicker showDayDatePicker];
}
@end
