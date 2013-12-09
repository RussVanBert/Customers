//
//  CompanyFileViewController.h
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyFileViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSArray *pickerCompanyFileId;

- (IBAction)backgroundTapped:(id)sender;

@end
