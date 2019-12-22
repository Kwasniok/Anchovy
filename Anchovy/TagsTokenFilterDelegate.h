//
//  TagsTokenFilterDelegate.h
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverviewViewController.h"

@interface TagsTokenFilterDelegate : NSObject <NSTokenFieldDelegate>

@property (strong) IBOutlet OverviewViewController* viewController;

@end
