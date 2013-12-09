//
//  ConnectionViewController.h
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController <NSURLConnectionDataDelegate>

- (IBAction)oauth:(id)sender;
- (IBAction)companyFile:(id)sender;
- (IBAction)customers:(id)sender;

@end
