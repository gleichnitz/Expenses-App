//
//  ExpenseItem.h
//  Finance
//
//  Created by Catherine Morrison on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FinanceAppDelegate.h"

@class ExpenseItemType;

@interface ExpenseItem : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * dateStamp;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic) double  orderingValue;
@property (nonatomic, retain) UIImage *receiptImage;
@property (nonatomic) double value;
@property (nonatomic, retain) NSString * vendorName;
@property (nonatomic, retain) NSArray * imageKeys;
@property (nonatomic, retain) NSData * imageKeysData;
@property (nonatomic, retain) ExpenseItemType *expenseType;

@end
