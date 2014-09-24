//
//  ManualCodeViewController+SSSService.m
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ManualCodeViewController+SSSService.h"

#import "UserModel.h"
#import "LoadingView.h"
#import "ScannerView.h"

@implementation ManualCodeViewController (SSSService)


- (void) sendCode :(NSString*) code
{
    // Add LoadingView
    [LoadingView showLoadingAt:self.view];  
    // Call sending code
    [self.service callsendingCode:code];
}

#pragma mark SSSServiceDelegate

- (void) didSendCode:(NSString*)message
{
    [LoadingView hideLoadingViewAt:self.view];
    // Set Data for confirmation view
    BOOL isValid = [message isEqualToString:@"valid"];
    [[SSSScannerController share]setIsValidCode:isValid];
    [[SSSScannerController share]setMessageAfterScanning:message];
    // Go to Confirmation view
    [[SSSScannerController share]gotoScreenAtIndex:3 Animated:YES AnimatonDirection:kCATransitionFromLeft];
}

@end
