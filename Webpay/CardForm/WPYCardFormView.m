//
//  WPYCardFormView.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// Responsibility: create subviews

#import "WPYCardFormView.h"

#import "WPYCardFormCell.h"

#import "WPYNumberField.h"
#import "WPYExpiryField.h"
#import "WPYCvcField.h"
#import "WPYNameField.h"

static float const WPYFieldLeftMargin = 90.0f;
static float const WPYFieldTopMargin = 4.0f;
static float const WPYFieldWidth = 230.0f;
static float const WPYFieldHeight = 40.0f;

@interface WPYCardFormView () <UITableViewDataSource>
{
}
@end


@implementation WPYCardFormView
{
    UITableView *_tableView;
    NSArray *_titles;
    
    NSArray *_fields;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _titles = @[@"Number", @"Expiry", @"Cvc", @"Name"];
        
        CGRect fieldFrame = CGRectMake(WPYFieldLeftMargin, WPYFieldTopMargin, WPYFieldWidth, WPYFieldHeight);
        _numberField = [[WPYNumberField alloc] initWithFrame: fieldFrame];
        _expiryField = [[WPYExpiryField alloc] initWithFrame: fieldFrame];
        _cvcField = [[WPYCvcField alloc] initWithFrame:fieldFrame];
        _nameField = [[WPYNameField alloc] initWithFrame:fieldFrame];
        _fields = @[_numberField, _expiryField, _cvcField, _nameField];
        
    }
    return self;
}


#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fields.count;
}

- (WPYCardFormCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WPYCardFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WPYCardFormCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier textField:_fields[indexPath.row]];
        [cell setTitle:_titles[indexPath.row]];
    }
    
    return cell;
}



#pragma mark hide keyboards
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end