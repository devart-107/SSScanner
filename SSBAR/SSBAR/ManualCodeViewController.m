//
//  ManualCodeViewController.m
//  SSBAR
//
//  Created by devart107 on 9/20/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ManualCodeViewController.h"

#import "ManualCodeViewController+SSSService.h"

@interface ManualCodeViewController () <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *inputCodeField;    
}

@end

#pragma mark -Life Cycle

@implementation ManualCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // configure for beginning
    [self configureForBeginning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma Actions

- (IBAction)backTapped:(id)sender
{
    // Hide keybooard
    [inputCodeField resignFirstResponder];
    // Go to Scanner View
    [[SSSScannerController share]backToOneView:self.view animationDirection:kCATransitionFromBottom];
 
    
}
- (IBAction)sendcodeTapped:(id)sender
{
    // Hide keybooard
    [inputCodeField resignFirstResponder];
    // Prepare sending
    if (![inputCodeField.text isEqualToString:@""])
    {
        [self sendCode:inputCodeField.text];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please input code."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// configure For Beginning

- (void) configureForBeginning
{
    // Service
    _service = [SSSService share];
    [_service setDelegate:self];
    // InputCodeField
    [inputCodeField setDelegate:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
