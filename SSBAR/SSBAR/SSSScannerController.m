//
//  SSBarViewController.m
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "SSSScannerController.h"

#import "LoginViewController.h"
#import "ScannerViewController.h"
#import "ManualCodeViewController.h"
#import "AccountViewController.h"
#import "ConfirmationViewController.h"
#import "UserModel.h"
#import "SSSService.h"
#import "LoadingView.h"



@interface SSSScannerController () <SSSServiceDelegate>

{
    TransitionType transitionType;
    // Views
    NSMutableArray *viewList;
    NSMutableArray *viewLoginList;
    NSMutableArray *viewScannerList;
    NSMutableArray *viewManualCodeList;
    NSMutableArray *viewConfirmationList;
    NSMutableArray *viewAccountList;
}

@end

@implementation SSSScannerController

#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure for beginning
    [self configureForBeginning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Configure for beginning

- (void) configureForBeginning
{
    viewList = [[NSMutableArray alloc] init];
    viewLoginList = [[NSMutableArray alloc] init];
    viewScannerList = [[NSMutableArray alloc] init];
    viewManualCodeList = [[NSMutableArray alloc] init];
    viewConfirmationList = [[NSMutableArray alloc] init];
    viewAccountList = [[NSMutableArray alloc] init];
    // Check IOS version
    if (IS_OS_7_OR_LATER)
    {
        // Calll auto login
        [self autoLogin];
    }
    else
    {
        // Show error message
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"App support for IOS 7 or later.Please upgrade your OS."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

#pragma mark - Methods

static SSSScannerController *instance = nil;

+ (SSSScannerController *) share
{
	if (instance == nil)
    {
		instance = [[SSSScannerController alloc] init];
	}
	return instance;
}

- (void) gotoScreenAtIndex:(int) index Animated :(BOOL) animated AnimatonDirection:(NSString* ) animationDirection
{
    /*  Index 0 : LoginViewController
              1 : ScannerViewController
              2 : ManualCodeViewController
              3 : ConfirmationViewController
              4 : AccountViewController
     */
    
     UIViewController*temp;
    
    switch (index)
    {
        case 0:
        {
            LoginViewController *loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            viewList = viewLoginList;
            [viewLoginList addObject:loginViewController];
            temp = [viewLoginList lastObject];
            [self handleAddingView:temp.view animated:animated Animation:animationDirection];
            loginViewController = nil;
            break;
        }
        case 1:
        {
           ScannerViewController *scannerViewController = [[ScannerViewController alloc]init];
            viewList = viewScannerList;
            [viewScannerList addObject:scannerViewController];
            temp = [viewScannerList lastObject];
            [self handleAddingView:temp.view animated:animated Animation:animationDirection];
            scannerViewController = nil;
            break;
        }
        case 2:
        {
            ManualCodeViewController *manualCodeViewController = [[ManualCodeViewController alloc]initWithNibName:@"ManualCodeViewController" bundle:nil];
            viewList = viewManualCodeList;
            [viewManualCodeList addObject:manualCodeViewController];
            temp = [viewManualCodeList lastObject];
            [self handleAddingView:temp.view animated:animated Animation:animationDirection];
            manualCodeViewController = nil;
            break;
        }
        case 3:
        {
            ConfirmationViewController *confirmationViewController = [[ConfirmationViewController alloc]initWithNibName:@"ConfirmationViewController" bundle:nil];
            viewList = viewConfirmationList;
            [viewConfirmationList addObject:confirmationViewController];
            temp = [viewConfirmationList lastObject];
            [self handleAddingView:temp.view animated:animated Animation:animationDirection];
            [(ConfirmationViewController*)temp updateSubViews:_isValidCode Message:_messageAfterScanning];
            confirmationViewController = nil;
            _messageAfterScanning = nil;
            
            break;
        }
        case 4:
        {
            AccountViewController *accountViewController = [[AccountViewController alloc]initWithNibName:@"AccountViewController" bundle:nil];
            viewList = viewAccountList;
            [viewAccountList addObject:accountViewController];
            temp = [viewAccountList lastObject];
            [self handleAddingView:temp.view animated:animated Animation:animationDirection];
            accountViewController = nil;
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}

- (void) handleAddingView:(UIView *)view animated:(BOOL)animated Animation:(NSString* )animationDirection
{
    if (animated)
    {
        [self addSubViewWithAnimation:view AnimationDirection:animationDirection];
    }
    else
    {
        [self addSubViewWithNoAnimation:view];
    }
}

- (void)addSubViewWithNoAnimation:(UIView*) subview
{
    [self.view addSubview:subview];
    [self.view bringSubviewToFront:subview];
    
}

- (void)addSubViewWithAnimation:(UIView*) subview AnimationDirection:(NSString*) animationDirection
{
    [UIView transitionWithView:self.view duration:2.0f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^ {
                        [self.view addSubview:subview];
                        [self.view bringSubviewToFront:subview];
                    }
                    completion:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionPush;
    transition.subtype = animationDirection;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:transition forKey:nil];
    
}
- (void) backToOneView:(UIView *)view animationDirection:(NSString *) animationDirection
{
    [UIView transitionWithView:self.view duration:0.5f
                       options:UIViewAnimationOptionShowHideTransitionViews
                    animations:^ {
                        
                       
                     [view removeFromSuperview];
                    }
                    completion:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.type = kCATransitionPush;
    transition.subtype = animationDirection;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:NO];
    [self.view.layer addAnimation:transition forKey:nil];
    
   
}
#pragma mark - User Info Handle
- (void) autoLogin
{
    UserModel *userInfo = [self getUserModel];
    if (userInfo.userName && userInfo.password)
    {
        // Add loading View
        [LoadingView showLoadingAt:self.view];
        // Call Service
        SSSService *service = [SSSService share];
        [service setDelegate:self];
        [service callLoginWithUserName:userInfo.userName Password:userInfo.password];
    }
    else
    {
         [self gotoScreenAtIndex:0 Animated:NO AnimatonDirection:@""];
    }
    
}

- (void) setUserModelWithUserName:(NSString* )userName accessToken:(NSString *)accessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:USER_INFO_USERNAME];
    [defaults setObject:accessToken forKey:USER_INFO_ACCESS_TOKEN];
    [defaults synchronize];
}
- (void) setPassword:(NSString*)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:USER_INFOR_PASSWORD];
    [defaults synchronize];
}


- (UserModel *) getUserModel
{
    UserModel *userModel = [[UserModel alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userModel.userName= [defaults objectForKey:USER_INFO_USERNAME];
    userModel.password = [defaults objectForKey:USER_INFOR_PASSWORD];
    userModel.accessToken = [defaults objectForKey:USER_INFO_ACCESS_TOKEN];
    
    return userModel;
}
- (void) removeUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_INFO_USERNAME];
    [defaults removeObjectForKey:USER_INFOR_PASSWORD];
    [defaults removeObjectForKey:USER_INFO_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - SSSServiceDelegate
- (void) loginSuceesfully
{
    // Remove loading View
    [LoadingView hideLoadingViewAt:self.view];

    // Go to scanner view
    [[SSSScannerController share]gotoScreenAtIndex:1 Animated:YES AnimatonDirection:kCATransitionFromLeft];
}
- (void) loginFail:(NSString*)message
{
    // Remove loading View
    [LoadingView hideLoadingViewAt:self.view];
    
    // Show error message
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Auto login unsuccessfully."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
    // Go to Login View
     [self gotoScreenAtIndex:0 Animated:NO AnimatonDirection:@""];
}

@end
