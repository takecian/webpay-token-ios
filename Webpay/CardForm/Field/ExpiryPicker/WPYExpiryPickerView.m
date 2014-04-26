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

@end

@implementation WPYExpiryPickerView
{
    NSArray *_months;
    NSArray *_years;
    
    NSString *_selectedMonth;
    NSString *_selectedYear;
}

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

#pragma mark notify delegate
- (void)notifyDelegate
{
    if (self.expiryDelegate && [self.expiryDelegate respondsToSelector:@selector(didSelectExpiryYear:month:)])
    {
        [self.expiryDelegate didSelectExpiryYear:_selectedYear month:_selectedMonth];
    }
}

#pragma mark picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case WPYExpiryPickerMonth:
            return [_months objectAtIndex:row];
            
        case WPYExpiryPickerYear:
            return [_years objectAtIndex:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case WPYExpiryPickerMonth:
        {
            _selectedMonth = [_months objectAtIndex:[pickerView selectedRowInComponent:WPYExpiryPickerMonth]];
            break;
        }
            
        case WPYExpiryPickerYear:
        {
            _selectedYear = [_years objectAtIndex:[pickerView selectedRowInComponent:WPYExpiryPickerYear]];
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
            return _months.count;
            
        case WPYExpiryPickerYear:
            return _years.count;
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
        [years addObject:[NSString stringWithFormat:@"%d", (year + i)]];
    }
    
    return years;
}

@end