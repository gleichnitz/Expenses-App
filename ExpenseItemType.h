//
//  ExpenseItemType.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/18/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExpenseItem;

@interface ExpenseItemType : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSSet *items;
@end

@interface ExpenseItemType (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ExpenseItem *)value;
- (void)removeItemsObject:(ExpenseItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
