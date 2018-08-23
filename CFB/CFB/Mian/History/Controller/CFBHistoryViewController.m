//
//  CFBHistoryViewController.m
//  CFB
//
//  Created by 周鑫 on 2018/8/21.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "CFBHistoryViewController.h"
#import "CFBHistoryTableViewCell.h"
#import "CFBHistoryHeadBar.h"

@interface CFBHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic,strong) CFBHistoryHeadBar *headBar;
@end

@implementation CFBHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHistory];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
//    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    [self getHistory];
    [self.tableView reloadData];
}

- (void)getHistory {
    
    self.historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"historys"];
    
}


- (void)setupUI {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1"]];
    self.title = @"歴史";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(delete:)];
    UIImage *rightImage = [[UIImage imageNamed:@"删 除-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(delete:)];
    __weak typeof(self) weakSelf = self;
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    self.headBar = [[[NSBundle mainBundle] loadNibNamed:@"CFBHistoryHeadBar" owner:nil options:nil] lastObject];
    [self.view addSubview:self.headBar];
    [self.headBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.height.equalTo(44);
        make.left.right.equalTo(weakSelf.view);
    }];
    
    
}

- (void)delete:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"レコードを削除してもよろしいですか？" message:@"履歴を削除した後、データを回復することはできません！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"削除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"historys"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getHistory];
        [self.tableView reloadData];
    }];
    [alert addAction:action];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark -------------------------- UITableViewDelegate ----------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CFBHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFBHistoryTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFBHistoryTableViewCell" owner:nil options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.history = self.historyArray[indexPath.row];
    return cell;
    
}

#pragma mark -------------------------- DZNEmptyDataSetDelegate ----------------------------------------
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [[NSAttributedString alloc]initWithString:@"レコードはありません！"];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
