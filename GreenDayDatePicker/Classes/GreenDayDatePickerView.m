//
//  GreenDayDatePickerView.m
//  YourProjectName
//
//  Created by Nick Bibikov on 7/7/16.
//  Copyright © 2016 Grossum. All rights reserved.
//

#import "GreenDayDatePickerView.h"


static NSInteger maxYearForSelection = 2;
static CGFloat topBarHeight = 44.f;
static CGFloat kAnimationDuration = 0.35f;
static CGFloat kLeftAndRightInsets = 40.f;

static NSString* kSaveTitle = @"Save";
static NSString* kTodayButton = @"Today";

@interface GreenDayDatePickerView ()
@property (strong, nonatomic) NSDateComponents *components;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIView *selectionIndicator;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *superView;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIBarButtonItem *todayButton;
@property (assign, nonatomic) CGPoint finalCenterPoint;
@property (assign, nonatomic) CGRect GreenDayDatePickerViewRect;
@property (assign, nonatomic) NSInteger centralRowOffset;

@end

@implementation GreenDayDatePickerView

@synthesize date = _date;
@synthesize dayDateFormatter = _dayDateFormatter;
@synthesize monthDateFormatter = _monthDateFormatter;
@synthesize yearDateFormatter = _yearDateFormatter;



- (instancetype) initWithType:(DayDatePickerType) pickerType onView:(UIView*) superView
{
    self = [super init];
    if(self)
    {
        self.superView = superView;
        self.hideAfterSaveButtonPressed = YES;
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.superView.frame];
        if (!self.mainBackgroundColor) self.mainBackgroundColor = [UIColor colorWithRed:0.0571 green:0.0572 blue:0.0571 alpha:0.7];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(hideDayDatePicker)];
        
        [self.backgroundView addGestureRecognizer:tapGesture];
        [self calculateSizeForDayDatePickerType:pickerType];
        [self setFrame:self.GreenDayDatePickerViewRect];
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void) calculateSizeForDayDatePickerType:(DayDatePickerType) pickerType
{
    switch (pickerType)
    {
        case DayDatePickerCenterType:
        {
            CGFloat leftAndRightInsets = kLeftAndRightInsets;
            CGFloat mainHeight = CGRectGetHeight(self.superView.frame);
            CGFloat mainWidth  = CGRectGetWidth(self.superView.frame);
            CGFloat datePickerHeight = mainHeight/2.2;
            CGFloat datePickerWidth  = mainWidth - leftAndRightInsets;
            self.GreenDayDatePickerViewRect = CGRectMake(leftAndRightInsets/2, mainHeight/2 - datePickerHeight/2, datePickerWidth, datePickerHeight);
            self.finalCenterPoint = self.backgroundView.center;
            
        }
            break;
        
        case DayDatePickerBottomType:
        {
            CGFloat mainHeight = CGRectGetHeight(self.superView.frame);
            CGFloat mainWidth  = CGRectGetWidth(self.superView.frame);
            CGFloat datePickerHeight = mainHeight/2.2;
            self.GreenDayDatePickerViewRect = CGRectMake(0, mainHeight - datePickerHeight, mainWidth, datePickerHeight);
            self.finalCenterPoint = CGPointMake(mainWidth/2, mainHeight - datePickerHeight/2);
        }
            break;
        
    }
    
}

- (void)setup
{
    if(self.daysTableView.superview)
    {
        return;
    }
    if(!self.rowHeight)
    {
        self.rowHeight = 44;
    }
    self.centralRowOffset = (self.frame.size.height - self.rowHeight) / 2;
    
    CGRect frame = self.bounds;
    frame.size.width = self.frame.size.width / 2.8;
    
    self.daysTableView = [self dayDatePickerTableViewWithFrame:frame type:GreenDayDatePickerViewColumnTypeDay];
    [self addSubview:self.daysTableView];
    
    frame.origin.x = frame.size.width;
    frame.size.width = self.frame.size.width / 2.5;
    
    self.monthsTableView = [self dayDatePickerTableViewWithFrame:frame type:GreenDayDatePickerViewColumnTypeMonth];
    [self addSubview:self.monthsTableView];
    
    frame.size.width = self.frame.size.width - frame.origin.x - frame.size.width;
    frame.origin.x = self.frame.size.width - frame.size.width;
    
    self.yearsTableView = [self dayDatePickerTableViewWithFrame:frame type:GreenDayDatePickerViewColumnTypeYear];
    [self addSubview:self.yearsTableView];
    
    
    self.overlayView = [[UIView alloc] init];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.2;
    self.overlayView.userInteractionEnabled = NO;
    
    CGRect selectionViewFrame = self.bounds;
    selectionViewFrame.origin.y = self.centralRowOffset;
    selectionViewFrame.size.height = self.rowHeight;
    self.overlayView.frame = selectionViewFrame;
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), topBarHeight)];
    [toolBar setTintColor:[UIColor colorWithRed:0.2662 green:0.2665 blue:0.2662 alpha:1.0]];

    self.saveButton = [[UIBarButtonItem alloc]initWithTitle:kSaveTitle style:UIBarButtonItemStyleDone target:self action:@selector(saveDateAndDoneEdit:)];
    self.todayButton = [[UIBarButtonItem alloc]initWithTitle:kTodayButton style:UIBarButtonItemStyleDone target:self action:@selector(setTodayDate:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:self.todayButton, space, self.saveButton, nil]];
    
    [self addSubview:toolBar];
    [self addSubview:self.overlayView];
    
    _calendar = [NSCalendar currentCalendar];
    self.minimumDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day  = 0;
    offsetComponents.month  = 0;
    offsetComponents.year  = maxYearForSelection;
    self.maximumDate = [calendar dateByAddingComponents:offsetComponents toDate:[NSDate date]options:0];
    [self setDate:[NSDate date] updateComponents:YES];
}


