

## Why GreenDayDatePicker?

Hello! My goal was create simple and not ugly date picker. 
It work in two mode - show in centre and of bottom screen. 

DatePicker will hidden after click outside or when user click button "Save". You can set font and colors.


![alt tag](https://raw.githubusercontent.com/NBibikov/GreenDayDatePicker/master/ScreenCasts/screenCast1.gif)
![alt tag](https://raw.githubusercontent.com/NBibikov/GreenDayDatePicker/master/ScreenCasts/screenCast2.gif)


## Installation

pod 'GreenDayDatePicker'

## Usage 

Import header
```
#import <DayDatePickerView.h>
```

After that you have initialize datePicker and set parameters and block for data callback

```
self.dayDatePicker = [[DayDatePickerView alloc] initWithType:DayDatePickerCenterType onView:self.view];

[self.dayDatePicker setSaveDateButtonPressedBlock:^(UIBarButtonItem *sender, NSDate *date)
{
NSLog(@"save date: %@", date);
}];

[self.dayDatePicker setDidSelectDateBlock:^(NSDate *date)
{
NSLog(@"select date: %@", date);
}];

```

## Customisation 

You can customisation GreenDayDatePicker with property list

```
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
```

## Contact

@nbibikov on Twitter
@nbibikov on Github
n.bibikov [at] me [dot] com

