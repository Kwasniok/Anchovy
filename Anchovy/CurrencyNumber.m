//
//  CurrencyNumber.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "CurrencyNumber.h"

@implementation CurrencyNumber

-(instancetype)initWithCents:(NSInteger)cents
{
    self = [super init];
    if (self)
    {
        _cents = cents;
    }
    return self;
}

-(instancetype)initWithUnit:(NSNumber *)value
{
    self = [super init];
    if (self)
    {
        _cents = value.doubleValue * 100.0;
    }
    return self;
}

-(NSNumber *)unit
{
    NSNumber* value = [[NSNumber alloc] initWithDouble:_cents / 100.0];
    return value;
}

-(double)doubleValue
{
    return _cents / 100.0;
}

-(float)floatValue
{
    return _cents / 100.0f;
}

-(void)add:(CurrencyNumber *)rhs
{
    self.cents += rhs.cents;
}

-(void)subtract:(CurrencyNumber *)rhs
{
    self.cents += rhs.cents;
}

@end
