//
//  SSSService.m
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "SSSService.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UserModel.h"

@interface SSSService () <ASIHTTPRequestDelegate>
{
    ASIFormDataRequest *httpRequest;
}
@end

@implementation SSSService


static SSSService *instance = nil;

// Methods
+ (SSSService *) share
{
	if (instance == nil)
    {
		instance = [[SSSService alloc] init];
	}
	return instance;
}


// Methods
- (void) callLoginWithUserName:(NSString* )username Password:(NSString *)password
{
    // Make URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICES_BASE_LINK,SERVICES_LOGIN_PATH]];
    // Innit request
    httpRequest = [ASIFormDataRequest requestWithURL:url];
    [httpRequest setDelegate:self];
    [httpRequest setRequestMethod:SERVICES_POST_METHOD_REQUEST];
    // Add parametters
    [httpRequest addPostValue:username forKey:USER_INFO_USERNAME];
    [httpRequest addPostValue:password forKey:USER_INFOR_PASSWORD];
    // Set up Call back
    [httpRequest setDidFinishSelector:@selector(didLoginSuccessfull:)];
    [httpRequest setDidFailSelector:@selector(didLoginFail:)];
    // Run
    [httpRequest startAsynchronous];
}
- (void) callsendingCode:(NSString*)code
{
    // Get user token
    NSString *token = ((UserModel*)([[SSSScannerController share] getUserModel])).accessToken;
    // Make URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICES_BASE_LINK,SERVICES_SCAN_PATH]];
    // Innit request
    httpRequest = [ASIFormDataRequest requestWithURL:url];
    [httpRequest setDelegate:self];
    [httpRequest setRequestMethod:SERVICES_POST_METHOD_REQUEST];
    // Add parametters
    [httpRequest addPostValue:token forKey:USER_INFO_ACCESS_TOKEN];
    [httpRequest addPostValue:code forKey:CODE_INFO];
    // Set up Call back
    [httpRequest setDidFinishSelector:@selector(didSendingSuccessfull:)];
    [httpRequest setDidFailSelector:@selector(didSendingFail:)];
    // Run
    [httpRequest startAsynchronous];
    
    
}
// Login call back
- (void) didLoginSuccessfull:(ASIHTTPRequest *)request
{
    NSDictionary *dictionary = [request.responseString JSONValue];
    
    // Save user info
    [[SSSScannerController share] setUserModelWithUserName:[dictionary objectForKey:USER_INFO_USERNAME] accessToken:[dictionary objectForKey:USER_INFO_ACCESS_TOKEN]];
    
    // Call delegate
    [_delegate loginSuceesfully];
    
    // Destroy request
    httpRequest = nil;
}
- (void) didLoginFail:(ASIHTTPRequest *)request
{
    // Call delegate
    [_delegate loginFail:request.error.localizedDescription];
    
    // Destroy request
    httpRequest = nil;
}

// Sending code call back
- (void) didSendingSuccessfull:(ASIHTTPRequest *)request
{
    NSDictionary *dictionary = [request.responseString JSONValue];
    if(!dictionary)
    {
        // Call delegate
        [_delegate didSendCode:request.responseString];
    }
    else
    {
        NSDictionary *error = [dictionary objectForKey:SENDING_CODE_ERROR];
        [_delegate didSendCode:[error objectForKey:SENDING_CODE_ERROR_MESSAGE]];
    }
    // Destroy request
    httpRequest = nil;
}

- (void) didSendingFail:(ASIHTTPRequest *)request
{
    // Call delegate
    [_delegate didSendCode:request.error.localizedDescription];
    // Destroy request
    httpRequest = nil;
    
}


@end
