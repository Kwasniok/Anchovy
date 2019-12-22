//
//  OverviewViewController.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "OverviewViewController.h"

BOOL isFilteredByTags(Record* record, NSArray* filterTags);
void updateTotals(Record* record, float* total, float* positiveTotal, float* negativeTotal);

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

-(void)viewDidAppear
{
    [super viewDidAppear];
    if (_windowFrameToRestore.size.width != 0.0 && _windowFrameToRestore.size.height != 0.0)
    {
        [self.view.window setFrame: _windowFrameToRestore display:YES animate:YES];
    }
}

-(void)viewWillDisappear
{
    _windowFrameToRestore = self.view.window.frame;
    [super viewWillDisappear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize
    _tagSeparator = @",";
    _windowFrameToRestore = NSMakeRect(0.0, 0.0, 0.0, 0.0);
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
    NSArray<NSString*>* filterTags = [_inputTagFilter.stringValue componentsSeparatedByString:_tagSeparator];
    float filteredTotal = 0.0;
    float filteredPositiveTotal = 0.0;
    float filteredNegativeTotal = 0.0;
    float filteredThisMonthTotal = 0.0;
    float filteredThisMonthPositiveTotal = 0.0;
    float filteredThisMonthNegativeTotal = 0.0;
    float filteredLastMonthTotal = 0.0;
    float filteredLastMonthPositiveTotal = 0.0;
    float filteredLastMonthNegativeTotal = 0.0;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    NSDateComponents* thisMonthComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:now];
    NSDate* oneMonthAgo = [calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:now options:0];
    NSDateComponents* lastMonthComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:oneMonthAgo];
    for (Record* record in content.records)
    {
        if (record.amount)
        {
            updateTotals(record,
                         &total,
                         &positiveTotal,
                         &negativeTotal);
            if (record.date)
            {
                NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:record.date];
                if ([dateComponents isEqualTo:thisMonthComponents])
                {
                    updateTotals(record,
                                 &thisMonthTotal,
                                 &thisMonthPositiveTotal,
                                 &thisMonthNegativeTotal);
                }
                if ([dateComponents isEqualTo:lastMonthComponents])
                {
                    updateTotals(record,
                                 &lastMonthTotal,
                                 &lastMonthPositiveTotal,
                                 &lastMonthNegativeTotal);
                }
            }
            if (isFilteredByTags(record, filterTags))
            {
                updateTotals(record,
                             &filteredTotal,
                             &filteredPositiveTotal,
                             &filteredNegativeTotal);
                if (record.date)
                {
                    NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:record.date];
                    if ([dateComponents isEqualTo:thisMonthComponents])
                    {
                        updateTotals(record,
                                     &filteredThisMonthTotal,
                                     &filteredThisMonthPositiveTotal,
                                     &filteredThisMonthNegativeTotal);
                    }
                    if ([dateComponents isEqualTo:lastMonthComponents])
                    {
                        updateTotals(record,
                                     &filteredLastMonthTotal,
                                     &filteredLastMonthPositiveTotal,
                                     &filteredLastMonthNegativeTotal);
                    }
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
    // filtered
    _outputFilteredPositiveTotal.floatValue = filteredPositiveTotal;
    _outputFilteredNegativeTotal.floatValue = filteredNegativeTotal;
    _outputFilteredTotal.floatValue = filteredTotal;
    _outputFilteredThisMonthPositiveTotal.floatValue = filteredThisMonthPositiveTotal;
    _outputFilteredThisMonthNegativeTotal.floatValue = filteredThisMonthNegativeTotal;
    _outputFilteredThisMonthTotal.floatValue = filteredThisMonthTotal;
    _outputFilteredLastMonthPositiveTotal.floatValue = filteredLastMonthPositiveTotal;
    _outputFilteredLastMonthNegativeTotal.floatValue = filteredLastMonthNegativeTotal;
    _outputFilteredLastMonthTotal.floatValue = filteredLastMonthTotal;
}
@end

BOOL isFilteredByTags(Record* record, NSArray* filterTags)
{
    BOOL isFiltered = YES;
    for (NSString* filterTag in filterTags)
    {
        if (![record.tags containsObject: filterTag])
        {
            isFiltered = NO;
            break;
        }
    }
    return isFiltered;
}

void updateTotals(Record* record, float* total, float* positiveTotal, float* negativeTotal)
{
    if (!record.amount) return;
    float amount = record.amount.floatValue;
    if (amount > 0.0)
    {
        *positiveTotal += amount;
    }
    if (amount < 0.0)
    {
        *negativeTotal += amount;
    }
    *total += amount;
}
