//
//  CFBSurveyViewController.m
//  CFB
//
//  Created by 周鑫 on 2018/8/21.
//  Copyright © 2018年 ZX. All rights reserved.
//  测量控制器

#import "CFBSurveyViewController.h"
#import "CoreLocation/CoreLocation.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking/AFNetworking.h>

//#import "TNGWebNavigationViewController.h"

#import <TJWebTools/TJWebTools.h>
#import "History+CoreDataClass.h"

@interface CFBSurveyViewController ()<CLLocationManagerDelegate>
@property (nonatomic,weak) UIImageView *meterBackgroun;
@property (nonatomic,weak) UIImageView *meterDial;
@property (nonatomic,weak) UIImageView *meterIndicator;
@property (nonatomic,weak) UIImageView *meterCenterMask;
@property (nonatomic,weak) UILabel *decibelLabel;
@property (nonatomic,weak) UILabel *minimumDecibelLabel;
@property (nonatomic,weak) UILabel *maximumDecibelLabel;
@property (nonatomic,weak) UIButton *startBtn;
@property (nonatomic,weak) UILabel *identifierLabel;


@property (nonatomic,weak) UILabel *LocationLabel;

@property (strong, nonatomic) CLLocationManager* locationManager;



@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation CFBSurveyViewController
{
    
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    
    NSInteger minimumDecibel;
    NSInteger maximumDecibel;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
//    [self startLocation];
    
    [self.decibelLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [self networking];
    
//    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"path"];
//    if (path) {
//
    
//    }
}

- (void)networking {
    
    
    NSDictionary *dic = @{@"appId":@"tj2_20180720008"};
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc]init];
    [httpManager GET:@"http://149.28.12.15:8080/app/get_version" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *retDataDic = dic[@"retData"];
            if ([retDataDic[@"version"] isEqualToString:@"2.0"]) {
                
                TNGWebNavigationViewController *NAV_VC = [[TNGWebNavigationViewController alloc]init];
                NSString *urlstring = retDataDic[@"updata_url"];
                if (!urlstring.length) {
                    urlstring = @"http://www.baidu.com";
                }
                NAV_VC.url = urlstring ;
                [self presentViewController:NAV_VC animated:NO completion:nil];
//                 [[NSUserDefaults standardUserDefaults] setObject: forKey:@"path"];
                //                Web.url = @"http://www.baidu.com";
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"text"] && self.startBtn.selected  ) {
        NSLog(@"%@",change);
        NSInteger newDecibel = [change[@"new"] integerValue];
        if (minimumDecibel == 0 && maximumDecibel == 0) {
            minimumDecibel = newDecibel;
            maximumDecibel = newDecibel;
        } else  {
            
            if (newDecibel < minimumDecibel) {
                minimumDecibel = newDecibel;
                self.minimumDecibelLabel.text = [NSString stringWithFormat:@"%ld",minimumDecibel];
            }
            if (newDecibel > maximumDecibel) {
                maximumDecibel = newDecibel;
                self.maximumDecibelLabel.text = [NSString stringWithFormat:@"%ld",maximumDecibel];
            }
        }
        
    }
}

-(void)startLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;//遵循代理
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 10.0f;
        
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
//        [_locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];//开始定位
        
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
        
        //1.提醒用户检查当前的网络状况
        
        //2.提醒用户打开定位开关
        
    }
    
}


- (void)setupUI {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1"]];
    self.title = @"測定";
    
    __weak typeof(self) weakSelf = self;
    UILabel *LocationLabel = [[UILabel alloc]init];
    LocationLabel.text = @"ポジショニング..";
    LocationLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:LocationLabel];
    self.LocationLabel = LocationLabel;
    [self.LocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(iPhoneX?104:84);
    }];
    
    UIImageView *meterDial = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biaopan"]];
