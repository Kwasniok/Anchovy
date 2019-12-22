//
//  MainViewController.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    // Forward represented object to child view controllers.
    for (NSTabViewItem* item in self.tabViewItems)
    {
        [item.viewController setRepresentedObject:representedObject];
    }
}

@end
