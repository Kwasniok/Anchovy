//
//  RecordsViewController
//  Anchovy
//
//  Created by Jens Kwasniok on 20.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Content.h"

@interface RecordsViewController : NSViewController
{
    NSRect _windowFrameToRestore;
}
@property (strong) IBOutlet NSArrayController *recordController;
@property (strong) IBOutlet NSDateFormatter *dateFormatter;
@property (strong) IBOutlet NSNumberFormatter *amountFormatter;

- (IBAction)addRecord:(id)sender;
- (IBAction)removeRecord:(id)sender;

@end

