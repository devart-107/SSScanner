//
//  ScannerViewController+SSSService.m
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ScannerViewController+SSSService.h"

#import "UserModel.h"
#import "LoadingView.h"
#import "ScannerView.h"

@implementation ScannerViewController (SSSService) 

- (void) sendCode :(NSString*) code
{
    // Add LoadingView
    [LoadingView showLoadingAt:self.view];
    // Stop camera
    [self stopCamera];
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
    // remove Scanner View
    [self.view removeFromSuperview];
}

- (void) stopCamera
{
    [self.scannerView stopScanning];
    [self.scannerView stopCaptureSession];
    
}


@end
