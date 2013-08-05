//
//  SummaryViewController.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/11/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SummaryViewController : UIViewController <CPTPlotDataSource>
{
    CPTXYGraph * graph;
    NSMutableArray *pieData;
}

@property(readwrite, retain, nonatomic) NSMutableArray *pieData;
@property (nonatomic,retain) CPTXYGraph * graph;

@end
