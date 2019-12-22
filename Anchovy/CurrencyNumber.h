//
//  CurrencyNumber.h
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyNumber : NSObject

@property NSInteger cents;

- (instancetype)initWithCents:(NSInteger)cents;
- (instancetype)initWithUnit:(NSNumber*)value;
- (NSNumber*) unit;
- (double)doubleValue;
- (float)floatValue;
- (void)add:(CurrencyNumber*)rhs;
- (void)subtract:(CurrencyNumber*)rhs;
@end
