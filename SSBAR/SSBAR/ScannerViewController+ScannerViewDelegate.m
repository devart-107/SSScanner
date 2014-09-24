//
//  ScannerViewController+ScannerViewDelegate.m
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ScannerViewController+ScannerViewDelegate.h"

#import "ScannerViewController+SSSService.h"

@implementation ScannerViewController (ScannerViewDelegate)


- (void) scanedCode:(NSString *)scannedCode WithCodeType:(NSString *)codeType
{
    [self sendCode:scannedCode];
}
- (void) trackingErrorCaptureSession:(NSError *)error
{
    [self.scannerView stopCaptureSession];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not have a camera." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
}

- (void) deviceLockingFail:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera focissing is unavailable. Try again " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (BOOL) endingSession
{
    return YES;
}

@end
