//
//  ExpenseItemStore.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/11/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "ExpenseItemStore.h"
#import "ExpenseItem.h"
#import <CoreData/CoreData.h>

@interface ExpenseItemStore ()
{
    NSMutableArray *_allItems;
    NSMutableArray *_allExpenseTypes;
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
}
- (NSString *)itemArchivePath;
- (void)loadAllItems;
@end

@implementation ExpenseItemStore

@synthesize allItems = _allItems;

- (id)init
{
    self = [super init];
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:psc];
        
        [_context setUndoManager:nil];
        
        [self loadAllItems];
    }
    return self;
}

+ (ExpenseItemStore *)sharedStore
{
    static ExpenseItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
        return sharedStore;
    } else {
        return sharedStore;
    }
}

- (ExpenseItem *)createItem
{
    double order;
    if ([_allItems count]) {
        order = 1.0;
    } else {
        order = [[_allItems lastObject] orderingValue] + 1.0;
    }
    
    ExpenseItem *e = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItem" inManagedObjectContext:_context];
    
    [e setOrderingValue:order];
    
    [_allItems addObject:e];
    return e;
}

- (void)removeItem:(ExpenseItem *)item
{
    [_context deleteObject:item];
    [_allItems removeObjectIdenticalTo:item];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [_context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (void)loadAllItems
{
    if (!_allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[_model entitiesByName] objectForKey:@"ExpenseItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:@[sd]];
        
        NSError *error;
        NSArray *result = [_context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        _allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    
    ExpenseItem *e = [_allItems objectAtIndex:from];
    
    [_allItems removeObjectAtIndex:from];
    
    [_allItems insertObject:e atIndex:to];
    
    double lowerBound = 0.0;
    
    // is there an object before it in the array?
    if (to > 0) {
        lowerBound = [[_allItems objectAtIndex:to - 1] orderingValue];
    } else {
        lowerBound = [[_allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // is there an object after it in the array?
    if (to < [_allItems count] - 1) {
        upperBound = [[_allItems objectAtIndex:to + 1] orderingValue];
    } else {
        upperBound = [[_allItems objectAtIndex:to - 1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    [e setOrderingValue:newOrderValue];
}

- (NSArray *)allExpenseTypes
{
    if (!_allExpenseTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[_model entitiesByName] objectForKey:@"ExpenseItemType"];
        
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [_context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        _allExpenseTypes = [result mutableCopy];
    }
    
    if ([_allExpenseTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Dining Out" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Groceries" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Transportation" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Apparel" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Gifts" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Household" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Activities" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Toys" forKey:@"label"];
        [_allExpenseTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItemType" inManagedObjectContext:_context];
        [type setValue:@"Other" forKey:@"label"];
        [_allExpenseTypes addObject:type];
    }
    return _allExpenseTypes;
}

@end
