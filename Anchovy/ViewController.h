//
//  ViewController.h
//  Anchovy
//
//  Created by Jens Kwasniok on 20.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (strong) IBOutlet NSArrayController *recordController;
@property (strong) IBOutlet NSDateFormatter *dateFormatter;
@property (strong) IBOutlet NSNumberFormatter *amountFormatter;

@end

