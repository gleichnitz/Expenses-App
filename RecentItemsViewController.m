//
//  RecentItemsViewController.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "RecentItemsViewController.h"
#import "DetailViewController.h"
#import "ExpenseItem.h"
#import "ExpenseItemType.h"
#import "ExpenseItemStore.h"
#import "RecentItemCell.h"

@interface RecentItemsViewController ()

@end

@implementation RecentItemsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
 
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.opaque = NO;
    self.navigationController.navigationBar.alpha = 0.7;
}

- (IBAction)addNewItem:(id)sender
{
    ExpenseItem *newItem = [[ExpenseItemStore sharedStore] createItem];
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

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *nav = [self navigationItem];
        [nav setTitle:@"Recent"];
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"RecentItemCell"
                                bundle:nil];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"RecentItemCell"];
    self.tableView.rowHeight = 50;
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.view.opaque = NO;
    self.view.alpha = 0.3;


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[[ExpenseItemStore sharedStore] allItems] count] < 50) {
        return [[[ExpenseItemStore sharedStore] allItems] count];
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[ExpenseItemStore sharedStore] allItems];
    ExpenseItem *item = [items objectAtIndex:[indexPath row]];
    
    //get cell
    RecentItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentItemCell"];
    
    // Configure the cell with item
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%.2f", [item value]]];
    if ([[item vendorName] length] > 0) {
        [[cell vendorLabel] setText:[item vendorName]];
        [[cell vendorLabel] setHidden:NO];
    } else {
//        [[cell vendorLabel] setText:@""];
        [[cell vendorLabel] setHidden:YES];
    }
    [[cell categoryLabel] setText:[NSString stringWithFormat:@"%@", [[item expenseType] label]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[ExpenseItemStore sharedStore] allItems];
    ExpenseItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    [detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
