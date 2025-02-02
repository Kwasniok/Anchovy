//
//  RecordsViewController
//  Anchovy
//
//  Created by Jens Kwasniok on 20.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "RecordsViewController.h"

@implementation RecordsViewController

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
    _windowFrameToRestore = NSMakeRect(0.0, 0.0, 0.0, 0.0);
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)add:(id)sender
{
    return [self addRecord:sender];
}

-(void)delete:(id)sender
{
    return [self removeRecord:sender];
}

- (IBAction)addRecord:(id)sender
{
    Record* record = [[Record alloc] init];
    record.date = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    record.amount = [[CurrencyNumber alloc] initWithCents:0];
    //[_recordController addObject:record];
    NSInteger index = [_recordController selectionIndex] + 1;
    if (index < 0) index = 0;
    [_recordController insertObject:record atArrangedObjectIndex:index];
}

- (IBAction)removeRecord:(id)sender
{
    [_recordController removeObjects: _recordController.selectedObjects];
}

- (IBAction)resetRecordFilter:(id)sender
{
    self.recordFilterPredicate = [NSPredicate predicateWithFormat:@"date < %@", [NSDate dateWithTimeIntervalSinceNow:0.0]];
}

@end
