//
//  ExpenseItemStore.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/11/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExpenseItem;

@interface ExpenseItemStore : NSObject

+ (ExpenseItemStore *)sharedStore;

@property (nonatomic, strong, readonly) NSArray *allItems;

- (NSArray *)allExpenseTypes;

- (void)removeItem:(ExpenseItem *)item;
- (ExpenseItem *)createItem;
- (BOOL)saveChanges;

- (void)moveItemAtIndex:(int)from toIndex:(int)to;

@end
