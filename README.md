Customers
=========

This application demonstrates the MYOB API for accessing your company file. It establishes an OAuth 2.0 code, allows you to select one of your available company files, and displays the customer list for that file.

The main view is controlled by the ConnectionViewController. From there, you can access the OAuth, CompanyFile selection and Customer list views. 

The most difficult part of the MYOB API, and many other APIs, is to understand the OAuth process. The OAuth process uses the myDot credentials to create an oauth code. Once you have the code, you can use it to generare the access token required to list of company files (usually just one file).  

# Instructions

## Set you key

To use this app, set your API key, secret and redirects in Connection.h. 

<pre><code>
#define YOUR_API_KEY @""
#define YOUR_API_SECRET @""
#define REDIRECT_URI @""    // eg. "my-ios-app://redirect"
#define REDIRECT_SCHEME @"" // eg. "my-ios-app"
</code></pre>

## Usage

Now you're ready to run the application. 

First, select OAuth to grant access to the app. Once the myDot user name and password have have been entered, the website will eventually redirect to your REDIRECT_URI. When this occurs, you will be able to extract the oauth code. 

Now you have the oauth code, select the company file you want to access. Then view the customers.

Check the console log and trace the code to get familiar with the structure.

