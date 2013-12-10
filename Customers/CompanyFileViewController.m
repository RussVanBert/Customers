//
//  CompanyFileViewController.m
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import "CompanyFileViewController.h"

@implementation CompanyFileViewController

@synthesize name, password, picker, pickerData, pickerCompanyFileId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Company";

    name.delegate = self;
    password.delegate = self;
    picker.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSString *selectedCompanyFileId = [pickerCompanyFileId objectAtIndex:[picker selectedRowInComponent:0]];
    if (!selectedCompanyFileId) return;
    
    NSString *plainString = [NSString stringWithFormat:@"%@:%@", name.text, password.text];
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCompanyFileId forKey:@"companyFileId"];
    [defaults setObject:base64String forKey:@"cftoken"];
    [defaults synchronize];
    
    NSDictionary *settings = @{@"companyFileId":selectedCompanyFileId,
                               @"cftoken":base64String};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"oauthTokenUpdated" object:nil userInfo:settings];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
