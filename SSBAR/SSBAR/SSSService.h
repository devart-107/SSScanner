//
//  SSSService.h
//  SSBAR
//
//  Created by devart107 on 9/22/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//
@protocol SSSServiceDelegate

@optional
- (void) loginSuceesfully;
- (void) loginFail:(NSString*)message;
- (void) didSendCode:(NSString*)message;
@end


@interface SSSService : NSObject

@property (weak, nonatomic) id<SSSServiceDelegate> delegate;

// Methods
+ (SSSService *) share;
- (void) callLoginWithUserName:(NSString* )username Password:(NSString *)password;
- (void) callsendingCode:(NSString*)code;

@end
