//
//  WPYCreditCardTest.m
//  Webpay
//
//  Created by yohei on 3/14/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYCreditCard.h"
#import "WPYErrors.h"

@implementation NSDate(WPYTest)
//overriding +date method for testing
+ (NSDate *)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2014];
    [comps setMonth:3];
    [comps setDay:31];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [gregorianCal dateFromComponents:comps];
}
@end

@interface WPYCreditCardTest : XCTestCase

@end

@implementation WPYCreditCardTest
{
    WPYCreditCard *_creditCard;
}

- (void)setUp
{
    [super setUp];
    
    _creditCard = [[WPYCreditCard alloc] init];
}

- (void)tearDown
{
    _creditCard = nil;
    
    [super tearDown];
}


#pragma mark brandName
- (void)testBrandNameReturnsNilForEmptyNumber
{
    _creditCard.number = nil;
    XCTAssertNil([_creditCard brandName], @"brandName should return nil for empty card number.");
}

- (void)testBrandNameDiscernsVisa
{
    NSString *visaCardNumber = @"4111111111111111";
    _creditCard.number = visaCardNumber;
    XCTAssertEqualObjects([_creditCard brandName], @"Visa", @"It should be recongnized as visa.");
}

- (void)testBrandNameDiscernsAmex
{
    NSString *amexCardNumber = @"378282246310005";
    _creditCard.number = amexCardNumber;
    XCTAssertEqual([_creditCard brandName], @"American Express", @"It should be recognized as amex.");
}

- (void)testBrandNameDiscernsMasterCard
{
    NSString *masterCardNumber = @"5555555555554444";
    _creditCard.number = masterCardNumber;
    XCTAssertEqual([_creditCard brandName], @"MasterCard", @"It should be recognized as master card.");
}

- (void)testBrandNameDiscernsDiscover
{
    NSString *discoverCardNumber = @"6011111111111117";
    _creditCard.number = discoverCardNumber;
    XCTAssertEqual([_creditCard brandName], @"Discover", @"It should be recognized as discover.");
}

- (void)testBrandNameDiscernsJCB
{
    NSString *JCBCardNumber = @"3530111333300000";
    _creditCard.number = JCBCardNumber;
    XCTAssertEqual([_creditCard brandName], @"JCB", @"It should be recognized as JCB.");
}

- (void)testBrandNameDiscernsDiners
{
    NSString *dinersCardNumber = @"30569309025904";
    _creditCard.number = dinersCardNumber;
    XCTAssertEqual([_creditCard brandName], @"Diners", @"It should be recognized as diners.");
}

- (void)testBrandNameDicernsUnknown
{
    NSString *unknownCardNumber = @"9876543210123456";
    _creditCard.number = unknownCardNumber;
    XCTAssertEqual([_creditCard brandName], @"Unknown", @"It should be recognized as unknown.");
}



#pragma mark - property validation

#pragma mark validateName
- (void)testValidateNameAcceptsNilAsErrorArgument
{
    NSString *name = nil;
    XCTAssertNoThrow([_creditCard validateName:&name error:nil], @"Second argument should accept nil.");
}

- (void)testNilName
{
    NSString *name = nil;
    XCTAssertFalse([_creditCard validateName:&name error:nil], @"It should invalidate nil name.");
}

