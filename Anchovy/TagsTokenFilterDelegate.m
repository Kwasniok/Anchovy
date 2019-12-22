//
//  TagsTokenFilterDelegate.m
//  Anchovy
//
//  Created by Jens Kwasniok on 22.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "TagsTokenFilterDelegate.h"

@implementation TagsTokenFilterDelegate

-(NSArray *)tokenField:(NSTokenField *)tokenField
completionsForSubstring:(NSString *)substring
          indexOfToken:(NSInteger)tokenIndex
   indexOfSelectedItem:(NSInteger *)selectedIndex
{
    // List all previously used tags in records once.
    Content* content = _viewController.representedObject;
    NSMutableArray<NSString*>* tags = [[NSMutableArray alloc] init];
    for (Record* record in content.records)
    {
        if (record.tags)
        {
            for (NSString* tag in record.tags)
            {
                if (![tags containsObject:tag])
                {
                    [tags addObject:tag];
                }
            }
        }
    }
    // Sort all previously used tags.
    [tags sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    // Insert currently typed substring at top position to allow filtering of yet unused tags!
    [tags insertObject:substring atIndex:0];
    return tags;
}

@end
