//
//  RecentItemCell.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
