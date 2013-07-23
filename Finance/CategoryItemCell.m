//
//  CategoryItemCell.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/19/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "CategoryItemCell.h"

@implementation CategoryItemCell

- (void)awakeFromNib
{
    //remove automatic constraints
    for(UIView *v in [[self contentView] subviews]) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    //name all of the view
    NSDictionary *names = @{@"value":[self valueLabel],
                            @"vendor":[self vendorLabel],
                            @"date":[self dateLabel]};
    
    //create horizontal visual format string
    NSString *fmt = @"H:|-2-[vendor]-[date]-2-|";
    
    //create constraings from this visual format string
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                   options:0
                                                                   metrics:nil
                                                                     views:names];
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
    
    constraints = constraintBuilder([self dateLabel], 25);
    
    if (![[self vendorLabel].text isEqual: @"Label"]) {
        fmt = @"V:|-5-[value(==20)]-[vendor(==15)]-1-|";
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                          options:NSLayoutFormatAlignAllLeft
                                                          metrics:nil
                                                            views:names];
        [[self contentView] addConstraints:constraints];
    } else {
        constraints = constraintBuilder([self vendorLabel], 25);
    }
    
    [[self contentView] addConstraints:constraints];

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
