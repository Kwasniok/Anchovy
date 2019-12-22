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

-(void)viewWillAppear
{
    // needed for auto resize (e.g. in tab view)
    // fits to smallest size compatible with constrains (of dummy element)
    [super viewWillAppear];
    self.preferredContentSize = self.view.fittingSize;
}

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
    float thisMonthTotal = 0.0;
    float thisMonthPositiveTotal = 0.0;
    float thisMonthNegativeTotal = 0.0;
    float lastMonthTotal = 0.0;
    float lastMonthPositiveTotal = 0.0;
    float lastMonthNegativeTotal = 0.0;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    NSDateComponents* thisMonthComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:now];
    NSDate* oneMonthAgo = [calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:now options:0];
    NSDateComponents* lastMonthComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:oneMonthAgo];
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
            if (record.date)
            {
                NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:record.date];
                if ([dateComponents isEqualTo:thisMonthComponents])
                {
                    if (amt > 0.0)
                    {
                        thisMonthPositiveTotal += amt;
                    }
                    if (amt < 0.0)
                    {
                        thisMonthNegativeTotal += amt;
                    }
                    thisMonthTotal += amt;
                }
                if ([dateComponents isEqualTo:lastMonthComponents])
                {
                    if (amt > 0.0)
                    {
                        lastMonthPositiveTotal += amt;
                    }
                    if (amt < 0.0)
                    {
                        lastMonthNegativeTotal += amt;
                    }
                    lastMonthTotal += amt;
                }
            }
        }
    }
    _outputPositiveTotal.floatValue = positiveTotal;
    _outputNegativeTotal.floatValue = negativeTotal;
    _outputTotal.floatValue = total;
    _outputThisMonthPositiveTotal.floatValue = thisMonthPositiveTotal;
    _outputThisMonthNegativeTotal.floatValue = thisMonthNegativeTotal;
    _outputThisMonthTotal.floatValue = thisMonthTotal;
    _outputLastMonthPositiveTotal.floatValue = lastMonthPositiveTotal;
    _outputLastMonthNegativeTotal.floatValue = lastMonthNegativeTotal;
    _outputLastMonthTotal.floatValue = lastMonthTotal;
}
@end
