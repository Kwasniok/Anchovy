//
//  Content.h
//  Anchovy
//
//  Created by Jens Kwasniok on 21.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"

@interface Content : NSObject

@property NSMutableArray<Record*>* records;

-(instancetype)init;

@end
