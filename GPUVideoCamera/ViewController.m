//
//  ViewController.m
//  GPUVideoCamera
//
//  Created by liu on 2018/9/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>
#import "PlayControlView.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, PlayControlViewDelegate>

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;


@property (nonatomic, strong) GPUImageView *videoImageView;

// 写视频
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

// 图层view
@property (nonatomic, strong) PlayControlView *videoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    self.videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    
    if ([self.videoCamera.inputCamera lockForConfiguration:nil]) {
        //自动对焦
        if ([self.videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.videoCamera.inputCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([self.videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [self.videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        //自动白平衡
        if ([self.videoCamera.inputCamera isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [self.videoCamera.inputCamera setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
    // 输出方向为竖屏
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [self.videoCamera addAudioInputsAndOutputs];
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    
    self.videoImageView = [[GPUImageView alloc]initWithFrame:self.view.frame];
    self.videoImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:self.videoImageView];
    
    [self.videoCamera addTarget:self.videoImageView];
    [self.videoCamera startCameraCapture];
    
    [self.view addSubview:self.videoView];
    self.videoView.frame = self.view.frame;
    
}

#pragma mark - ViewDelegate
//开始拍摄
- (void)startCapture:(BOOL)isCapture
{
    [self.movieWriter startRecording];
}

- (void)setUpFilter:(BOOL)isSet
{
    GPUImageBilateralFilter *filter = [[GPUImageBilateralFilter alloc]init];
    [self.videoCamera addTarget:filter];
    [filter addTarget:self.videoImageView];
}

#pragma mark - lazy
- (GPUImageMovieWriter *)movieWriter
{
    if(!_movieWriter){
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"GPUVideo"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *path = [dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MOV",@"liuxytemp"]];
        
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        _movieWriter = [[GPUImageMovieWriter alloc]initWithMovieURL:fileUrl size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.videoCamera addTarget:_movieWriter];
        self.videoCamera.audioEncodingTarget = _movieWriter;
    }
    return _movieWriter;
}

- (PlayControlView *)videoView
{
    if(!_videoView){
        _videoView = [[PlayControlView alloc]init];
        _videoView.delegate = self;
    }
    return _videoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
