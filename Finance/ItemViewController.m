//
//  ItemViewController.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/11/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "ItemViewController.h"
#import "DetailViewController.h"
#import "ExpenseItem.h"
#import "ExpenseItemStore.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

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
        [nav setTitle:@"Food"];
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CategoryItemCell"
                                bundle:nil];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"CategoryItemCell"];
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.view.opaque = NO;
    self.view.alpha = 0.3;
    
    //self.navController.tintColor = [UIColor whiteColor];

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
    return [[[ExpenseItemStore sharedStore] allItems] count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[ExpenseItemStore sharedStore] allItems];
    ExpenseItem *item = [items objectAtIndex:[indexPath row]];
    
    //get cell
    CategoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryItemCell"];
    
    //configure cell with item
    
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%.2f",[item value]]];
    
    if ([[item vendorName] length] > 0) {
        [[cell vendorLabel] setText:[item vendorName]];
        [[cell vendorLabel] setHidden:NO];
    } else {
        [[cell vendorLabel] setHidden:YES];
    }
    
    // converts NSDate to string of month day
    NSDate *date = [item dateStamp];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSArray *partsOfDate = [[dateString componentsSeparatedByString:@" "] subarrayWithRange:NSMakeRange(0,2)];
    NSString *month = [partsOfDate objectAtIndex:1];
    month = [month stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    NSArray *finalDate = [NSArray arrayWithObjects:[partsOfDate objectAtIndex:0], month, nil];
    NSString *finalString = [finalDate componentsJoinedByString:@" "];
    [[cell dateLabel] setText:finalString];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ExpenseItemStore *ps = [ExpenseItemStore sharedStore];
        NSArray *items = [ps allItems];
        ExpenseItem *item = [items objectAtIndex:[indexPath row]];
        [ps removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (IBAction)toggleEditingMode:(id)sender
{
    if ([self isEditing]) {
        [sender setTitle:@"Edit"
                forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
