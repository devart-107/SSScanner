//
//  ScanerViewController.h
//  SSBAR
//
//  Created by devart107 on 9/20/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

@class ScannerView;
@class SSSService;

@interface ScannerViewController : UIViewController

@property (weak, nonatomic) IBOutlet ScannerView *scannerView;
@property (weak, nonatomic) IBOutlet UILabel *guideView;
@property SSSService* service;

@end