- (void)testNilNameReturnsExpectedError
{
    NSError *error;
    NSString *name = nil;
    [_creditCard validateName:&name error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidName, @"Error code should be WPYInvalidName.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid name.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"Name should not be nil.", @"It should return expected failure reason.");
}

- (void)testEmptyStrAsName
{
    NSString *name = @"    ";
    XCTAssertFalse([_creditCard validateName:&name error:nil], @"It should invalidate empty string for a name");
}

- (void)testEmptyStrAsNameReturnsExpectedError
{
    NSError *error;
    NSString *name = @"   ";
    [_creditCard validateName:&name error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidName, @"Error code should be WPYInvalidName.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid name.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"Name should not be empty.", @"It should return expected failure reason.");
}

- (void)testValidName
{
    NSError *error;
    NSString *name = @"Yohei Okada";
    XCTAssertTrue([_creditCard validateName:&name error:&error], @"It should validate name.");
    XCTAssertNil(error, @"Error object should be nil.");
}


#pragma mark validateCvc
- (void)testValidateCvcAcceptsNilAsErrorArgument
{
    NSString *cvc = nil;
    XCTAssertNoThrow([_creditCard validateCvc:&cvc error:nil], @"Second argument should accept nil.");
}

- (void)testNilCvc
{
    NSError *error;
    NSString *cvc = nil;
    XCTAssertFalse([_creditCard validateCvc:&cvc error: &error], @"Nil cvc should be invalidated.");
}

- (void)testNilCvcReturnsExpectedError
{
    NSError *error;
    NSString *cvc = nil;
    [_creditCard validateCvc:&cvc error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidCvc, @"Error code should be WPYInvalidCvc.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid cvc.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"cvc should not be nil.", @"It should return expected failure reason.");
}

- (void)testNonNumericCvc
{
    NSString *cvc = @"1a4";
    XCTAssertFalse([_creditCard validateCvc:&cvc error:nil], @"It should invalidate non numeric cvc.");
}

- (void)testNonNumericCvcReturnsExpectedError
{
    NSError *error;
    NSString *cvc = @"1a5";
    [_creditCard validateCvc:&cvc error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidCvc, @"Error code should be WPYInvalidCvc.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid cvc.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"cvc should be numeric only.", @"It should return expected failure reason.");
}

- (void)testTwoDigitsCvc
{
    NSString *cvc = @"12";
    XCTAssertFalse([_creditCard validateCvc:&cvc error:nil], @"It should invalidate 2 digits cvc.");
}

- (void)testThreeDigitsCvc
{
    NSError *error;
    NSString *cvc = @"123";
    XCTAssertTrue([_creditCard validateCvc:&cvc error: &error], @"It should validate 3 digits cvc.");
    XCTAssertNil(error, @"It should not populate error object.");
}

- (void)testFourDigitsCvc
{
    NSError *error;
    NSString *cvc = @"1234";
    XCTAssertTrue([_creditCard validateCvc:&cvc error: &error], @"It should validate 4 digits cvc.");
    XCTAssertNil(error, @"It should not populate error object.");
}

- (void)testFiveDigitsCvc
{
    NSString *cvc = @"12345";
    XCTAssertFalse([_creditCard validateCvc:&cvc error:nil], @"It should invalidate 5 digits cvc.");
}

- (void)testInvalidDigitsReturnsExpectedError
{
    NSError *error;
    NSString *cvc = @"12";
    [_creditCard validateCvc:&cvc error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidCvc, @"Error code should be WPYInvalidCvc.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid cvc.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"cvc should be 3 or 4 digits.", @"It should return expected failure reason.");
}

- (void)testAmexWithThreeDigits
{
    NSString *amexCardNumber = @"378282246310005";
    _creditCard.number = amexCardNumber;
    
    NSString *cvc = @"123";
    XCTAssertFalse([_creditCard validateCvc:&cvc error:nil], @"It should invalidate 3 digits cvc for amex card.");
}

- (void)testAmexWithThreeDigitsReturnsExpectedError
{
    NSError *error;
    NSString *amexCardNumber = @"378282246310005";
    _creditCard.number = amexCardNumber;
    
    NSString *cvc = @"123";
    [_creditCard validateCvc:&cvc error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidCvc, @"Error code should be WPYInvalidCvc.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid cvc.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"cvc for amex card should be 4 digits.", @"It should return expected failure reason.");
}

- (void)testAmexWithFourDigits
{
    NSString *amexCardNumber = @"378282246310005";
    _creditCard.number = amexCardNumber;
    
    NSError *error;
    NSString *cvc = @"1234";
    XCTAssertTrue([_creditCard validateCvc:&cvc error: &error], @"It should validate 4 digits cvc for amex card.");
    XCTAssertNil(error, @"It should not populate error object.");
    
}

- (void)testNonAmexCardWithThreeDigits
{
    NSString *masterCardNumber = @"5555555555554444";
    _creditCard.number = masterCardNumber;
    
    NSError *error;
    NSString *cvc = @"123";
    XCTAssertTrue([_creditCard validateCvc:&cvc error: &error], @"It should validate 3 digits cvc for non amex card.");
    XCTAssertNil(error, @"It should not populate error object.");
}

- (void)testNonAmexCardWithFourDigits
{
    NSString *masterCardNumber = @"5555555555554444";
    _creditCard.number = masterCardNumber;
    
    NSString *cvc = @"1234";
    XCTAssertFalse([_creditCard validateCvc:&cvc error:nil], @"It should invalidate 4 digits cvc for non amex card.");
}

- (void)testNonAmexCardWithFourDigitsReturnsExpectedError
{
    NSError *error;
    NSString *masterCardNumber = @"5555555555554444";
    _creditCard.number = masterCardNumber;
    
    NSString *cvc = @"1234";
    [_creditCard validateCvc:&cvc error:&error];
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidCvc, @"Error code should be WPYInvalidCvc.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid cvc.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"cvc for non amex card should be 3 digits.", @"It should return expected failure reason.");
}


#pragma mark validateExpiryMonth
- (void)testValidateExpiryMonthAcceptsNilAsErrorArgument
{
    NSNumber *expiryMonth = nil;
    XCTAssertNoThrow([_creditCard validateExpiryMonth:&expiryMonth error:nil], @"Second argument should accept nil.");
}

- (void)testNilExpiryMonth
{
    NSNumber *expiryMonth = nil;
    XCTAssertFalse([_creditCard validateExpiryMonth:&expiryMonth error:nil], @"It should invalidate nil expiryMonth.");
}

- (void)testNilExpiryMonthReturnsExpectedError
{
    NSError *error;
    NSNumber *expiryMonth = nil;
    [_creditCard validateExpiryMonth:&expiryMonth error: &error];
    
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidExpiryMonth, @"Error code should be WPYInvalidExpiryMonth.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid expiry month.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"Expiry month should not be nil.", @"It should return expected failure reason.");
}

- (void)testWhenExpiryMonthIsZero
{
    NSNumber *expiryMonth = [NSNumber numberWithInt:0];
    XCTAssertFalse([_creditCard validateExpiryMonth:&expiryMonth error:nil], @"It should invalidate when expiry month is 0.");
}

- (void)testWhenExpiryMonthIsOne
{
    NSNumber *expiryMonth = [NSNumber numberWithInt:1];
    XCTAssertTrue([_creditCard validateExpiryMonth:&expiryMonth error:nil], @"It should validate when expiry month is 1.");
}

- (void)testWhenExpiryMonthIsTwelve
{
    NSNumber *expiryMonth = [NSNumber numberWithInt:12];
    XCTAssertTrue([_creditCard validateExpiryMonth:&expiryMonth error:nil], @"It should validate when expiry month is 12.");
}

- (void)testWhenExpiryMonthIsThirteen
{
    NSNumber *expiryMonth = [NSNumber numberWithInt:13];
    XCTAssertFalse([_creditCard validateExpiryMonth:&expiryMonth error:nil], @"It should invalidate when expiry month is 13.");
}

- (void)testInvalidExpiryMonthRangeReturnsExpectedError
{
    NSError *error;
    NSNumber *expiryMonth = [NSNumber numberWithInt:13];
    [_creditCard validateExpiryMonth:&expiryMonth error: &error];
    
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidExpiryMonth, @"Error code should be WPYInvalidExpiryMonth.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid expiry month.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"Expiry month should be a number between 1 to 12.", @"It should return expected failure reason.");
}

#pragma mark validateExpiryYear
- (void)testValidateExpiryYearAcceptsNilAsErrorArgument
{
    NSNumber *expiryYear = nil;
    XCTAssertNoThrow([_creditCard validateExpiryYear:&expiryYear error:nil], @"Second argument should accept nil.");
}

- (void)testNilExpiryYear
{
    NSNumber *expiryYear = nil;
    XCTAssertFalse([_creditCard validateExpiryYear:&expiryYear error:nil], @"It should invalidate nil expiry year.");
}

- (void)testNilExpiryYearReturnsExpectedError
{
    NSError *error;
    NSNumber *expiryYear = nil;
    
    [_creditCard validateExpiryYear:&expiryYear error:&error];
    
    XCTAssertNotNil(error, @"Error object should not be nil.");
    XCTAssertEqual([error domain], WPYErrorDomain, @"Error domain should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidExpiryYear, @"Error code should be WPYInvalidExpiryYear.");
    XCTAssertEqual([error localizedDescription], @"Card error: invalid expiry year.", @"It should return expected localized description.");
    NSDictionary *userInfo = [error userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqual(failureReason, @"Expiry year should not be nil.", @"It should return expected failure reason.");
}


#pragma mark validateExpiry
- (void)testWhenExpiryIsOneYearAgo
{
    int year = 2013;
    int month = 3;
    XCTAssertFalse([_creditCard validateExpiryYear:year month:month], @"It should invalidate if expiry date is a year ago.");
}

- (void)testWhenExpiryIsOneMonthAgo
{
    int year = 2014;
    int month = 2;
    XCTAssertFalse([_creditCard validateExpiryYear:year month:month], @"It should invalidate if expiry date is a month a go.");
}

- (void)testWhenExpiryIsThisMonth
{
    int year = 2014;
    int month = 3;
    XCTAssertTrue([_creditCard validateExpiryYear:year month:month], @"It should validate if expiry month is this month.");
}

- (void)testWhenExpiryIsNextMonth
{
    int year = 2014;
    int month = 4;
    XCTAssertTrue([_creditCard validateExpiryYear:year month:month], @"It should validate if expiry month is next month");
}

- (void)testWhenExpiryIsNextYear
{
    int year = 2015;
    int month = 3;
    XCTAssertTrue([_creditCard validateExpiryYear:year month:month], @"It should validate if expiry year is next year.");
}




@end
