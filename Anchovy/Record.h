//
//  Record.h
//  Anchovy
//
//  Created by Jens Kwasniok on 21.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property NSDate* date;
@property NSNumber* amount;

-(instancetype)initWithDate:(NSDate*) date amount:(NSNumber*) amount;

@end