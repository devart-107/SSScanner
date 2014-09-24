//
//  ScannerView.h
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

@protocol ScannerViewDelegate

@required

- (void) scanedCode:(NSString *)scannedCode WithCodeType:(NSString *)codeType;
- (void) trackingErrorCaptureSession:(NSError *)error;

@optional

- (void) deviceLockingFail:(NSError *)error;
- (BOOL) endingSession;

@end

@class AVCaptureSession;

@interface ScannerView : UIView

// Properties

@property (strong) AVCaptureSession *avCaptureSession;
@property (assign) BOOL showScannerLine;
@property (assign) BOOL displayCode;
@property (nonatomic, weak) id <ScannerViewDelegate> delegate;

// Methods
- (BOOL) isScanning;
- (void) startCaptureSession;
- (void) stopCaptureSession;
- (void) startScanning;
- (void) stopScanning;
- (NSString*) acceptableCodeType:(NSString*)codeType;

@end
