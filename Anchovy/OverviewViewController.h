//
//  OverviewViewController.h
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "Content.h"

@interface OverviewViewController : NSViewController
{
    NSRect _windowFrameToRestore;
}

@property NSString* tagSeparator;
@property (weak) IBOutlet NSTextField *outputPositiveTotal;
@property (weak) IBOutlet NSTextField *outputNegativeTotal;
@property (weak) IBOutlet NSTextField *outputTotal;
@property (weak) IBOutlet NSTextField *outputThisMonthPositiveTotal;
@property (weak) IBOutlet NSTextField *outputThisMonthNegativeTotal;
@property (weak) IBOutlet NSTextField *outputThisMonthTotal;
@property (weak) IBOutlet NSTextField *outputLastMonthPositiveTotal;
@property (weak) IBOutlet NSTextField *outputLastMonthNegativeTotal;
@property (weak) IBOutlet NSTextField *outputLastMonthTotal;
@property (weak) IBOutlet NSTokenField *inputTagFilter;
@property (weak) IBOutlet NSTextField *outputFilteredPositiveTotal;
@property (weak) IBOutlet NSTextField *outputFilteredNegativeTotal;
@property (weak) IBOutlet NSTextField *outputFilteredTotal;
@property (weak) IBOutlet NSTextField *outputFilteredThisMonthPositiveTotal;
@property (weak) IBOutlet NSTextField *outputFilteredThisMonthNegativeTotal;
@property (weak) IBOutlet NSTextField *outputFilteredThisMonthTotal;
@property (weak) IBOutlet NSTextField *outputFilteredLastMonthPositiveTotal;
@property (weak) IBOutlet NSTextField *outputFilteredLastMonthNegativeTotal;
@property (weak) IBOutlet NSTextField *outputFilteredLastMonthTotal;
- (IBAction)update:(id)sender;

@end
