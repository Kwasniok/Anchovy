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

@property (weak) IBOutlet NSTextField *outputPositiveTotal;
@property (weak) IBOutlet NSTextField *outputNegativeTotal;
@property (weak) IBOutlet NSTextField *outputTotal;
@property (weak) IBOutlet NSTextField *outputThisMonthPositiveTotal;
@property (weak) IBOutlet NSTextField *outputThisMonthNegativeTotal;
@property (weak) IBOutlet NSTextField *outputThisMonthTotal;
@property (weak) IBOutlet NSTextField *outputLastMonthPositiveTotal;
@property (weak) IBOutlet NSTextField *outputLastMonthNegativeTotal;
@property (weak) IBOutlet NSTextField *outputLastMonthTotal;
- (IBAction)update:(id)sender;

@end