- (void) showDayDatePicker
{
    [self.superView endEditing:YES];
    self.backgroundView.alpha = 0;
    [self.superView addSubview:self.backgroundView];
    [self.superView addSubview:self];
    [self setCenter:CGPointMake(self.backgroundView.center.x, CGRectGetMaxY(self.superView.frame) + CGRectGetHeight(self.frame))];
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.backgroundView.alpha = 100;
                         [self setCenter:self.finalCenterPoint];
                         
                     } completion:nil];
}


- (void) hideDayDatePicker
{
    CGPoint center = self.center;
    CGPoint moveToBottomCenter = CGPointMake(center.x, center.y + CGRectGetHeight(self.superView.frame));
    
    [UIView animateWithDuration:kAnimationDuration delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundView.alpha = 0;
                         [self setCenter:moveToBottomCenter];
                         
                     } completion:nil];
}


- (void) setTodayDate:(UIBarButtonItem*) sender
{
    NSDate* todayDate = [NSDate new];
    [self setDate:todayDate];
}


- (void) saveDateAndDoneEdit:(UIBarButtonItem*) sender
{
    if (self.hideAfterSaveButtonPressed) [self hideDayDatePicker];
    if (self.saveDateButtonPressedBlock) self.saveDateButtonPressedBlock(sender, self.date);
}