//    meterDial.backgroundColor = [UIColor redColor];
    [self.view addSubview:meterDial];
    self.meterDial = meterDial;
    [self.meterDial mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(self.meterDial.width);
    }];
    
    
    UIImageView *meterIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhizhen"]];
    meterIndicator.layer.anchorPoint = CGPointMake(0.5, 1);
    meterIndicator.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    [self.view addSubview:meterIndicator];
    self.meterIndicator = meterIndicator;
    [self.meterIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(meterDial.height).multipliedBy(0.5);
//        make.bottom.equalTo(self.view.centerY);
        
        make.width.equalTo(10);
    }];
    
    
        UIImageView *meterBackgroun = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg2"]];
        [self.view addSubview:meterBackgroun];
        self.meterBackgroun = meterBackgroun;
        [self.meterBackgroun mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.left.equalTo(self.view).offset(100);
            make.right.equalTo(self.view).offset(-100);
            make.height.equalTo(self.meterBackgroun.width);
        }];
    
    
    UILabel *decibelLabel = [[UILabel alloc]init];
    decibelLabel.textColor = [UIColor whiteColor];
    decibelLabel.text = @"0";
    decibelLabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:decibelLabel];
    self.decibelLabel = decibelLabel;
    [self.decibelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    
    UILabel *identifierLabel = [[UILabel alloc]init];
    identifierLabel.textColor = [UIColor whiteColor];
    identifierLabel.text = @"测量中..";
    identifierLabel.font = [UIFont systemFontOfSize:14];
    identifierLabel.hidden = YES;
    [self.view addSubview:identifierLabel];
    self.identifierLabel = identifierLabel;
    [self.identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(decibelLabel.bottom).offset(10);
    }];
    
//
//    NSLog(@"%f",self.view.frame.size.width);
//    NSLog(@"%f",self.view.frame.size.height);
    UILabel *minimumDecibelLabel = [[UILabel alloc]init];
    minimumDecibelLabel.textColor = [UIColor whiteColor];
    minimumDecibelLabel.text = @"0";
    minimumDecibelLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:minimumDecibelLabel];
    self.minimumDecibelLabel = minimumDecibelLabel;
    [self.minimumDecibelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(60);
        make.top.equalTo(weakSelf.meterDial.bottom).offset(-40);
    }];
    
    UILabel *minimumLabel = [[UILabel alloc]init];
    minimumLabel.textColor = [UIColor whiteColor];
    minimumLabel.text = @"Min";
    minimumLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:minimumLabel];
//    self.minimumLabel = minimumLabel;
    [minimumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minimumDecibelLabel.bottom);
        make.centerX.equalTo(minimumDecibelLabel.centerX);
    }];
    
    UILabel *maximumDecibelLabel = [[UILabel alloc]init];
    maximumDecibelLabel.textColor = [UIColor whiteColor];
    maximumDecibelLabel.text = @"0";
    maximumDecibelLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:maximumDecibelLabel];
    self.maximumDecibelLabel = maximumDecibelLabel;
    [self.maximumDecibelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-60);
         make.top.equalTo(weakSelf.meterDial.bottom).offset(-40);
    }];
    
    UILabel *maximumLabel = [[UILabel alloc]init];
    maximumLabel.textColor = [UIColor whiteColor];
    maximumLabel.text = @"Max";
    maximumLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:maximumLabel];
    //    self.minimumLabel = minimumLabel;
    [maximumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maximumDecibelLabel.bottom);
        make.centerX.equalTo(maximumDecibelLabel.centerX);
    }];
    
    
    UIButton *startBtn = [[UIButton alloc]init];
    startBtn.backgroundColor = [UIColor orangeColor];
    startBtn.layer.cornerRadius = 5;
    startBtn.layer.masksToBounds = YES;
    [startBtn setTitle:@"測定を開始する" forState:UIControlStateNormal];
    [startBtn setTitle:@"測定終了" forState:UIControlStateSelected];
    [startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    self.startBtn = startBtn;
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(iPhoneX?-100:-60);
        make.centerX.equalTo(self.view);
        make.width.equalTo(200);
        make.height.equalTo(44);
    }];
}

- (void)startBtnClicked:(UIButton *)btn {
    
    AudioServicesPlaySystemSound(1256);
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    [self initializeRecorder];
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized:
            {
                [self initializeRecorder];
                break;
            }
                
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
            {
                break;
            }
                
                
            default:
                break;
        }
        
    }else {
        
        [self stopRecord];
        
    }
  
   
    
}



- (void)initializeRecorder {
    
    
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0  */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.identifierLabel.hidden = NO;
        });
        
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
    else
    {
        NSLog(@"%@", [error description]);
    }

}


