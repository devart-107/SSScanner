//
//  AccountViewController.m
//  SSBAR
//
//  Created by devart107 on 9/20/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "AccountViewController.h"

#import "UserModel.h"

@interface AccountViewController ()
{
    
    __weak IBOutlet UILabel *userName;
}

@end

@implementation AccountViewController

#pragma mark - Life Cycle

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

#pragma mark - Actions

- (IBAction)logoutTapped:(id)sender
{
    // Remove user info
    [[SSSScannerController share]removeUserInfo];
    // Go to Login
    [[SSSScannerController share]gotoScreenAtIndex:0 Animated:YES AnimatonDirection:kCATransitionFromLeft];
}

- (IBAction)backTapped:(id)sender
{    // Go to Scanner View
    [[SSSScannerController share]backToOneView:self.view animationDirection:kCATransitionFromTop];
}
#pragma mark - Configure for beginning

- (void) configureForBeginning
{
    // Get data for username
    NSString *userNameText = ((UserModel* )[[SSSScannerController share] getUserModel]).userName;
    [userName setText: userNameText];
   
}



@end
