//
//  CFBSettingViewController.m
//  CFB
//
//  Created by 周鑫 on 2018/8/21.
//  Copyright © 2018年 ZX. All rights reserved.
//   设置

#import "CFBSettingViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface CFBSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation CFBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}


- (void)setupUI {
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1"]];
    self.title = @"設定";
    __weak typeof(self) weakSelf = self;
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.emptyDataSetSource = self;
//    tableView.emptyDataSetDelegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
}

#pragma mark -------------------------- UITableViewDelegate ----------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"評価";
    } else if(indexPath.row == 1) {
        
        cell.textLabel.text = @"私たちについて！";
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"com.zx.CFB"];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        
    }else if(indexPath.row == 1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hello！" message:@"私はもっと楽しいアプリをあなたに提供できることを願っています！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"1つのように" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
//        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:<#@"删除"#> style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        [alert addAction:action];
//        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
