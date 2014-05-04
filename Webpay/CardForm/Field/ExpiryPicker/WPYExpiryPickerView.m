//
//  WPYExpiryPickerView.m
//  Webpay
//
//  Created by yohei on 4/14/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//


// View libraries I researched had view logic inside view.
// View libraries subclassing UIPickerView set delegate and datasource
// as itself.

#import "WPYExpiryPickerView.h"

@interface WPYExpiryPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong) NSArray *months;
@property(nonatomic, strong) NSArray *years;
@property(nonatomic, copy) NSString *selectedMonth;
@property(nonatomic, copy) NSString *selectedYear;
@end

@implementation WPYExpiryPickerView

typedef NS_ENUM(NSInteger, WPYComponents)
{
    WPYExpiryPickerMonth,
    WPYExpiryPickerYear
};

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _months = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];
        _years = [self years];
        
        _selectedMonth = @"";
        _selectedYear = @"";
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.showsSelectionIndicator = YES;
        [super setDelegate:self];
        [super setDataSource:self];
        
        // set initial value
        [self selectRow:4 inComponent:1 animated:NO];
    }
    return self;
}

// disallow setting UIPickerView delegate & datasource
- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{

}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{

}


#pragma mark public method
- (NSString *)selectedExpiry
{
    NSInteger selectedMonthRow = [self selectedRowInComponent:WPYExpiryPickerMonth];
    NSString *month = self.months[selectedMonthRow];
    
    NSInteger selectedYearRow = [self selectedRowInComponent:WPYExpiryPickerYear];
    NSString *year = self.years[selectedYearRow];
    
    return [NSString stringWithFormat:@"%@ / %@", month, year];
}



#pragma mark notify delegate
- (void)notifyDelegate
{
    if (self.expiryDelegate && [self.expiryDelegate respondsToSelector:@selector(didSelectExpiryYear:month:)])
    {
        [self.expiryDelegate didSelectExpiryYear:self.selectedYear month:self.selectedMonth];
    }
}

#pragma mark picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case WPYExpiryPickerMonth:
            return [self.months objectAtIndex:row];
            
        case WPYExpiryPickerYear:
            return [self.years objectAtIndex:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case WPYExpiryPickerMonth:
        {
            self.selectedMonth = [self.months objectAtIndex:[pickerView selectedRowInComponent:WPYExpiryPickerMonth]];
            break;
        }
            
        case WPYExpiryPickerYear:
        {
            self.selectedYear = [self.years objectAtIndex:[pickerView selectedRowInComponent:WPYExpiryPickerYear]];
            break;
        }
    }
    
    [self notifyDelegate];
}


#pragma mark picker view data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case WPYExpiryPickerMonth:
            return self.months.count;
            
        case WPYExpiryPickerYear:
            return self.years.count;
    }
    
    return 0;
}


#pragma mark helper
- (NSInteger)currentYear
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:now];
    return comps.year;
}

- (NSArray *)years
{
    NSInteger year = [self currentYear];
    NSMutableArray *years = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++)
    {
        [years addObject:[@(year + i) stringValue]];
    }
    
    return years;
}

@end