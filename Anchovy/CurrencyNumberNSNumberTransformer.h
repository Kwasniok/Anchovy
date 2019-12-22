//
//  CurrencyNumberNSNumberTransformer.h
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CurrencyNumber.h"

@interface CurrencyNumberNSNumberTransformer : NSValueTransformer

-(NSNumber*)transformedValue:(CurrencyNumber*)value;
-(CurrencyNumber*)reverseTransformedValue:(NSNumber*)value;

@end
