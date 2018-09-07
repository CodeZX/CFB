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

#import "History+CoreDataClass.h"

@interface CFBHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic,strong) CFBHistoryHeadBar *headBar;

@property (nonatomic,strong) NSManagedObjectContext *context;
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
    
//    self.historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"historys"];
    
    self.historyArray = [[NSMutableArray alloc]init];
    
    
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *employees = [self.context executeFetchRequest:request error:&error];
    
    [employees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        History *history = (History *)obj;
         NSLog(@"Employee Name : %@, Height : %@, Brithday : %@ %@",history.time,history.max,history.min,history.location);
        [self.historyArray addObject:history];
    }];
   
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
    
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
        make.top.equalTo(weakSelf.view).offset(iPhoneX?84:64);
        make.height.equalTo(44);
        make.left.right.equalTo(weakSelf.view);
    }];
    
    
}

- (void)delete:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"レコードを削除してもよろしいですか？" message:@"履歴を削除した後、データを回復することはできません！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"削除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"historys"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [self deleteAllHistorys];
        [self getHistory];
        [self.tableView reloadData];
    }];
    [alert addAction:action];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)deleteAllHistorys {
    
    // 建立获取数据的请求对象，指明对Employee实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"lxz"];
//    request.predicate = predicate;
    // 执行获取操作，找到要删除的对象
    NSError *error = nil;
    NSArray *employees = [self.context executeFetchRequest:request error:&error];
    // 遍历符合删除要求的对象数组，执行删除操作
//    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.context deleteObject:obj];
//    }];
    [employees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context deleteObject:obj];
    }];
    // 保存上下文
    if (self.context.hasChanges) {
        [self.context save:nil];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }
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
