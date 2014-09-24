//
//  ManualCodeViewController+SSSService.h
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ManualCodeViewController.h"

#import "SSSService.h"

@interface ManualCodeViewController (SSSService) <SSSServiceDelegate>

- (void) sendCode :(NSString*) code;

@end
