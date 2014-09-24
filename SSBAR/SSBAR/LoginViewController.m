//
//  LoginViewController.m
//  SSBAR
//
//  Created by devart107 on 9/20/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "LoginViewController.h"

#import "SSSService.h"

@interface LoginViewController () <SSSServiceDelegate, UITextFieldDelegate>
{
    // View's Members
    __weak IBOutlet UITextField *userName;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UIActivityIndicatorView *indicator;
    __weak IBOutlet UIButton *loginButton;
    
    // Service
    SSSService *service;
    
}

// Actions

- (IBAction)loginButtonTaped:(id)sender;

@end

@implementation LoginViewController


#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure for beginning
    [self configureForBeginning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - Configure For Beginning

- (void)configureForBeginning
{
    // Init service
    service = [SSSService share];
    service.delegate = self;
    // Make indicator hiden
    [indicator setHidden:YES];
    // For text fields
    [userName setDelegate:self];
    [password setDelegate:self];
}

#pragma mark - Actions

- (IBAction)loginButtonTaped:(id)sender
{
    // Hide keyboard
    [userName resignFirstResponder];
    [password resignFirstResponder];

    // Check Login conditions
    if (![userName.text isEqualToString:@""] && ![password.text isEqualToString:@""])
    {
         // Update UI after requesting
        [self updateUIBeforeRequesting];
        // Call login service
        [service callLoginWithUserName:userName.text Password:password.text];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please input both user name and password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SSSServiceDelegate

- (void) loginSuceesfully
{
     // Update UI after requesting
    [self updateUIAfterRequesting];
    // Go to scanner view
    [[SSSScannerController share]gotoScreenAtIndex:1 Animated:YES AnimatonDirection:kCATransitionFromRight];
    // Save password
    [[SSSScannerController share]setPassword:password.text];
}
- (void) loginFail:(NSString*)message
{
    // Update UI after requesting
    [self updateUIAfterRequesting];
    // Show error message
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) updateUIBeforeRequesting
{
    // Show Indicator
    [indicator setHidden:NO];
    [indicator startAnimating];
    [loginButton setEnabled:NO];
}

- (void) updateUIAfterRequesting
{
    // Show Indicator
    [indicator setHidden:YES];
    [indicator stopAnimating];
    [loginButton setEnabled:YES];
}



@end
