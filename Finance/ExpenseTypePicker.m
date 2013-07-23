//
//  ExpenseTypePicker.m
//  Finance
//
//  Created by Catherine Morrison on 7/18/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "ExpenseTypePicker.h"
#import "ExpenseItemStore.h"
#import "ExpenseItem.h"
#import "ExpenseItemType.h"


@implementation ExpenseTypePicker

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ExpenseItemStore sharedStore] allExpenseTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSArray *allExpenses = [[ExpenseItemStore sharedStore] allExpenseTypes];
    NSManagedObject *expenseType = [allExpenses objectAtIndex:[indexPath row]];
    
    NSManagedObject *type = [[self item] expenseType];
    
    NSString *expenseLabel = [expenseType valueForKey:@"label"];
    [[cell textLabel] setText:expenseLabel];
    
    if (expenseType == type) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allExpenses = [[ExpenseItemStore sharedStore] allExpenseTypes];
    ExpenseItemType *expenseType = [allExpenses objectAtIndex:[indexPath row]];
    [[self item] setExpenseType:expenseType];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.view.opaque = NO;
    self.view.alpha = 0.3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.opaque = NO;
    self.navigationController.navigationBar.alpha = 0.7;
}

@end
