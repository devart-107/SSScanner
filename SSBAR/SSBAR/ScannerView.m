//
//  ScannerView.m
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "ScannerView.h"

#import <AVFoundation/AVFoundation.h>

#import "ScannerView.h"
#import "BoundingView.h"

@interface ScannerView ()  <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureDeviceInput *videoInput;
    AVCaptureMetadataOutput *metadataOutput;
    AVCaptureVideoPreviewLayer *avCaptureVideoPreviewLayer;
    UIView *scanningLineView;
    BoundingView *boundingView;
    UIColor *lineColor;
    
}

- (void) configureForBeginning;
- (void) configureMetadataOutput;
- (void) removeMetadataOutput;
- (void) configurePreviewLayer;
- (void) configureCameraFocus;
- (void) stopCameraFlash;

@end

@implementation ScannerView

#pragma mark - ScanView lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self configureForBeginning];
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureForBeginning];
    }
    
    return self;
}

- (void) dealloc
{
    [_avCaptureSession stopRunning];
    
    for (AVCaptureInput *input in _avCaptureSession.inputs)
    {
        [_avCaptureSession removeInput:input];
    }

    for (AVCaptureOutput *output in _avCaptureSession.outputs)
    {
        [_avCaptureSession removeOutput:output];
    }
    
    [avCaptureVideoPreviewLayer removeFromSuperlayer];
    
    _avCaptureSession = nil;
    metadataOutput = nil;
    videoInput = nil;
    avCaptureVideoPreviewLayer = nil;
}


#pragma mark - configureForBeginning

- (void) configureForBeginning
{
    _avCaptureSession = [[AVCaptureSession alloc] init];
	lineColor = [UIColor greenColor];
}

#pragma mark - Methods

- (BOOL) isScanning
{
    if ([_avCaptureSession isRunning] == YES)
    {
        if ([_avCaptureSession.outputs containsObject:metadataOutput] == YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (BOOL) isCaptureSessionInProgress
{
    if ([_avCaptureSession isRunning] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void) startCaptureSession
{
    
    NSError *error = nil;
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if (videoInput)
    {
        if ([_avCaptureSession.inputs containsObject:videoInput] == NO)
        {
            [_avCaptureSession addInput:videoInput];
        }
        
        [self configureMetadataOutput];
        
        [self configurePreviewLayer];
        
        [self configureCameraFocus];
        
        if ([_avCaptureSession isRunning] == NO)
        {
            [_avCaptureSession startRunning];
        }
        
        [self startScanning];
        
    }
    else
    {
        [self.delegate trackingErrorCaptureSession:error];
        
    }
}

- (void) stopCaptureSession
{
    [self stopScanning];
    
    [UIView animateWithDuration:0.2 animations:^{
        boundingView.alpha = 0.0;
    }];
    
    [_avCaptureSession stopRunning];
}

- (void) startScanning
{
    if (([self isCaptureSessionInProgress] == YES) && ([self isScanning] == NO))
    {
        [self configureMetadataOutput];
        
    }
    else if ([self isCaptureSessionInProgress] == NO)
    {
        [self startCaptureSession];
    }
    
    if (_showScannerLine)
    {
        boundingView = [[BoundingView alloc] initWithFrame:self.bounds];
        boundingView.alpha = 0.0;
        [self addSubview:boundingView];
        
        if (!scanningLineView)
        {
            scanningLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        }
        scanningLineView.backgroundColor = [UIColor greenColor];
        scanningLineView.layer.shadowColor = lineColor.CGColor;
        scanningLineView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        scanningLineView.layer.shadowOpacity = 0.6;
        scanningLineView.layer.shadowRadius = 1.5;
        scanningLineView.alpha = 0.0;
        if (![[self subviews] containsObject:scanningLineView])
        {
            [self addSubview:scanningLineView];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            scanningLineView.alpha = 1.0;
        }];
        
        [UIView animateWithDuration:4.0 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
            scanningLineView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 2);
        } completion:nil];
    }
}

- (void) stopScanning
{
    [UIView animateWithDuration:0.2 animations:^{
        scanningLineView.alpha = 0.0;
    }];

    [self removeMetadataOutput];
    
    [self stopCameraFlash];
    
}

- (void) configureMetadataOutput
{
    
    if (!metadataOutput)
    {
        metadataOutput = [[AVCaptureMetadataOutput alloc] init];

    }
    
    if ([_avCaptureSession.outputs containsObject:metadataOutput] == NO)
    {
        [_avCaptureSession addOutput:metadataOutput];
    }
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode]];
}

- (void) removeMetadataOutput
{
    if ([_avCaptureSession.outputs containsObject:metadataOutput] == YES)
    {
        [_avCaptureSession removeOutput:metadataOutput];
    }
}

