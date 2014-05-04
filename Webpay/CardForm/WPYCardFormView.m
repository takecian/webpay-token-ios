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

@interface WPYCardFormView () <UITableViewDataSource,UITableViewDelegate, WPYCardFieldDelegate>
// card info holder
@property(nonatomic, strong) WPYCreditCard *creditCard;

// tableview
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *contentViews;
@end

static float const WPYFieldLeftMargin = 100.0f;
static float const WPYFieldTopMargin = 4.0f;
static float const WPYFieldWidth = 320.0f - WPYFieldLeftMargin;
static float const WPYFieldHeight = 45.0f;



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
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card
{
    if (self = [super initWithFrame:frame])
    {
        _creditCard = card ? card : [[WPYCreditCard alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        _titles = @[@"Number", @"Expiry", @"CVC", @"Name"];
        
        // contentViews
        CGRect fieldFrame = CGRectMake(WPYFieldLeftMargin, WPYFieldTopMargin, WPYFieldWidth, WPYFieldHeight);
        WPYAbstractCardField *numberField = [[WPYNumberField alloc] initWithFrame:fieldFrame text:_creditCard.number];
        WPYAbstractCardField *expiryField = [[WPYExpiryField alloc] initWithFrame:fieldFrame text:[_creditCard expiryInString]];
        WPYAbstractCardField *cvcField = [[WPYCvcField alloc] initWithFrame:fieldFrame text:_creditCard.cvc];
        WPYAbstractCardField *nameField = [[WPYNameField alloc] initWithFrame:fieldFrame text:_creditCard.name];
        
        _contentViews = @[numberField, expiryField, cvcField, nameField];
        [_contentViews enumerateObjectsUsingBlock:^(WPYAbstractCardField *field, NSUInteger idx, BOOL *stop){
            field.delegate = self;
        }];
    }
    return self;
}

// override designated initializer of superclass
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame card:nil];
}



#pragma mark public method
- (void)setFocusToFirstNotfilledField
{
    [self.contentViews enumerateObjectsUsingBlock:^(WPYAbstractCardField *field, NSUInteger idx, BOOL *stop){
        if (field.text.length == 0)
        {
            [field setFocus:YES];
            *stop = YES;
        }
    }];
}



#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (WPYCardFormCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WPYCardFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WPYCardFormCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier
                                          contentView:self.contentViews[indexPath.row]
                                                title:self.titles[indexPath.row]];
                
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



#pragma mark card field delegates
- (void)validValue:(NSString *)value forKey:(WPYFieldKey)key
{
    [self setCardValue:value forKey:key];
    [self validate];
}

- (void)invalidValue:(NSString *)value forKey:(WPYFieldKey)key error:(NSError *)error
{
    [self setCardValue:value forKey:key];
    [self notifyDelegateFieldName:fieldNameFromFieldKey(key) error:error];
}

- (void)setCardValue:(NSString *)value forKey:(WPYFieldKey)key
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