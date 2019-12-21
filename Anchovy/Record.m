//
//  Record.m
//  Anchovy
//
//  Created by Jens Kwasniok on 21.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "Record.h"

@implementation Record

-(instancetype)initWithDate:(NSDate *)date amount:(NSNumber *)amount {
    self = [super init];
    if (self) {
        _date = date;
        _amount = amount;
    }
    return self;
}

@end
