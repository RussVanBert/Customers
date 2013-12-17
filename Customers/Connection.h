//
//  Connection.h
//  Customers
//
//  Created by Russell Van Bert on 8/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning "Set your API Key, Secret and Redirect Uri" 
#define YOUR_API_KEY @""
#define YOUR_API_SECRET @""
#define REDIRECT_URI @""    // eg. "my-ios-app://redirect"
#define REDIRECT_SCHEME @"" // eg. "my-ios-app"

#define OAUTH_PATH @"https://secure.myob.com/oauth2/account/authorize"
#define SECURE_PATH @"https://secure.myob.com/oauth2/v1/authorize"

#define DEFAULT_API_CALL @"https://api.myob.com/accountright/"

@interface Connection: NSObject

@property (nonatomic, strong) NSString *client_id;
@property (nonatomic, strong) NSString *client_secret;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSString *grant_type;
@property (nonatomic, strong) NSString *expires_in;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *token_type;

@property (nonatomic, strong) NSDate *last_refresh;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *redirect_uri;

@property (nonatomic, strong) NSString *companyFileGuid;
@property (nonatomic, strong) NSString *cftoken;

@end

