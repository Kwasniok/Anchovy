//
//  OverviewViewController.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "OverviewViewController.h"

@interface OverviewViewController ()

@end

@implementation OverviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

- (IBAction)update:(id)sender
{
    Content* content = self.representedObject;
    float total = 0.0;
    float positiveTotal = 0.0;
    float negativeTotal = 0.0;
    for (Record* record in content.records)
    {
        NSNumber* amount = record.amount;
        if (amount)
        {
            float amt = amount.floatValue;
            if (amt > 0.0)
            {
                positiveTotal += amt;
            }
            if (amt < 0.0)
            {
                negativeTotal += amt;
            }
            total += amt;
        }
    }
    _outputPositiveTotal.floatValue = positiveTotal;
    _outputNegativeTotal.floatValue = negativeTotal;
    _outputTotal.floatValue = total;
}
@end
