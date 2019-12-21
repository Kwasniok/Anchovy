//
//  RecordsViewController
//  Anchovy
//
//  Created by Jens Kwasniok on 20.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "RecordsViewController.h"

@implementation RecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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
    record.amount = [[NSNumber alloc] initWithFloat:0.0];
    [_recordController addObject:record];
}

- (IBAction)removeRecord:(id)sender
{
    [_recordController removeObjects: _recordController.selectedObjects];
}
@end