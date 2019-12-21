//
//  Document.h
//  Anchovy
//
//  Created by Jens Kwasniok on 20.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Content.h"

@interface Document : NSDocument

@property Content* content;
@property NSString* recordSeparator;
@property NSString* fieldSeparator;
@property NSDateFormatter* dateFormatter;
@property NSNumberFormatter* amountFormatter;

@end