- (UITableView *)dayDatePickerTableViewWithFrame:(CGRect)frame type:(GreenDayDatePickerViewColumnType)type
{
    UITableView *tableView =
    tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.rowHeight = self.rowHeight;
    tableView.contentInset = UIEdgeInsetsMake(self.centralRowOffset, 0, self.centralRowOffset, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
    return tableView;
}

- (void)setDate:(NSDate *)date
{
    if([date compare:self.minimumDate] == NSOrderedAscending)
    {
        [self setDate:self.minimumDate updateComponents:YES];
    }
    else if ([date compare:self.maximumDate] == NSOrderedDescending)
    {
        [self setDate:self.maximumDate updateComponents:YES];
    }
    else
    {
        [self setDate:date updateComponents:YES];
    }
}

- (void) setMainBackgroundColor:(UIColor *)mainBackgroundColor
{
    [_backgroundView setBackgroundColor:mainBackgroundColor];
    [self reload];
}

- (void) setDatePickerSelectionColor:(UIColor *)datePickerSelectionColor
{
    _overlayView.backgroundColor = datePickerSelectionColor;
    [self reload];
}

- (void) setTodayButtonTitle:(NSString *)todayButtonTitle
{
    _todayButtonTitle = todayButtonTitle;
    [self.todayButton setTitle:todayButtonTitle];
}

- (void) setSaveButtonTitle:(NSString *)saveButtonTitle
{
    _saveButtonTitle = saveButtonTitle;
    [self.saveButton setTitle:saveButtonTitle];
}

- (void)setDate:(NSDate *)date updateComponents:(BOOL)updateComponents {
    _date = date;
    if(updateComponents) {
        self.components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
        [self selectRow:self.components.day - 1 inTableView:self.daysTableView animated:YES updateComponents:NO];
        [self selectRow:self.components.month - 1 inTableView:self.monthsTableView animated:YES updateComponents:NO];
        NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
        [self selectRow:self.components.year - minimumDateComponents.year inTableView:self.yearsTableView animated:YES updateComponents:NO];
        [self reload];
    }
    if (self.didSelectDateBlock) self.didSelectDateBlock(self.date);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if(tableView == self.daysTableView)
    {
        numberOfRows = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date].length;
    }
    else if(tableView == self.monthsTableView)
    {
        numberOfRows = [self.calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date].length;
    }
    else if(tableView == self.yearsTableView)
    {
        NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
        //NSDateComponents *todaysDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        NSDateComponents *maximumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.maximumDate];
        numberOfRows = (maximumDateComponents.year - minimumDateComponents.year) + 1;
        if (numberOfRows < 1)
        {
            numberOfRows = 1;
        }
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    GreenDayDatePickerViewColumnType columType = GreenDayDatePickerViewColumnTypeDay;
    BOOL disabled = NO;
    
    NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
    NSDateComponents *maximumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.maximumDate];
    
    NSDateComponents *dateComponents = [self.components copy];
    
    if(tableView == self.daysTableView)
    {
        dateComponents.day = indexPath.row + 1;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        cell.textLabel.text = [self.dayDateFormatter stringFromDate:date];
        
        if((dateComponents.day < minimumDateComponents.day && dateComponents.month <= minimumDateComponents.month && dateComponents.year <= minimumDateComponents.year) || (dateComponents.day > maximumDateComponents.day && dateComponents.month >= maximumDateComponents.month && dateComponents.year >= maximumDateComponents.year))
        {
            disabled = YES;
        }
        columType = GreenDayDatePickerViewColumnTypeDay;
    }
    else if(tableView == self.monthsTableView)
    {
        dateComponents.day = 1;
        dateComponents.month = indexPath.row + 1;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        cell.textLabel.text = [self.monthDateFormatter stringFromDate:date];
        
        if((dateComponents.month < minimumDateComponents.month && dateComponents.year <= minimumDateComponents.year) || (dateComponents.month > maximumDateComponents.month && dateComponents.year >= maximumDateComponents.year))
        {
            disabled = YES;
        }
        columType = GreenDayDatePickerViewColumnTypeDay;
    }
    else if(tableView == self.yearsTableView)
    {
        dateComponents.year = minimumDateComponents.year + indexPath.row;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        cell.textLabel.text = [self.yearDateFormatter stringFromDate:date];
        
        if(dateComponents.year < minimumDateComponents.year)
        {
            disabled = YES;
        }
        columType = GreenDayDatePickerViewColumnTypeDay;
    }
    
    if(self.fontForRow)
    {
        cell.textLabel.font = self.fontForRow;
    }
    if(self.textColorForRow)
    {
        cell.textLabel.textColor = self.textColorForRow;
    }
    else
    {
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    if(self.backgroundColorForRow)
    {
        tableView.backgroundColor = self.backgroundColorForRow;
        cell.backgroundColor = self.backgroundColorForRow;
    }
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self alignTableViewToRowBoundary:(UITableView *)scrollView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView
{
    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
    const NSUInteger row = round(relativeOffset.y / tableView.rowHeight);
    
    [self selectRow:row inTableView:tableView animated:YES updateComponents:YES];
}

- (void)selectRow:(NSInteger)row inTableView:(UITableView *)tableView animated:(BOOL)animated updateComponents:(BOOL)updateComponents
{
    const CGPoint alignedOffset = CGPointMake(0, row * tableView.rowHeight - tableView.contentInset.top);
    [tableView setContentOffset:alignedOffset animated:animated];
    
    if(updateComponents)
    {
        if(tableView == self.daysTableView)
        {
            self.components.day = row + 1;
        }
        else if(tableView == self.monthsTableView)
        {
            self.components.month = row + 1;
        }
        else if(tableView == self.yearsTableView)
        {
            self.components.year = [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate];
            NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
            self.components.year = minimumDateComponents.year + row;
        }
        self.date = [self.calendar dateFromComponents:self.components];
        [self.daysTableView reloadData];
    }
}

- (void)reload
{
    [self.daysTableView reloadData];
    [self.monthsTableView reloadData];
    [self.yearsTableView reloadData];
}

- (NSDateFormatter *)dayDateFormatter
{
    if(!_dayDateFormatter)
    {
        _dayDateFormatter = [[NSDateFormatter alloc]init];
        _dayDateFormatter.dateFormat = @"EEE d";
    }
    return _dayDateFormatter;
}

- (void)setDayDateFormatter:(NSDateFormatter *)dayDateFormatter
{
    _dayDateFormatter = dayDateFormatter;
    [self.daysTableView reloadData];
}

- (NSDateFormatter *)monthDateFormatter
{
    if(!_monthDateFormatter)
    {
        _monthDateFormatter = [[NSDateFormatter alloc]init];
        _monthDateFormatter.dateFormat = @"MMMM";
    }
    return _monthDateFormatter;
}

- (void)setMonthDateFormatter:(NSDateFormatter *)monthDateFormatter
{
    _monthDateFormatter = monthDateFormatter;
    [self.monthsTableView reloadData];
}

- (NSDateFormatter *)yearDateFormatter
{
    if(!_yearDateFormatter) {
        _yearDateFormatter = [[NSDateFormatter alloc]init];
        _yearDateFormatter.dateFormat = @"yyyy";
    }
    return _yearDateFormatter;
}

- (void)setYearDateFormatter:(NSDateFormatter *)yearDateFormatter
{
    _yearDateFormatter = yearDateFormatter;
    [self.yearsTableView reloadData];
}

- (void)setCalendar:(NSCalendar *)calendar
{
    _calendar = calendar;
    [self reload];
}

- (void)dealloc
{
    NSLog(@"GreenDayDatePickerView dealloc");
}
@end
