//
//  OverviewViewController.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "OverviewViewController.h"

BOOL isFilteredByTags(Record* record, NSArray* filterTags);
void updateTotals(Record* record, CurrencyNumber* total, CurrencyNumber* positiveTotal, CurrencyNumber* negativeTotal);

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
    // update totals
    [self updateTotals];
    [self updateFilteredTotals];
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

- (IBAction)tagFilterAction:(id)sender
{
    [self updateFilteredTotals];
}

- (void)updateTotals
{
    Content* content = self.representedObject;
    CurrencyNumber* total= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* positiveTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* negativeTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* thisMonthTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* thisMonthPositiveTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* thisMonthNegativeTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* lastMonthTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* lastMonthPositiveTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* lastMonthNegativeTotal= [[CurrencyNumber alloc] initWithCents:0];
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
                         total,
                         positiveTotal,
                         negativeTotal);
            if (record.date)
            {
                NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:record.date];
                if ([dateComponents isEqualTo:thisMonthComponents])
                {
                    updateTotals(record,
                                 thisMonthTotal,
                                 thisMonthPositiveTotal,
                                 thisMonthNegativeTotal);
                }
                if ([dateComponents isEqualTo:lastMonthComponents])
                {
                    updateTotals(record,
                                 lastMonthTotal,
                                 lastMonthPositiveTotal,
                                 lastMonthNegativeTotal);
                }
            }
        }
    }
    _outputPositiveTotal.floatValue = positiveTotal.floatValue;
    _outputNegativeTotal.floatValue = negativeTotal.floatValue;
    _outputTotal.floatValue = total.floatValue;
    _outputThisMonthPositiveTotal.floatValue = thisMonthPositiveTotal.floatValue;
    _outputThisMonthNegativeTotal.floatValue = thisMonthNegativeTotal.floatValue;
    _outputThisMonthTotal.floatValue = thisMonthTotal.floatValue;
    _outputLastMonthPositiveTotal.floatValue = lastMonthPositiveTotal.floatValue;
    _outputLastMonthNegativeTotal.floatValue = lastMonthNegativeTotal.floatValue;
    _outputLastMonthTotal.floatValue = lastMonthTotal.floatValue;
}

- (void)updateFilteredTotals
{
    Content* content = self.representedObject;
    NSArray<NSString*>* filterTags = [_inputTagFilter.stringValue componentsSeparatedByString:_tagSeparator];
    if (filterTags.count == 0)
    {
        // No matches possible without tags.
        return;
    }
    CurrencyNumber* filteredTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredPositiveTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredNegativeTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredThisMonthTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredThisMonthPositiveTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredThisMonthNegativeTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredLastMonthTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredLastMonthPositiveTotal= [[CurrencyNumber alloc] initWithCents:0];
    CurrencyNumber* filteredLastMonthNegativeTotal= [[CurrencyNumber alloc] initWithCents:0];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    NSDateComponents* thisMonthComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:now];
    NSDate* oneMonthAgo = [calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:now options:0];
    NSDateComponents* lastMonthComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:oneMonthAgo];
    for (Record* record in content.records)
    {
        if (record.amount && isFilteredByTags(record, filterTags))
        {
            updateTotals(record,
                         filteredTotal,
                         filteredPositiveTotal,
                         filteredNegativeTotal);
            if (record.date)
            {
                NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:record.date];
                if ([dateComponents isEqualTo:thisMonthComponents])
                {
                    updateTotals(record,
                                 filteredThisMonthTotal,
                                 filteredThisMonthPositiveTotal,
                                 filteredThisMonthNegativeTotal);
                }
                if ([dateComponents isEqualTo:lastMonthComponents])
                {
                    updateTotals(record,
                                 filteredLastMonthTotal,
                                 filteredLastMonthPositiveTotal,
                                 filteredLastMonthNegativeTotal);
                }
            }
        }
    }
    _outputFilteredPositiveTotal.floatValue = filteredPositiveTotal.floatValue;
    _outputFilteredNegativeTotal.floatValue = filteredNegativeTotal.floatValue;
    _outputFilteredTotal.floatValue = filteredTotal.floatValue;
    _outputFilteredThisMonthPositiveTotal.floatValue = filteredThisMonthPositiveTotal.floatValue;
    _outputFilteredThisMonthNegativeTotal.floatValue = filteredThisMonthNegativeTotal.floatValue;
    _outputFilteredThisMonthTotal.floatValue = filteredThisMonthTotal.floatValue;
    _outputFilteredLastMonthPositiveTotal.floatValue = filteredLastMonthPositiveTotal.floatValue;
    _outputFilteredLastMonthNegativeTotal.floatValue = filteredLastMonthNegativeTotal.floatValue;
    _outputFilteredLastMonthTotal.floatValue = filteredLastMonthTotal.floatValue;
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

void updateTotals(Record* record, CurrencyNumber* total, CurrencyNumber* positiveTotal, CurrencyNumber* negativeTotal)
{
    if (!record.amount) return;
    CurrencyNumber* amount = record.amount;
    if (amount.cents > 0.0)
    {
        [positiveTotal add: amount];
    }
    if (amount.cents < 0.0)
    {
        [negativeTotal subtract: amount];
    }
    [total add: amount];
}
