//
//  ConnectionViewController.m
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import "ConnectionViewController.h"
#import "Connection.h"
#import "CompanyFileViewController.h"
#import "CustomerListViewController.h"
#import "OauthViewController.h"

@interface ConnectionViewController ()
{
    Connection *conn;
    NSMutableData *responseData;
    
    NSMutableArray *companyFileNames;
    NSMutableArray *companyFileIds;
}
@end

@implementation ConnectionViewController
@synthesize oauthButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) return nil;
    
    self.title = @"Sample";
    
    conn = Connection.new;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauthCodeUpdated:) name:@"oauthCodeUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(companyFileSelected:) name:@"companyFileSelected" object:nil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ((!YOUR_API_KEY) || (YOUR_API_KEY.length == 0))
    {
        NSLog(@"Your API Key has not been set!");
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [defaults objectForKey:@"code"];
    if (code)
    {
        [self hideOauthButton];
    }
    else
    {
        NSLog(@"No access code. Get one via OAuth");
    }
    
    NSString *refreshToken = [defaults objectForKey:@"refresh_token"];
    NSString *companyFileId = [defaults objectForKey:@"companyFileId"];
    NSString *cftoken = [defaults objectForKey:@"cftoken"];
    conn.code = code;
    conn.refresh_token = refreshToken;
    conn.companyFileGuid = companyFileId;
    conn.cftoken = cftoken;
    
    if (refreshToken)
    {
      [self refreshTheToken];
    }
}

- (void)hideOauthButton
{
    NSLog(@"No need to get the OAuth code again.");
    oauthButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)oauth:(id)sender
{
    OauthViewController *vc = OauthViewController.new;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)oauthCodeUpdated:(NSNotification*)notification
{
    conn.code = [notification.userInfo objectForKey:@"code"];
    [self hideOauthButton];
}

- (void)setInitialConnection
{
    conn.client_id = YOUR_API_KEY;
    conn.client_secret = YOUR_API_SECRET;
    conn.scope = @"Company";
    conn.redirect_uri = REDIRECT_URI;
    conn.grant_type = @"authorization_code";
}

- (void)getAccessToken
{
    NSLog(@"Getting access token");
    
    NSString *newTokenBodyFormat = @"client_id=%@&client_secret=%@&scope=%@&code=%@&redirect_uri=%@&grant_type=%@";
    NSString *urlBody = [NSString stringWithFormat:newTokenBodyFormat, [conn client_id], [conn client_secret], [conn scope], [conn code], [conn redirect_uri], [conn grant_type]];
    
    NSURL *url = [NSURL URLWithString:SECURE_PATH];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    NSData *urlBodyData = [urlBody dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:urlBodyData];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    [urlConnection start];
}

- (void)refreshTheToken {
    NSLog(@"Refreshing the token");
    [self setInitialConnection];
    
    NSString *urlBody = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&refresh_token=%@&grant_type=refresh_token", [conn client_id], [conn client_secret], [conn refresh_token]];
    
    NSURL *url = [NSURL URLWithString:SECURE_PATH];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *urlBodyData = [urlBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:urlBodyData];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [urlConnection start];
}

- (void)getCompanyFileList
{
    NSLog(@"Getting the company files");
    
    NSURL *url = [NSURL URLWithString:DEFAULT_API_CALL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"" forHTTPHeaderField:@"x-myobapi-cftoken"];
    [req setValue:YOUR_API_KEY forHTTPHeaderField:@"x-myobapi-key"];
    NSString *authorisationValue = [NSString stringWithFormat:@"Bearer %@", conn.access_token];
    [req setValue:authorisationValue forHTTPHeaderField:@"Authorization"];
    [req setValue:@"v2" forHTTPHeaderField:@"x-myobapi-version"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    [connection start];
}

- (IBAction)companyFile:(id)sender
{
    if (!conn.access_token)
    {
        [self setInitialConnection];
        [self getAccessToken];
    }
    else
    {
        [self getCompanyFileList];
    }
}

- (void)companyFileSelected:(NSNotification*)notification
{
    conn.companyFileGuid = [notification.userInfo objectForKey:@"companyFileId"];
    conn.cftoken = [notification.userInfo objectForKey:@"cftoken"];
}

- (IBAction)customers:(id)sender
{
    [self getCustomerList];
}

- (void)getCustomerList {
    NSLog(@"Getting the customer list");
    NSString *urlPath = [NSString stringWithFormat:@"%@%@/Contact/Customer", DEFAULT_API_CALL, conn.companyFileGuid];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:conn.cftoken forHTTPHeaderField:@"x-myobapi-cftoken"];
    [req setValue:YOUR_API_KEY forHTTPHeaderField:@"x-myobapi-key"];
    NSString *authorisationValue = [NSString stringWithFormat:@"Bearer %@", conn.access_token];
    [req setValue:authorisationValue forHTTPHeaderField:@"Authorization"];
    [req setValue:@"v2" forHTTPHeaderField:@"x-myobapi-version"];
    
    NSURLConnection *jobConn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    [jobConn start];
}

