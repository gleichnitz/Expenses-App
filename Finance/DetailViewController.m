//
//  DetailViewController.m
//  Finance
//
//  Created by Catherine Morrison on 7/11/13.
//  Copyright (c) 2013 Catherine Morrison. All rights reserved.
//

#import "DetailViewController.h"
#import "ExpenseItem.h"
#import "ExpenseItemStore.h"
#import "ItemViewController.h"
#import "ReceiptViewController.h"
#import "ReceiptStore.h"
#import "ExpenseTypePicker.h"
#import "ExpenseItemType.h"

@interface DetailViewController ()
{
    DetailViewController *d;
}
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextField *vendorField;
@property (weak, nonatomic) IBOutlet UITextField *detailsField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *receiptButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateLabel;
@property(nonatomic, retain) NSDate *date;

- (IBAction)receiptButton:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)showExpenseTypePicker:(id)sender;

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
// - (NSTimeInterval)timeIntervalSinceDate:(NSDate *)anotherDate;

@end

@implementation DetailViewController

-(void)cancelNumberPad{
    [[self valueField] resignFirstResponder];
    [self valueField].text = @"";
}

-(void)doneWithNumberPad{
    double num = [[[self valueField] text] doubleValue];
    //  NSNumber *number = [[NSNumber alloc] initWithDouble:num];
    [_item setValue:num];
    [[self valueField] resignFirstResponder];
    
}

- (void)expenseTypeDidChange:(id)sender {

}

- (void)detailsDidChange:(id)sender {
    [_item setDetails:[[self detailsField] text]];
}

- (void)vendorDidChange:(id)sender {
    [_item setVendorName:[[self vendorField] text]];
}

- (void)valueDidChange:(id)sender {
    [_item setValue:[[[self valueField] text] doubleValue]];

}

- (void)datePickerDidChange:(id)sender {
    NSLog(@"Date changed");
    
    NSTimeInterval t = [[[self datePicker] date] timeIntervalSinceReferenceDate];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
    [_item setDateStamp:date];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
    [[self dateLabel] setTitle: dateString forState:UIControlStateNormal];
    [[self view] setNeedsDisplay];

}

- (IBAction)receiptButton:(id)sender {
    // call receiptImage
    ReceiptViewController *receiptViewController = [[ReceiptViewController alloc] init];
    [receiptViewController setItem:_item];
    
    NSArray *images = [[NSArray alloc] init];
    images = [[self item] imageKeys];
    
    if (images) {
        // get image for image key from image store
        NSString *firstImageKey = [images objectAtIndex:0];
        UIImage *imageToDisplay = [[ReceiptStore sharedStore] imageForKey:firstImageKey];
        
        // use that image to put on the screen in imageview
        [[receiptViewController imageView] setImage:imageToDisplay];
    } else {
        // clear the imageview
        [[receiptViewController imageView] setImage:nil];
    }
}


- (IBAction)showDatePicker:(id)sender {
    [[self datePicker] setHidden:NO];
    [[self dateLabel] setHidden:YES];
    NSLog(@"%@", [[self datePicker]date]);
}

- (IBAction)showExpenseTypePicker:(id)sender {
    [[self view] endEditing:YES];
    
    ExpenseTypePicker *expenseTypePicker = [[ExpenseTypePicker alloc] init];
    [expenseTypePicker setItem:[self item]];
    
    [[self navigationController] pushViewController:expenseTypePicker animated:YES];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // create a nsuuid object and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    
    
    
    NSArray *array = [[NSArray alloc] initWithArray:[[self item] imageKeys]];
    array = [[self item] imageKeys];
    
    NSArray *newArray = [array arrayByAddingObject:key];
    
    [[self item] setImageKeys:newArray];
 //   NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
 //   key = arrayData;
    
  //  [[self item] saveContext];
    // WE MAY NEED THIS!!!
  //  [[self item] setImageKey:key];
    
    // store the image in the bnrimagestore for this key
    [[ReceiptStore sharedStore] setImage:image forKey:key];

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
    
    [[self dateLabel] setHidden:NO];
    [[self datePicker] setHidden:YES];
    [[self view] setNeedsDisplay];

}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

- (void)save:(id)sender
{
    [[self view] endEditing:YES];

   // ExpenseItem *item = [self item];
//    [item setValue:[[[self valueField] text] doubleValue]];
//    [item setVendorName:[[self vendorField] text]];
//    [item setDetails:[[self detailsField] text]];
    
//    NSTimeInterval t = [[[self datePicker] date] timeIntervalSinceReferenceDate];
    [_item setDateStamp:[[self datePicker]date]];
    
    ExpenseItemType *type = [self.item expenseType];
    
    if ([[type label] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoopsie Daisy"
                                                        message:@"Please enter a category"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    } else if ([_item value] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoopsie Daisy"
                                                        message:@"Please enter a value"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    } else {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:[self dismissBlock]];
    }
}

- (void)cancel:(id)sender
{
    // if the user cancelled, then remove the bnritem from the store
    [[ExpenseItemStore sharedStore] removeItem:[self item]];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:[self dismissBlock]];
}