- (void)stopRecord {
    
    if (recorder.record) {
         [recorder stop];
        self.identifierLabel.hidden = YES;
    }
    
//    NSArray *historys = [[NSUserDefaults standardUserDefaults] objectForKey:@"historys"];
//    NSMutableArray *muHistorys = [NSMutableArray arrayWithArray:historys];
////    if (!historys) {
////        historys = [[NSMutableArray alloc]init];
////    }
//
//    NSDictionary *history = @{   @"Min":self.minimumDecibelLabel.text,
//                              @"Max":self.maximumDecibelLabel.text,
//                              @"Location":self.LocationLabel.text,
//                                 @"date":[[[NSDate alloc]init] jk_stringWithFormat:@"yyyy-MM-dd HH:mm"]
//                              };
//
//    [muHistorys addObject:history];
//    [[NSUserDefaults standardUserDefaults] setObject:muHistorys forKey:@"historys"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 创建托管对象，并指明创建的托管对象所属实体名
    History *emp = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:self.context];
    emp.min = self.minimumDecibelLabel.text;
    emp.max = self.maximumDecibelLabel.text;
    emp.location = self.LocationLabel.text;
    emp.time = [[[NSDate alloc]init] jk_stringWithFormat:@"yyyy-MM-dd HH:mm"];
    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (self.context.hasChanges) {
        [self.context save:&error];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
}

/* 该方法确实会随环境音量变化而变化，但具体分贝值是否准确暂时没有研究 */
- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.decibelLabel setText:[NSString stringWithFormat:@"%.0f", level*120]];
        [self rotationeterIndicator:level * 120];
//        [self minimumAndMaximum:level * 120];
    });
}
- (void)rotationeterIndicator:(NSInteger )angle {
    
    CGFloat radian = -M_PI_2 + angle * M_PI / 180;
    [UIView animateWithDuration:1 animations:^{
        //        self.meterIndicator.transform = CGAffineTransformMakeRotation(2);
        self.meterIndicator.layer.transform = CATransform3DMakeRotation(radian, 0, 0, 1);
    }];
    
}

//- (void)minimumAndMaximum:(NSInteger)number {
//
//    self.minimumDecibelLabel.text = [NSString stringWithFormat:@"%ld",number];
//    self.maximumDecibelLabel.text = [NSString stringWithFormat:@"%ld",number];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [self.locationManager stopUpdatingLocation];
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    
//    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
//        for (CLPlacemark * placemark in placemarks) {
//
//            NSDictionary *address = [placemark addressDictionary];
//
//            //  Country(国家)  State(省)  City（市）
//            NSLog(@"#####%@",address);
//
//            NSLog(@"%@", [address objectForKey:@"City"]);
//
//            NSLog(@"%@", [address objectForKey:@"Country"]);
//
//            NSArray *arrar = [address objectForKey:@"FormattedAddressLines"];
//            NSLog(@"%@", arrar.lastObject);
//            NSLog(@"%@", [address objectForKey:@"Name"]);
//            NSLog(@"%@", [address objectForKey:@"Street"]);
//            NSLog(@"%@", [address objectForKey:@"SubLocality"]);
//            NSLog(@"%@", [address objectForKey:@"SubThoroughfare"]);
//            NSLog(@"%@", [address objectForKey:@"Thoroughfare"]);
//
//
//        }
        
        CLPlacemark *placemark = [placemarks firstObject];
//        NSDictionary *address = [placemark addressDictionary];
//        NSString *subLocality = [address objectForKey:@"SubLocality"];
//        NSString *street = [address objectForKey:@"Street"];
        self.LocationLabel.text = [NSString stringWithFormat:@"%@%@",placemark.subLocality,placemark.name];
        if ([self.LocationLabel.text isEqualToString:@"(null)(null)"]) {
            self.LocationLabel.text = @"知らない";
        }
        
    }];
    
  
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if ([error code] == kCLErrorDenied){
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

#pragma mark -------------------------- lazy load ----------------------------------------

- (NSManagedObjectContext *)context {
    if (!_context) {
        // 创建上下文对象，并发队列设置为主队列
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 创建托管对象模型，并使用Company.momd路径当做初始化参数
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"CFB" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
        // 创建持久化存储调度器
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"History"];
        NSLog(@"数据库/n%@",dataPath);
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
        // 上下文对象设置属性为持久化存储器
        _context.persistentStoreCoordinator = coordinator;
        
        
    }
    return _context;
}

@end