#pragma start of connection callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = NSMutableData.new;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"A connection failure occurred: %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *connectionUrl = [[[connection originalRequest] URL] absoluteString];
    if ([connectionUrl rangeOfString:@"v1/authorize"].location != NSNotFound)
    {
        [self handleResponseDataForAccessTokens];
    }
    else if ([connectionUrl isEqualToString:DEFAULT_API_CALL])
    {
        [self handleResponseDataForCompanyFiles];
    }
    else if ([connectionUrl rangeOfString:@"/Contact/Customer"].location != NSNotFound)
    {
        [self handleResponseDataForCustomers];
    }
}

- (void)handleResponseDataForAccessTokens
{
    NSDictionary *authorization = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    BOOL getCompanyFiles = (!conn.access_token) && (!conn.refresh_token);
    conn.access_token = [authorization objectForKey:@"access_token"];
    if (!conn.access_token)
    {
        NSLog(@"Bad response! responseData did not contain an access_token \n%@", authorization);
        return;
    }
    conn.expires_in = [authorization objectForKey:@"expires_in"];
    conn.refresh_token = [authorization objectForKey:@"refresh_token"];
    conn.scope = [authorization objectForKey:@"scope"];
    conn.token_type = [authorization objectForKey:@"token_type"];
    
    conn.last_refresh = [NSDate date];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:conn.refresh_token forKey:@"refresh_token"];
    [defaults synchronize];
  
    NSLog(@"Access token retreived");
    if (getCompanyFiles)
    {
        // we only want to get the company file list if the
        [self getCompanyFileList];
    }
}

- (void)handleResponseDataForCompanyFiles
{
    NSArray *companyList = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    companyFileNames = NSMutableArray.new;
    companyFileIds = NSMutableArray.new;
    for (NSDictionary *d in companyList)
    {
        [companyFileNames addObject:[d objectForKey:@"Name"]];
        [companyFileIds addObject:[d objectForKey:@"Id"]];
    }
    
    NSLog(@"Company file names: \n%@", companyFileNames);
    CompanyFileViewController *vc = CompanyFileViewController.new;
    vc.pickerData = companyFileNames;
    vc.pickerCompanyFileId = companyFileIds;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleResponseDataForCustomers
{
    NSDictionary *customerDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    NSMutableArray *customerNames = NSMutableArray.new;
    NSMutableArray *customerAddresses = NSMutableArray.new;
    for (NSDictionary *customer in [customerDict objectForKey:@"Items"])
    {
        if ([customer objectForKey:@"IsIndividual"])
        {
            [customerNames addObject:[NSString stringWithFormat:@"%@ %@", [customer objectForKey:@"FirstName"], [customer objectForKey:@"LastName"]]];
        }
        else
        {
            [customerNames addObject:[customer objectForKey:@"CompanyName"]];
        }
        
        NSDictionary *address = [[customer objectForKey:@"Addresses"] objectAtIndex:0];
        NSString *streetAddress = [NSString stringWithFormat:@"%@ %@", [address objectForKey:@"Street"], [address objectForKey:@"City"]];
        [customerAddresses addObject:streetAddress];
    }
    
    CustomerListViewController *vc = CustomerListViewController.new;
    NSLog(@"Customer names: \n%@", customerNames);
    vc.customerNames = customerNames;
    vc.customerAddress = customerAddresses;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
