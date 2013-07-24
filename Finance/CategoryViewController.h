//
//  CategoryViewController.h
//  Finance
//
//  Created by Catherine Morrison on 7/23/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpenseItemType;

@interface CategoryViewController : UITableViewController

@property (nonatomic, strong) ExpenseItemType *expenseItemType;

@end
