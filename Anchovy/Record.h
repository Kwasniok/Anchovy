//
//  Record.h
//  Anchovy
//
//  Created by Jens Kwasniok on 21.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CurrencyNumber.h"

@interface Record : NSObject

@property NSDate* date;
@property CurrencyNumber* amount;
@property NSArray<NSString*>* tags;

@end
