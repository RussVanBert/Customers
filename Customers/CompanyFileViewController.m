//
//  CompanyFileViewController.m
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import "CompanyFileViewController.h"

@implementation CompanyFileViewController {
    NSString *selectedCompanyFileName;
    NSString *selectedCompanyFileId;
}

@synthesize name, password, picker, pickerData, pickerCompanyFileId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Company";
    
    if (pickerCompanyFileId.count > 0)
    {
        selectedCompanyFileName = pickerData[0];
        selectedCompanyFileId = pickerCompanyFileId[0];
    }
    
    name.delegate = self;
    password.delegate = self;
    picker.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSString *plainString = [NSString stringWithFormat:@"%@:%@", name.text, password.text];
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    // This sample code stores the username and password in the user defaults.
    // Don't do this. Use keychain services instead.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCompanyFileId forKey:@"companyFileId"];
    [defaults setObject:base64String forKey:@"cftoken"];
    [defaults synchronize];
    
    NSLog(@"Selected company file is '%@'", selectedCompanyFileName);
    NSDictionary *settings = @{@"companyFileId":selectedCompanyFileId,
                               @"cftoken":base64String};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"companyFileSelected" object:nil userInfo:settings];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedCompanyFileName = pickerData[row];
    selectedCompanyFileId = pickerCompanyFileId[row];
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
