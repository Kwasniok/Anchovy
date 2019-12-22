//
//  CurrencyNumberNSNumberTransformer.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "CurrencyNumberNSNumberTransformer.h"

@implementation CurrencyNumberNSNumberTransformer

+(Class)transformedValueClass
{
    return [CurrencyNumber self];
}

-(NSNumber*)transformedValue:(CurrencyNumber*)value
{
    if (value)
    {
        NSNumber* transformedValue = [value unit];
        return transformedValue;
    }
    return nil;
}

-(CurrencyNumber*)reverseTransformedValue:(NSNumber*)value
{
    if (value)
    {
        CurrencyNumber* transformedValue = [[CurrencyNumber alloc] initWithUnit:value];
        return transformedValue;
    }
    return nil;
}

@end
