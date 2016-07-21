//
//  GreenDayDatePickerView.h
//  YourProjectName
//
//  Created by Nick Bibikov on 7/7/16.
//  Copyright © 2016 Grossum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DayDatePickerType)
{
    DayDatePickerCenterType,
    DayDatePickerBottomType
};


typedef NS_ENUM(NSInteger, GreenDayDatePickerViewColumnType)
{
    GreenDayDatePickerViewColumnTypeDay,
    GreenDayDatePickerViewColumnTypeMonth,
    GreenDayDatePickerViewColumnTypeYear
};

@interface GreenDayDatePickerView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (instancetype) initWithType:(DayDatePickerType) pickerType onView:(UIView*) superView;
- (void) showDayDatePicker;
- (void) hideDayDatePicker;

@property (assign, nonatomic) BOOL hideAfterSaveButtonPressed; //default is 1

@property (strong, nonatomic) NSString *todayButtonTitle;
@property (strong, nonatomic) NSString *saveButtonTitle;

@property (strong, nonatomic) NSDate *minimumDate; //default is Today
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSDateFormatter *dayDateFormatter;
@property (strong, nonatomic) NSDateFormatter *monthDateFormatter;
@property (strong, nonatomic) NSDateFormatter *yearDateFormatter;

@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) UITableView *daysTableView;
@property (strong, nonatomic) UITableView *monthsTableView;
@property (strong, nonatomic) UITableView *yearsTableView;

@property (assign, nonatomic) NSInteger rowHeight;

@property (strong, nonatomic) UIColor *mainBackgroundColor;
@property (strong, nonatomic) UIColor *datePickerSelectionColor;
@property (strong, nonatomic) UIColor *textColorForRow;
@property (strong, nonatomic) UIColor *backgroundColorForRow;

@property (strong, nonatomic) UIFont *fontForRow;

@property (copy, nonatomic) void (^saveDateButtonPressedBlock)(UIBarButtonItem* barButton, NSDate* selectedDate);
@property (copy, nonatomic) void (^didSelectDateBlock)(NSDate* selectedDate);

@end
