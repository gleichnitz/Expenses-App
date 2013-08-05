//
//  SummaryViewController.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/11/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "SummaryViewController.h"
#import "FinanceAppDelegate.h"

@interface SummaryViewController ()
{
   // CPTGraphHostingView *newView;
}

@end

@implementation SummaryViewController

@synthesize pieData, graph;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (id)init
{
    self = [super init];
    if (self) {
        UINavigationItem *nav = [self navigationItem];
        [nav setTitle:@"Summary"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // customization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(super.view.frame.origin.x, super.view.frame.origin.y+170, super.view.bounds.size.width, self.view.bounds.size.height-250)];
    [self.view addSubview:hostingView];
    
   // graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
    graph = [[CPTXYGraph alloc] initWithFrame:hostingView.frame];
    hostingView.hostedGraph = graph;
    graph.axisSet = nil;
    graph.title = @"Categories";
    
   // CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
   // [graph applyTheme:theme];
    
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.pieRadius = 100.0;
    pieChart.identifier = @"CategoryPieChart";
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionCounterClockwise;
    
    self.pieData=  [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:90.0],
                    [NSNumber numberWithDouble:20.0],
                    [NSNumber numberWithDouble:30.0],
                    [NSNumber numberWithDouble:40.0],
                    [NSNumber numberWithDouble:50.0], [NSNumber numberWithDouble:60.0], nil];
    
    [graph addPlot:pieChart];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	return [self.pieData objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
