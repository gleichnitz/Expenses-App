//
//  CategoryItemCell.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryItemCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
