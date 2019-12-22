//
//  OverviewViewController.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "OverviewViewController.h"

BOOL isFilteredByTags(Record* record, NSArray* filterTags);
void updateTotals(Record* record, NSInteger* total, NSInteger* positiveTotal, NSInteger* negativeTotal);
NSInteger nearestInt(float f)
{
    return ((NSInteger)(f * 2.0) /2);
}

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
    NSInteger total = 0.0;
    NSInteger positiveTotal = 0.0;
    NSInteger negativeTotal = 0.0;
    NSInteger thisMonthTotal = 0.0;
    NSInteger thisMonthPositiveTotal = 0.0;
    NSInteger thisMonthNegativeTotal = 0.0;
    NSInteger lastMonthTotal = 0.0;
    NSInteger lastMonthPositiveTotal = 0.0;
    NSInteger lastMonthNegativeTotal = 0.0;
    NSArray<NSString*>* filterTags = [_inputTagFilter.stringValue componentsSeparatedByString:_tagSeparator];
    NSInteger filteredTotal = 0.0;
    NSInteger filteredPositiveTotal = 0.0;
    NSInteger filteredNegativeTotal = 0.0;
    NSInteger filteredThisMonthTotal = 0.0;
    NSInteger filteredThisMonthPositiveTotal = 0.0;
    NSInteger filteredThisMonthNegativeTotal = 0.0;
    NSInteger filteredLastMonthTotal = 0.0;
    NSInteger filteredLastMonthPositiveTotal = 0.0;
    NSInteger filteredLastMonthNegativeTotal = 0.0;
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
    _outputPositiveTotal.floatValue = positiveTotal / 100.0;
    _outputNegativeTotal.floatValue = negativeTotal / 100.0;
    _outputTotal.floatValue = total / 100.0;
    _outputThisMonthPositiveTotal.floatValue = thisMonthPositiveTotal / 100.0;
    _outputThisMonthNegativeTotal.floatValue = thisMonthNegativeTotal / 100.0;
    _outputThisMonthTotal.floatValue = thisMonthTotal / 100.0;
    _outputLastMonthPositiveTotal.floatValue = lastMonthPositiveTotal / 100.0;
    _outputLastMonthNegativeTotal.floatValue = lastMonthNegativeTotal / 100.0;
    _outputLastMonthTotal.floatValue = lastMonthTotal / 100.0;
    // filtered
    _outputFilteredPositiveTotal.floatValue = filteredPositiveTotal / 100.0;
    _outputFilteredNegativeTotal.floatValue = filteredNegativeTotal / 100.0;
    _outputFilteredTotal.floatValue = filteredTotal / 100.0;
    _outputFilteredThisMonthPositiveTotal.floatValue = filteredThisMonthPositiveTotal / 100.0;
    _outputFilteredThisMonthNegativeTotal.floatValue = filteredThisMonthNegativeTotal / 100.0;
    _outputFilteredThisMonthTotal.floatValue = filteredThisMonthTotal / 100.0;
    _outputFilteredLastMonthPositiveTotal.floatValue = filteredLastMonthPositiveTotal / 100.0;
    _outputFilteredLastMonthNegativeTotal.floatValue = filteredLastMonthNegativeTotal / 100.0;
    _outputFilteredLastMonthTotal.floatValue = filteredLastMonthTotal / 100.0;
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

void updateTotals(Record* record, NSInteger* total, NSInteger* positiveTotal, NSInteger* negativeTotal)
{
    if (!record.amount) return;
    NSInteger amount = nearestInt(record.amount.floatValue * 1000.0)/10;
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
