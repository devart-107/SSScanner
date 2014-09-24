//
//  SSBarViewController.h
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

@class LoginViewController;
@class ScannerViewController;
@class ManualCodeViewController;
@class AccountViewController;
@class ConfirmationViewController;
@class UserModel;

typedef enum
{
    TransitionTypeNormal,
    TransitionTypeGravity
    
} TransitionType;

@interface SSSScannerController : UIViewController

// Properties
@property (assign) BOOL isValidCode;
@property (strong) NSString* messageAfterScanning;

// Methods
+ (SSSScannerController*)share;
- (void) setUserModelWithUserName:(NSString* )userName accessToken:(NSString *)accessToken;
- (UserModel *) getUserModel;
- (void) setPassword:(NSString*)password;
- (void) gotoScreenAtIndex:(int) index Animated :(BOOL) animated AnimatonDirection:(NSString* ) animationDirection;
- (void) backToOneView:(UIView *)view animationDirection:(NSString *) animationDirection;
- (void) removeUserInfo;

@end
