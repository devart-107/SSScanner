//
//  ScanerViewController.m
//  SSBAR
//
//  Created by devart107 on 9/20/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ScannerViewController.h"

#import "ScannerViewController+ScannerViewDelegate.h"
#import "ScannerViewController+SSSService.h"

#pragma mark - ViewController Life Cycle

@implementation ScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure For Beginning
    [self configureForBeginning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_scannerView stopScanning];
    [_scannerView stopCaptureSession];
}

#pragma mark - Configure for beginning

- (void) configureForBeginning
{
    // Scanner View
    [_scannerView setDelegate:self];
    [_scannerView setShowScannerLine:YES];
    [_scannerView setDisplayCode:YES];
    [_scannerView startCaptureSession];
    // Service
    _service = [SSSService share];
    [_service setDelegate:self];
}

#pragma mark - Actions

- (IBAction)settingButtonTap:(id)sender
{
    // Go to Account view
    [[SSSScannerController share] gotoScreenAtIndex:4 Animated:YES AnimatonDirection:kCATransitionFromBottom];
}

- (IBAction)enterManualCodeTapped:(id)sender
{
    // Go to Manual code view
    [[SSSScannerController share] gotoScreenAtIndex:2 Animated:YES AnimatonDirection:kCATransitionFromTop];
}



@end
