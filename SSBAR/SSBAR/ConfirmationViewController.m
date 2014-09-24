//
//  ConfirmationViewController.m
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ConfirmationViewController.h"

@interface ConfirmationViewController ()
{
    __weak IBOutlet UILabel *confirmationTitle;
    __weak IBOutlet UIImageView *confirmationImageIcon;
    __weak IBOutlet UILabel *confirmationMessage;
    
}
- (IBAction)scanNextTicketTouch:(id)sender;

@end

@implementation ConfirmationViewController

#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (IBAction)scanNextTicketTouch:(id)sender
{
    [[SSSScannerController share]gotoScreenAtIndex:1 Animated:YES AnimatonDirection:kCATransitionFromRight];
}

- (void) updateSubViews:(BOOL)isValid Message:(NSString* )message
{
    // For valid image
    NSString *imagePath ;
    if (isValid)
    {
        imagePath = @"valid";
        [confirmationTitle setText:@"VALID"];
        [confirmationMessage setText:@""];
    }
    else
    {
        imagePath = @"invalid";
        [confirmationTitle setText:@"INVALID"];
        [confirmationMessage setText:message];
    }
    [confirmationImageIcon setImage:[UIImage imageNamed:imagePath]];
    

    
    
}
@end
