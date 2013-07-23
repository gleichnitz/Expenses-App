//
//  ReceiptViewController.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/16/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ExpenseItem.h"

@interface ReceiptViewController ()


@end

@implementation ReceiptViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationItem] setTitle:@"Receipt"];

    [[self imageView] setImage:[self image]];
    
    [(UIImageView *)[self view] setImage:[self image]];
}

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self setView:imageView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *images = [[NSArray alloc] init];
    images = [[self item] imageKeys];
    _image = [images objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setItem:(ExpenseItem *)item
{
    _item = item;
}


@end
