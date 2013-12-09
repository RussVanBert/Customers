//
//  Connection.m
//  Customers
//
//  Created by Russell Van Bert on 8/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import "Connection.h"

@implementation Connection
@synthesize client_id, client_secret, access_token, refresh_token, grant_type, expires_in, scope, token_type,
            last_refresh,
            code, redirect_uri,
            companyFileGuid, cftoken;
@end
