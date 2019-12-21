//
//  Document.m
//  Anchovy
//
//  Created by Jens Kwasniok on 20.12.19.
//  Copyright © 2019 Jens Kwasniok. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _content = [[Content alloc] init];
        _recordSeparator = @"\n";
        _fieldSeparator = @";";
        _dateFormatter = [[NSDateFormatter alloc] init];
        _amountFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}


- (void)makeWindowControllers
{
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    
    // Write records as CVS-style UTF8 string separated by `recordSeparator`. The fields per record are: date, amount and are separated by `fieldSeparator`.
    // Each field `x` is formatted via `xFormatter`if nedded. Empty fields (nl) result in empty entries ("").
    
    NSMutableString* dataStr = [[NSMutableString alloc] init];
    for (Record* record in _content.records)
    {
        // Buffer record string.
        NSMutableString* recordStr = [[NSMutableString alloc] init];
        NSString* fieldStr;
        fieldStr = [_dateFormatter stringFromDate:record.date];
        if (!fieldStr)
        {
            fieldStr = @"";
        }
        [recordStr appendString: fieldStr];
        [recordStr appendString: _fieldSeparator];
        fieldStr = [_amountFormatter stringFromNumber:record.amount];
        if (!fieldStr)
        {
            fieldStr = @"";
        }
        [recordStr appendString: fieldStr];
        [recordStr appendString: _fieldSeparator];
        [recordStr appendString:_recordSeparator];
        // Append record.
        [dataStr appendString:recordStr];
    }
    // Convert to (raw) byte data.
    NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    
    // Clear content.
    _content = [[Content alloc] init];
    
    // Read data as CSV-style UTF8 string and parse recors separated by `recordSeparator` and fields separated by `fieldSeparator`.
    // The order of fields is: date, amount. Each field `x` has its corresponding formatter if nedded (see `xFormatter`).
    // The parsing of records is forgiving as failed parsing attempts of fields lead to empty fields (nil).
    // Records where no field could be parsed correctly will be skipped.
    
    NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray<NSString*>* recordStrs = [dataStr componentsSeparatedByString:_recordSeparator];
    int processed_records = 0;
    for (NSString* recordStr in recordStrs)
    {
        // Skip empty records.
        if ([recordStr isEqualToString:@""])
        {
            continue;
        }
        //NSLog(@"record %i: %@", processed_records + 1, recordStr);
        NSArray<NSString*>* fieldStrs = [recordStr componentsSeparatedByString:_fieldSeparator];
        int processed_fields = 0;
        NSDate* date = nil;
        NSNumber* amount = nil;
        for (NSString* fieldStr in fieldStrs)
        {
            //NSLog(@"field %i: %@", processed_fields + 1, fieldStr);
            if (processed_fields == 0)
            {
                date = [_dateFormatter dateFromString:fieldStr];
                if (date == nil)
                {
                    //NSLog(@"failed to read date");
                }
            }
            if (processed_fields == 1)
            {
                amount = [_amountFormatter numberFromString:fieldStr];
                if (amount == nil)
                {
                    //NSLog(@"failed to read amount");
                }
            }
            if (processed_fields == 2)
            {
                if (![fieldStr isEqualToString:@""])
                {
                    //NSLog(@"Record %i has more fields than expected.", processed_records + 1);
                }
                break;
            }
            ++processed_fields;
        }
        // Skip records with all fields empty.
        if (!date && !amount)
        {
            continue;
        }
        Record* record = [[Record alloc] init];
        record.date = date;
        record.amount = amount;
        [_content.records addObject:record];
        ++processed_records;
    }
    //NSLog(@"Records processed: %i.", processed_records);
    return YES;
}


@end
