//
//  LoadingView_1.h
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//


@interface LoadingView : UIView

+ (LoadingView *) showLoadingAt:(UIView *)view;
+ (void) hideLoadingViewAt:(UIView *)view;

@end
