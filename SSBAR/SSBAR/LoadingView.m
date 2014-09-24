//
//  LoadingView_1.m
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()
{
    UIActivityIndicatorView *spinner;
    UIView *container;
}
@property (nonatomic, strong) UILabel *loadingLabel;

@end

@implementation LoadingView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.alpha =  0.7;
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        container = [[UIView alloc] init];
        [container setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setFrame:CGRectMake(spinner.frame.origin.x, spinner.frame.origin.y, 50, 50)];
        [spinner startAnimating];
        [container addSubview:spinner];
        
        _loadingLabel = [[UILabel alloc] init];
        [_loadingLabel setFont:[UIFont systemFontOfSize:20]];
        [_loadingLabel setBackgroundColor:[UIColor clearColor]];
        [_loadingLabel setTextColor:[UIColor whiteColor]];
        [_loadingLabel setShadowColor:[UIColor clearColor]];
        [_loadingLabel setShadowOffset:CGSizeMake(0, 1)];
        [_loadingLabel setText:@"Loading..."];
        [container addSubview:_loadingLabel];
        
        [self addSubview:container];
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize viewsize = self.frame.size;
    CGSize spinnersize = [spinner bounds].size;
    CGSize textsize = CGSizeMake(100, 40);
    float bothwidth = spinnersize.width + textsize.width + 5.0f;
    
    CGRect containrect =
    {
        CGPointMake(floorf((viewsize.width / 2) - (bothwidth / 2)), floorf((viewsize.height / 2) - (spinnersize.height / 2))),
        CGSizeMake(bothwidth, spinnersize.height)
    };
    CGRect textrect =
    {
        CGPointMake(spinnersize.width + 5.0f, floorf((spinnersize.height / 2) - (textsize.height / 2))),
        textsize
    };
    CGRect spinrect =
    {
        CGPointZero,
        spinnersize
    };
    
    [container setFrame:containrect];
    [spinner setFrame:spinrect];
    [_loadingLabel setFrame:textrect];
}



+ (LoadingView *) showLoadingAt:(UIView *)view
{
	LoadingView *loadingView = [[LoadingView alloc] initWithFrame:view.bounds];
	[view addSubview:loadingView];
	return loadingView ;
}

+ (void) hideLoadingViewAt:(UIView *)view
{
	for (UIView *v in [view subviews])
    {
		if ([v isKindOfClass:[LoadingView class]])
        {
            [v removeFromSuperview];
            break;
		}
	}
}


@end
