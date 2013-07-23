//
//  DetailViewController.h
//  Finance
//
//  Created by Catherine Morrison on 7/11/13.
//  Copyright (c) 2013 Catherine Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpenseItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{

}
- (id)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) ExpenseItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end


