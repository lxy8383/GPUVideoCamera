//
//  ViewController.m
//  GPUVideoCamera
//
//  Created by liu on 2018/9/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    AVAuthorizationStatus authStatus = [AVCaptureDevic eauthorizationStatusForMediaType:AVMediaTypeVideo];
    

    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                
                imagePicker.allowsEditing = YES;
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                imagePicker.delegate = self;
                
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                    NSLog(@"打开相册");
                    
                }];

            }
        }];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
            NSLog(@"打开相册");
            
        }];

    }
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
