//
//  WPYCardFormView.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// Responsibility: create subviews

#import "WPYCardFormView.h"

#import "WPYCreditCard.h"

#import "WPYCardFormCell.h"

#import "WPYAbstractCardField.h"
#import "WPYNumberField.h"
#import "WPYExpiryField.h"
#import "WPYCvcField.h"
#import "WPYNameField.h"

@interface WPYCardFormView () <UITableViewDataSource, WPYCardFieldDelegate>
// card info holder
@property(nonatomic, strong) WPYCreditCard *creditCard;

// fields
@property(nonatomic, strong) WPYNumberField *numberField;
@property(nonatomic, strong) WPYExpiryField *expiryField;
@property(nonatomic, strong) WPYCvcField *cvcField;
@property(nonatomic, strong) WPYNameField *nameField;

// tableview
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *fields;
@end

static float const WPYFieldLeftMargin = 110.0f;
static float const WPYFieldTopMargin = 3.0f;
static float const WPYFieldWidth = 320.0f - WPYFieldLeftMargin;
static float const WPYFieldHeight = 40.0f;



#pragma mark helpers
static NSString *fieldNameFromFieldKey(WPYFieldKey key)
{
    switch (key)
    {
        case WPYNumberFieldKey:
            return @"Number";
            
        case WPYExpiryFieldKey:
            return @"Expiry";
            
        case WPYCvcFieldKey:
            return @"Cvc";
            
        case WPYNameFieldKey:
            return @"Name";
    }
}

@implementation WPYCardFormView
#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _creditCard = [[WPYCreditCard alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _titles = @[@"Number", @"Expiry", @"CVC", @"Name"];
//        _titles = @[@"カード番号", @"有効期限", @"セキュリティコード", @"カード名義"];
        
        // fields
        CGRect fieldFrame = CGRectMake(WPYFieldLeftMargin, WPYFieldTopMargin, WPYFieldWidth, WPYFieldHeight);
        _numberField = [[WPYNumberField alloc] initWithFrame:fieldFrame];
        _numberField.delegate = self;
        
        _expiryField = [[WPYExpiryField alloc] initWithFrame:fieldFrame];
        _expiryField.delegate = self;
        
        _cvcField = [[WPYCvcField alloc] initWithFrame:fieldFrame];
        _cvcField.delegate = self;
        
        _nameField = [[WPYNameField alloc] initWithFrame:fieldFrame];
        _nameField.delegate = self;
        
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
    return self.fields.count;
}

- (WPYCardFormCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WPYCardFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WPYCardFormCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier
                                                field:self.fields[indexPath.row]
                                                title:self.titles[indexPath.row]];
    }
    
    return cell;
}



#pragma mark card field delegates
- (void)validValue:(NSString *)value forKey:(WPYFieldKey)key
{
    switch (key)
    {
        case WPYNumberFieldKey:
            self.creditCard.number = value;
            break;
            
        case WPYExpiryFieldKey:
            self.creditCard.expiryMonth = [[value substringToIndex:2] integerValue];
            self.creditCard.expiryYear = [[value substringFromIndex:5] integerValue];
            break;
            
        case WPYCvcFieldKey:
            self.creditCard.cvc = value;
            break;
            
        case WPYNameFieldKey:
            self.creditCard.name = value;
            break;
    }
    
    [self validate];
}

- (void)invalidValue:(NSString *)value forKey:(WPYFieldKey)key error:(NSError *)error
{
    [self notifyDelegateFieldName:fieldNameFromFieldKey(key) error:error];
}



#pragma mark validation
- (void)validate
{
    if ([self.creditCard validate:nil])
    {
        [self notifyDelegateValidForm:self.creditCard];
    }
}



#pragma mark notify delegate
- (void)notifyDelegateFieldName:(NSString *)fieldName error:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(invalidFieldName:error:)])
    {
        [self.delegate invalidFieldName:fieldName error:error];
    }
}

- (void)notifyDelegateValidForm:(WPYCreditCard *)creditCard
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(validFormWithCard:)])
    {
        [self.delegate validFormWithCard:creditCard];
    }
}



#pragma mark hide keyboards
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end