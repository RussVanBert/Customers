//
//  CustomerListViewController.h
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerListViewController : UITableViewController

@property (nonatomic, strong) NSArray *customerNames;
@property (nonatomic, strong) NSArray *customerAddress;

@end