- (void) configurePreviewLayer
{
    if (!avCaptureVideoPreviewLayer)
    {
        avCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_avCaptureSession];
    }
    avCaptureVideoPreviewLayer.frame = self.layer.bounds;
    avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avCaptureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    [[avCaptureVideoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    if ([self.layer.sublayers containsObject:avCaptureVideoPreviewLayer] == NO)
    {
        [self.layer addSublayer:avCaptureVideoPreviewLayer];
    }
}


- (void) configureCameraFocus
{
    AVCaptureDevice *avCaptureDevice = videoInput.device;
    NSError *error;
    if ([avCaptureDevice lockForConfiguration:&error])
    {
        if ([avCaptureDevice isFocusPointOfInterestSupported] && [avCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            [avCaptureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([avCaptureDevice isAutoFocusRangeRestrictionSupported])
        {
            [avCaptureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
        }
        
        [avCaptureDevice unlockForConfiguration];
    }
    else
    {
        [_delegate deviceLockingFail:error];
    }
}


- (void) setDeviceFlash:(AVCaptureFlashMode)flashMode
{
    AVCaptureDevice *avCaptureDevice = videoInput.device;
    
    if (![avCaptureDevice isFlashAvailable] && ![avCaptureDevice isFlashModeSupported:flashMode])
    {
        return;
    }
    NSError *error;
    
    if ([avCaptureDevice lockForConfiguration:&error])
    {
        [avCaptureDevice setFlashMode:flashMode];
        [avCaptureDevice unlockForConfiguration];
    }
    else
    {
        [_delegate deviceLockingFail:error];
    }
}

- (void) stopCameraFlash
{
    AVCaptureDevice *avCaptureDevice = videoInput.device;

    if (![avCaptureDevice isFlashAvailable] && ![avCaptureDevice isFlashActive])
    {
        return;
    }
 
    NSError *error;
    if ([avCaptureDevice lockForConfiguration:&error])
    {
        [avCaptureDevice setFlashMode:AVCaptureFlashModeOff];
        [avCaptureDevice unlockForConfiguration];
    }
    else
    {
        [_delegate deviceLockingFail:error];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    AVCaptureDevice *avCaptureDevice = videoInput.device;
    if (![avCaptureDevice isFocusPointOfInterestSupported] && ![avCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        return;
    }
    
    NSError *error;
    
    if ([avCaptureDevice lockForConfiguration:&error])
    {
        [avCaptureDevice setFocusPointOfInterest:touchPoint];
        [avCaptureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        [avCaptureDevice unlockForConfiguration];
    }
    else
    {
        [_delegate deviceLockingFail:error];
    }
}

- (NSString *)acceptableCodeType:(NSString *)codeType
{
    if (codeType == AVMetadataObjectTypeAztecCode)
    {
        return @"Aztec";
    }
    
    if (codeType == AVMetadataObjectTypeCode128Code)
    {
        return @"Code 128";
    }
    
    if (codeType == AVMetadataObjectTypeCode39Code)
    {
        return @"Code 39";
    }
    
    if (codeType == AVMetadataObjectTypeCode39Mod43Code)
    {
        return @"Code 39 Mod 43";
    }
    
    if (codeType == AVMetadataObjectTypeCode93Code)
    {
        return @"Code 93";
    }
    
    if (codeType == AVMetadataObjectTypeEAN13Code)
    {
        return @"EAN13";
    }
    
    if (codeType == AVMetadataObjectTypeEAN8Code)
    {
        return @"EAN8";
    }
    
    if (codeType == AVMetadataObjectTypePDF417Code)
    {
        return @"PDF417";
    }
    
    if (codeType == AVMetadataObjectTypeQRCode)
    {
        return @"QR";
    }
    
    if (codeType == AVMetadataObjectTypeUPCECode)
    {
        return @"UPCE";
    }
    
    return nil;
}

- (NSArray *)translatePoints:(NSArray *)points fromView:(UIView *)fromView toView:(UIView *)toView
{
    NSMutableArray *translatedPoints = [NSMutableArray new];
    for (NSDictionary *point in points)
    {
        CGPoint pointValue = CGPointMake([point[@"X"] floatValue], [point[@"Y"] floatValue]);
        CGPoint translatedPoint = [fromView convertPoint:pointValue toView:toView];
        [translatedPoints addObject:[NSValue valueWithCGPoint:translatedPoint]];
    }
    
    return [translatedPoints copy];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
	for (AVMetadataObject *metadataObject in metadataObjects)
    {
		AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        AVMetadataMachineReadableCodeObject *transformedObject = (AVMetadataMachineReadableCodeObject *)[avCaptureVideoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        
        [self.delegate scanedCode:readableObject.stringValue WithCodeType:readableObject.type];
        
        BOOL shouldEndSession = [self.delegate endingSession];
        if (shouldEndSession == YES)
        {
            [self stopScanning];
        }
        else
        {
            if (_displayCode)
            {
                // Update the frame on the boundingBox view, and show it
                [UIView animateWithDuration:0.2 animations:^{
                    scanningLineView.alpha = 0.0;
                    boundingView.frame = transformedObject.bounds;
                    boundingView.alpha = 1.0;
                    boundingView.corners = [self translatePoints:transformedObject.corners fromView:self toView:boundingView];
                }];
                
                [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    scanningLineView.alpha = 1.0;
                    boundingView.alpha = 0.0;
                } completion:nil];
            }
            
            continue;
        }
        
	}
}




@end
