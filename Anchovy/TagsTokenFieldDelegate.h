//
//  TagsTokenFieldDelegate.h
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RecordsViewController.h"

@interface TagsTokenFieldDelegate : NSObject <NSTokenFieldDelegate>

@property (strong) IBOutlet RecordsViewController* viewController;

@end
