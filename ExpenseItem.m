//
//  ExpenseItem.m
//  Finance
//
//  Created by Catherine Morrison on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "ExpenseItem.h"
#import "ExpenseItemType.h"
#import "ReceiptStore.h"


@implementation ExpenseItem

@dynamic category;
@dynamic dateStamp;
@dynamic details;
@dynamic imageKey;
@dynamic orderingValue;
@dynamic receiptImage;
@dynamic value;
@dynamic vendorName;
@dynamic imageKeysData;
@dynamic expenseType;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateStamp:[NSDate dateWithTimeIntervalSinceReferenceDate:t]];
}

- (NSArray *)imageKeys {
    [self willAccessValueForKey:@"imageKeys"];
    NSArray *keys = [NSKeyedUnarchiver unarchiveObjectWithData:self.imageKeysData];
    if (keys == nil) {
        keys = @[];
    }
    [self didAccessValueForKey:@"imageKeys"];
    return keys;
}

- (void)setImageKeys:(NSArray *)imageKeys {
    [self willChangeValueForKey:@"imageKeys"];
    if (imageKeys == nil) {
        self.imageKeysData = nil;
    } else {
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:imageKeys];
        self.imageKeysData = arrayData;
    }
    [self didChangeValueForKey:@"imageKeys"];
}

@end
