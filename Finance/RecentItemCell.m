//
//  RecentItemCell.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "RecentItemCell.h"

@implementation RecentItemCell

- (void)awakeFromNib
{
    //remove automatic constraints
    for(UIView *v in [[self contentView] subviews]) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    //name all of the view
    NSDictionary *names = @{@"value":[self valueLabel],
                            @"vendor":[self vendorLabel],
                            @"category":[self categoryLabel]};
    
    //create horizontal visual format string
    NSString *fmt = @"H:[value]-5-|";
    //create constraints from this visual format string
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                   options:0
                                                                   metrics:nil
                                                                     views:names];
    [[self contentView] addConstraints:constraints];
    
    fmt = @"H:|-8-[category]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                   options:0
                                                                   metrics:nil
                                                                     views:names];
    [[self contentView] addConstraints:constraints];
    
    
    
    NSArray * (^constraintBuilder)(UIView *,float);
    constraintBuilder = ^(UIView *view, float height) {
        return @[
                 [NSLayoutConstraint constraintWithItem:view
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:[self contentView]
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0],
                 [NSLayoutConstraint constraintWithItem:view
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:height]
                 ];
    };
    constraints = constraintBuilder([self valueLabel], 25);
    [[self contentView] addConstraints:constraints];
    
    //if we cannot get if statement below to work, this will center category and put vendor underneath
    constraints = constraintBuilder([self categoryLabel], 20);
    [[self contentView] addConstraints:constraints];
    
    fmt = @"H:|-10-[vendor]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                          options:0
                                                          metrics:nil
                                                            views:names];
    [[self contentView] addConstraints:constraints];
    
    fmt = @"V:[vendor(==15)]-1-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                          options:NSLayoutFormatAlignAllLeft
                                                          metrics:nil
                                                            views:names];
    [[self contentView] addConstraints:constraints];
    
    // if we ever want category to not be centered when there is a vendor
//    if ([self vendorLabel].hidden == NO) {
//        fmt = @"H:|-5-[vendor]";
//        constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
//                                                              options:0
//                                                              metrics:nil
//                                                                views:names];
//        [[self contentView] addConstraints:constraints];
//        
//        fmt = @"V:|-1-[category(==20)]-[vendor(==15)]-1-|";
//        constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
//                                                              options:NSLayoutFormatAlignAllLeft
//                                                              metrics:nil
//                                                                views:names];
//    } else {
//        constraints = constraintBuilder([self categoryLabel], 25);
//    }
//    
//    [[self contentView] addConstraints:constraints];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
