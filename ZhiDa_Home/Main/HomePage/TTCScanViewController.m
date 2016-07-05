//
//  TTCScanViewController.m
//  TTC_Broadband
//
//  Created by 曾梓麟 on 16/1/3.
//  Copyright © 2016年 TTC. All rights reserved.
//

#import "TTCScanViewController.h"
#import "ZDHNavigationController.h"
#import "TTCScanViewControllerView.h"
#import "AFNetworking.h"
@import AVFoundation;
@interface TTCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) NSUserDefaults *userDefault;
// 扫码区域动画视图
@property (strong, nonatomic) TTCScanViewControllerView *scanerView;
//AVFoundation
// AV协调器
@property (strong,nonatomic) AVCaptureSession *session;
// 取景视图
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end
@implementation TTCScanViewController
#pragma mark - Init methods
- (void)initData{
    _userDefault = [NSUserDefaults standardUserDefaults];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self notification];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    self.scanerView.alpha = 0;
    //设置扫描区域边长
    self.scanerView = [[TTCScanViewControllerView alloc] init];
    self.scanerView.frame = self.view.frame;
    self.scanerView.scanAreaEdgeLength = [[UIScreen mainScreen] bounds].size.height - 2 * 200;// 2 * 250;
    [self.view addSubview:self.scanerView];
    
    if (!self.session){
        //添加镜头盖开启动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.type = @"cameraIrisHollowOpen";
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
        animation.delegate = self;
        [self.view.layer addAnimation:animation forKey:@"animation"];
        
        //初始化扫码
        [self setupAVFoundation];
        
        //调整摄像头取景区域
        self.previewLayer.frame = self.view.bounds;
        
        //调整扫描区域
        AVCaptureMetadataOutput *output = self.session.outputs.firstObject;
        //根据实际偏差调整y轴
        CGRect rect = CGRectMake((self.scanerView.scanAreaRect.origin.y + 20) / HEIGHT(self.scanerView),
                                 self.scanerView.scanAreaRect.origin.x / WIDTH(self.scanerView),
                                 self.scanerView.scanAreaRect.size.height / HEIGHT(self.scanerView),
                                 self.scanerView.scanAreaRect.size.width / WIDTH(self.scanerView));
        output.rectOfInterest = rect;
    }
}

- (void) notification{
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceive:) name:@"returnBack" object:nil];
}
// 返回界面
- (void)notificationReceive:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"returnBack"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Data request
#pragma mark - Protocol methods
//AVCaptureMetadataOutputObjectsDelegate Method
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects) {
        [self.session stopRunning];
        // 分割字符串
        /**
         http://dwz.cn/W07yf    //http://zhidajj.com/mobile/clothdetail.aspx?clothid=100000000123125
         http://dwz.cn/UNX2H    //http://zhidajj.com/mobile/prodetail.aspx?proid=1
         http://dwz.cn/33SzBH   //http://zhidajj.com/mobile/prodetail.aspx?proid=100000000173437
         http://dwz.cn/W07yf    //http://zhidajj.com/mobile/clothdetail.aspx?clothid=100000000123125 // 需要登录的
         http://dwz.cn/33OWxw   //http://zhidajj.com/mobile/prodetail.aspx?proid=100000058215625
         
         http://www.zhidajj.com/mobile/prodetail.aspx?proid=100001650092562
         http://www.zhidajj.com/mobile/prodetail.aspx?proid=100001482038712
         http://www.zhidajj.com/mobile/prodetail.aspx?proid=100000775784762
         http://www.zhidajj.com/mobile/prodetail.aspx?proid=100001570959589
         
         */
        NSArray *array = [metadata.stringValue componentsSeparatedByString:@"="];
        __block NSString *URLString = metadata.stringValue;
        if(array.count == 1){
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:@"http://dwz.cn/query.php" parameters:@{@"tinyurl":metadata.stringValue} success:^(NSURLSessionDataTask *task, id responseObject){
                
               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                if (![[dict valueForKey:@"longurl"] isEqualToString:@""]) {
                    URLString = [dict valueForKey:@"longurl"];
                    NSArray *arrayGoodsID = [URLString componentsSeparatedByString:@"="];
                    NSArray *arrayClassifyID = [[arrayGoodsID firstObject] componentsSeparatedByString:@"?"];
                // 判断是否二维码
                    if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode])
                    {
                        if (self.SYQRCodeSuncessBlock) {
                            self.SYQRCodeSuncessBlock([arrayGoodsID lastObject],[arrayClassifyID lastObject]);
                    }
                  
                    }else{
                    
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"这不是二维码哦~~"
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                 [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(NSURLSessionDataTask *task, NSError *error){
                
           }];
        }
        else{
            
            NSArray *arrayClassifyID = [[array firstObject] componentsSeparatedByString:@"?"];
            if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode])
            {
                if (self.SYQRCodeSuncessBlock) {
                    self.SYQRCodeSuncessBlock([array lastObject],[arrayClassifyID lastObject]);
                }
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"这不是二维码哦~~"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
#pragma mark - Other methods
//! 动画结束回调
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.scanerView.alpha = 1;
                     }];
}

//! 初始化扫码
- (void)setupAVFoundation{
    //创建会话
    self.session = [[AVCaptureSession alloc] init];
    //获取摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        [self.session addInput:input];
    } else {
        //出错处理
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"请在手机【设置】-【隐私】-【相机】选项中，允许【%@】访问您的相机",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [av show];
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output];
    
    //设置扫码类型
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   //条形码
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    //设置代理，在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //创建摄像头取景区域
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];

    // 改变摄像头方向
    if ([self.previewLayer connection].isVideoOrientationSupported)
        [self.previewLayer connection].videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    //开始扫码
    [self.session startRunning];
}
// 获取摄像机当前的方向位置
- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
//        NSLog(@"UIInterfaceOrientationPortrait");
        return AVCaptureVideoOrientationPortrait;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
//        NSLog(@"AVCaptureVideoOrientationLandscapeLeft");
        return AVCaptureVideoOrientationLandscapeLeft;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
//        NSLog(@"UIInterfaceOrientationLandscapeRight");
        return AVCaptureVideoOrientationLandscapeRight;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
//        NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}






@end