- (void)setItem:(ExpenseItem *)item
{
    _item = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.opaque = NO;
    self.navigationController.navigationBar.alpha = 0.7;
    
    ExpenseItem *item = [self item];
//    [self vendorField].clearsOnBeginEditing = YES;
//    [self detailsField].clearsOnBeginEditing = YES;
//    [self valueField].clearsOnBeginEditing = YES;
    
    if ([item value] == 0) {
        [[self valueField] setText:@""];
    } else {
        [[self valueField] setText:[NSString stringWithFormat:@"%.2f",[item value]]];
    }
    
    if ([item vendorName])
        [[self vendorField] setText:[item vendorName]];
    if ([item details])
        [[self detailsField] setText:[item details]];
    [self datePicker].datePickerMode = UIDatePickerModeDate;
    
    [[self datePicker] setDate:[item dateStamp]];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date = [item dateStamp];

    NSString *dateString = [dateFormat stringFromDate:date];
    [[self dateLabel] setTitle: dateString forState:UIControlStateNormal];
    
    [[self datePicker] addTarget:self
                          action:@selector(datePickerDidChange:)
                forControlEvents:UIControlEventValueChanged];
    [[self vendorField] addTarget:self
                           action:@selector(vendorDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [[self valueField] addTarget:self
                           action:@selector(valueDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [[self detailsField] addTarget:self
                           action:@selector(detailsDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [[self categoryLabel] addTarget:self
                             action:@selector(expenseTypeDidChange:)
                   forControlEvents:UIControlEventValueChanged];
    
    // nsstring imagekey and imageview display
    NSString *typeLabel = [[item expenseType] label];
    if(!typeLabel)
        typeLabel = @"None";
    [[self categoryLabel] setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // clear first responder
    [[self view] endEditing:YES];
    
    // "save" changes to item
//    ExpenseItem *item = [self item];
//    [item setValue:[[[self valueField] text] doubleValue]];
//    [item setVendorName:[[self vendorField] text]];
//    [item setDetails:[[self detailsField] text]];
//    
//    NSTimeInterval t = [[[self datePicker] date] timeIntervalSinceReferenceDate];
//    [item setDateStamp:t];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for(UIView *v in [[self view] subviews]) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    }

    
    self.view.backgroundColor = [UIColor purpleColor];
    self.view.opaque = NO;
    self.view.alpha = 0.3;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    [self valueField].inputAccessoryView = numberToolbar;
    
    
    //struts and springs - look up for constraints
//  code I wrote that is not done/doesn't really function, feel free to delete
    
//    NSDictionary *names = @{@"valueLabel":[self valueLabel],
//                            @"valueField":[self valueField],
//                            @"vendorLabel":[self vendorLabel],
//                            @"vendorField":[self vendorField],
//                            @"detailsLabel":[self detailsLabel],
//                            @"detailsField":[self detailsField],
//                            @"datePicker":[self datePicker],
//                            @"toolbar":[self toolbar],
//                            @"cameraButton":[self cameraButton],
//                            @"receiptButton":[self receiptButton]
//                            };    
//    CGRect bounds = [[d view] bounds];
//    
//    NSString *fmt = @"H:|-8-[valueLabel(==70)]-[valueField]-|";
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:names];
//    [[self view] addConstraints:constraints];
//    
//    fmt = @"H:|-8-[vendorLabel(==70)]-[vendorField]-|";
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:names];
//    [[self view] addConstraints:constraints];
//    
//    fmt = @"H:|-8-[detailsLabel(==70)]-[detailsField]-|";
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:names];
//    [[self view] addConstraints:constraints];
//    
//    [[self toolbar] setFrame:CGRectMake(0, bounds.size.height - 50, bounds.size.width, 50)];
//    
//    fmt = @"V:|-[valueLabel(==50)]-[vendorLabel(==50)]-[detailsLabel(==50)]-20-[datePicker]-5-[toolbar(==50)]-0-|";
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:names];
//    constraints = [NSLayoutConstraint
//                   constraintsWithVisualFormat:fmt
//                   options:NSLayoutFormatAlignAllLeft
//                   metrics:nil
//                   views:names];
//    [[self view] addConstraints:constraints];
    
    
//  code from BNR (for reference)
//    NSArray * (^constraintBuilder)(UIView *, float) = ^(UIView *v, float height) {
//        return @[
//                 [NSLayoutConstraint constraintWithItem:v
//                                              attribute:NSLayoutAttributeCenterY
//                                              relatedBy:NSLayoutRelationEqual
//                                                 toItem:[self contentView]
//                                              attribute:NSLayoutAttributeCenterY
//                                             multiplier:1.0
//                                               constant:0],
//                 [NSLayoutConstraint constraintWithItem:v
//                                              attribute:NSLayoutAttributeHeight
//                                              relatedBy:NSLayoutRelationEqual
//                                                 toItem:nil
//                                              attribute:NSLayoutAttributeNotAnAttribute
//                                             multiplier:0.0
//                                               constant:height]
//                 ];
//    };
//    [[self contentView] addConstraints:constraintBuilder([self thumbnailView], 40)];
//    [[self contentView] addConstraints:constraintBuilder([self valueLabel], 21)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
