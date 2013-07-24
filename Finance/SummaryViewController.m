//
//  SummaryViewController.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/11/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // give it a label
        [tbi setTitle:@"Summary"];
        
        // create a uiimage from a file. this will use hypno@2x.png on retina dsplay devices
        //   UIImage *i = [UIImage imageNamed:@"Time.png"];
        
        // put that image on the tab bar item
        //   [tbi setImage:i];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
