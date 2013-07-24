//
//  CategoryViewController.m
//  Finance
//
//  Created by Catherine Morrison on 7/23/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "CategoryViewController.h"
#import "ExpenseItemStore.h"
#import "ExpenseItem.h"
#import "ExpenseItemType.h"
#import "DetailViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // give it a label
        [tbi setTitle:@"Categories"];
        
        // create a uiimage from a file. this will use hypno@2x.png on retina dsplay devices
        //   UIImage *i = [UIImage imageNamed:@"Time.png"];
        
        // put that image on the tab bar item
        //   [tbi setImage:i];
    }
    
    return self;
}

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
    
  //  NSManagedObject *type = [[self item] expenseType];
    
    NSString *expenseLabel = [expenseType valueForKey:@"label"];
    [[cell textLabel] setText:expenseLabel];
    
  //  if (expenseType == type) {
  //      [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  //  } else {
  //      [cell setAccessoryType:UITableViewCellAccessoryNone];
  //  }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allExpenses = [[ExpenseItemStore sharedStore] allExpenseTypes];
    ExpenseItemType *expenseType = [allExpenses objectAtIndex:[indexPath row]];
    _expenseItemType = expenseType;
    
    [self addNewItem];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)addNewItem
{
    ExpenseItem *newItem = [[ExpenseItemStore sharedStore] createItem];
    [newItem setExpenseType:_expenseItemType];
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{[[self tableView] reloadData];}];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
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
