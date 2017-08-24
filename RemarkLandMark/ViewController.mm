//
//  ViewController.m
//  RemarkLandMark
//
//  Created by duanhai on 2017/8/14.
//  Copyright © 2017年 duanhai. All rights reserved.
//

#import "ViewController.h"
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/highgui/cap_ios.h>

#include <opencv2/objdetect/objdetect.hpp>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#include <vector>
#include <iostream>
#include <fstream>
#include "ldmarkmodel.h"
//#include "TestLog.h"
using namespace std;
using namespace cv;

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]


@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,CvVideoCameraDelegate>
{

    int faces_count;
    ldmarkmodel modelt;
    cv::Mat current_shape;


}

@property (nonatomic, strong) CvVideoCamera *videoCamera;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *tmpDir =  NSTemporaryDirectory();
    NSString *res = [[NSBundle mainBundle] resourcePath];
    NSString *modelBinPath = [res stringByAppendingString:@"/PCA-SDM-model_9w_stan_distclose.bin"];
    NSString *modelXmlPath = [res stringByAppendingString:@"/haar_roboman_ff_alt2.xml"];

    std::string mypath =  std::string([modelBinPath UTF8String]);
    std::string xmlPathStr =  std::string([modelXmlPath UTF8String]);

    while (!load_ldmarkmodel(mypath, modelt)) {
        std::cout << "载入文件路径错误" << endl;
        std::cin >> mypath;
    }
    
    modelt.loadFaceDetModelFile(xmlPathStr);
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imv];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.delegate = self;
    

    

//    [self setupAndStartCapture];
       // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    cv::Mat Image = image;
    NSString *tmpDir =  NSTemporaryDirectory();
    NSString *saveFileName = [tmpDir stringByAppendingString:@"/test.png"];
    std::string pngName = std::string([saveFileName UTF8String]);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        imwrite(pngName, Image);
//    });
    double t = (double)cvGetTickCount();
    modelt.track(Image, current_shape);
    t = (double)cvGetTickCount() - t;
    std::cout <<"modelt.track time "<< t / (cvGetTickFrequency() * 1000) << std::endl;
    cv::Vec3d eav;
//    modelt.EstimateHeadPose(current_shape, eav);
//    modelt.drawPose(Image, current_shape, 50);
    int numLandmarks = current_shape.cols/2;
    for(int j=0; j<numLandmarks; j++){
        int x = current_shape.at<float>(j);
        int y = current_shape.at<float>(j + numLandmarks);
        std::stringstream ss;
        ss << j;
        cv::circle(Image, cv::Point(x, y), 2, cv::Scalar(0, 0, 255), -1);
    }
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startCapture:(id)sender {
    [self.videoCamera start];

}


@end
