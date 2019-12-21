//
//  Content.m
//  Anchovy
//
//  Created by Jens Kwasniok on 21.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "Content.h"

@implementation Content

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _records = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
