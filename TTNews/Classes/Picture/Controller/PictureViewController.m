//
//  PictureViewController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "PictureViewController.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import "PictureTableViewCell.h"
#import "TTPicture.h"
#import "PictureCommentViewController.h"
#import "TTDataTool.h"
#import "TTPictureFetchDataParameter.h"
#import "TTConst.h"
#import "TTJudgeNetworking.h"
#import <DKNightVersion.h>

@interface PictureViewController ()<PictureTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *maxtime;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, copy) NSString *currentSkinModel;

@end
static NSString * const PictureCell = @"PictureCell";

@implementation PictureViewController

#pragma mark 懒加载
-(NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupTableView];
    [self setupMJRefreshHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.navigationController.navigationBar.alpha = 1;

}



#pragma mark 基本设置
- (void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);


    self.currentPage = 0;
}

#pragma mark 初始化tableview
- (void)setupTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:PictureCell];
}

#pragma mark --初始化刷新控件
- (void)setupMJRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
}

#pragma mark --下拉刷新数据
- (void)LoadNewData {
    TTPictureFetchDataParameter *params = [[TTPictureFetchDataParameter alloc] init];
    TTPicture *firstPicture= self.pictureArray.firstObject;
    params.recentTime = firstPicture.created_at;
    params.page = 0;
    params.maxtime = nil;
    [TTDataTool pictureWithParameters:params success:^(NSArray *array, NSString *maxtime){
        self.maxtime = maxtime;
        self.pictureArray = [array mutableCopy];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@%@",self,error);
    }];
    
}

#pragma mark --上拉加载更多数据
- (void)LoadMoreData {
    TTPictureFetchDataParameter *params= [[TTPictureFetchDataParameter alloc] init];
    TTPicture *lastPicture = self.pictureArray.lastObject;
    self.currentPage = self.currentPage+1;
    params.page = self.currentPage;
    params.remoteTime = lastPicture.created_at;
    params.maxtime = self.maxtime;
    [TTDataTool pictureWithParameters:params success:^(NSArray *array, NSString *maxtime){
        self.maxtime = maxtime;
        [self.pictureArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        self.currentPage = self.currentPage-1;
        NSLog(@"%@%@",self,error);
    }];
}

#pragma mark - Table view data source

#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pictureArray.count;
}


#pragma mark -UITableViewDataSource 返回indexPath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PictureCell];
    cell.picture = self.pictureArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTPicture *picture = self.pictureArray[indexPath.row];
    return picture.cellHeight;
}

#pragma mark -UITableViewDelegate 点击了某个cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushToPictureCommentViewControllerWithIndexPath:indexPath];
}

#pragma mark 点击某个Cell或点击评论按钮跳转到评论页面
-(void)pushToPictureCommentViewControllerWithIndexPath:(NSIndexPath *)indexPath {
    PictureCommentViewController *viewController = [[PictureCommentViewController alloc] init];
    viewController.picture = self.pictureArray[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark PictureTableViewCell代理 点击更多按钮
-(void)clickMoreButton:(TTPicture *)picture {
    UIAlertController *controller =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark PictureTableViewCell代理 点击评论按钮
-(void)clickCommentButton:(NSIndexPath *)indexPath {
    [self pushToPictureCommentViewControllerWithIndexPath:indexPath];
}

#pragma mark --UIScrollViewDelegate scrollView滑动了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.tableView.contentOffset.y>0) {
//        self.navigationController.navigationBar.alpha = 0;
//    } else {
//        CGFloat yValue = - self.tableView.contentOffset.y;//纵向的差距
//        CGFloat alphValue = yValue/self.tableView.contentInset.top;
//        self.navigationController.navigationBar.alpha =alphValue;
//    }
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
    
}

@end
