//
//  ReceiptViewController.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/16/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExpenseItem;

@interface ReceiptViewController : UIViewController

{
    
}


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) ExpenseItem *item;
@property (nonatomic, strong) UIImage *image;

@end
