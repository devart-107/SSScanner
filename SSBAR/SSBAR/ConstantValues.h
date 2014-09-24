//
//  ConstantValues.h
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#ifndef SSBAR_ConstantValues_h
#define SSBAR_ConstantValues_h

// Define debug log
#define Debug_Mode

#if !defined(Debug_Mode)
#define DebugLog(...) do {} while (0)
#else
#define DebugLog(...) NSLog(__VA_ARGS__)
#endif

// Services
#define SERVICES_BASE_LINK @"https://sss-mobile-test.herokuapp.com"
#define SERVICES_LOGIN_PATH @"/login"
#define SERVICES_SCAN_PATH @"/scan"
#define SERVICES_POST_METHOD_REQUEST @"POST"

// User Info
#define USER_INFO_USERNAME @"username"
#define USER_INFOR_PASSWORD @"password"
#define USER_INFO_ACCESS_TOKEN @"access_token"

// Barcode/QR code info
#define CODE_INFO @"code"

// SENDING ERROR
#define SENDING_CODE_ERROR @"error"
#define SENDING_CODE_ERROR_MESSAGE @"message"
#define SENDING_CODE_ERROR_CODE @"code"

// Check IOS version
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif
