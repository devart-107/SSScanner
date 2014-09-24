//
//  ScannerViewController+SSSService.h
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ScannerViewController.h"

#import "SSSService.h"

@interface ScannerViewController (SSSService) <SSSServiceDelegate>

- (void) sendCode :(NSString*) code;

@end
