//
//  PictureViewController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "PictureViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "PictureTableViewCell.h"
#import "TTPicture.h"
#import "PictureCommentViewController.h"
#import "TTDataTool.h"
#import "TTPictureFetchDataParameter.h"
#import "TTConst.h"
#import "TTJudgeNetworking.h"

@interface PictureViewController ()<PictureTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *maxtime;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, copy) NSString *currentSkinModel;

@end
static NSString * const PictureCell = @"PictureCell";

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([TTJudgeNetworking judge]==NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        return;
    }
    [self setupBasic];
    [self setupTableView];
    [self setupMJRefreshHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
    [self updateSkinModel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBar.alpha = 1;
    
}

-(void)updateSkinModel {
    self.currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {
        self.tableView.backgroundColor = [UIColor blackColor];
    } else {//日间模式
        self.tableView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    [self.tableView reloadData];
}

- (void)setupBasic {
    self.currentPage = 0;
}

- (void)setupTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:PictureCell];
}

- (void)setupMJRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
}


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pictureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PictureCell];
    if ([self.currentSkinModel isEqualToString:DaySkinModelValue]) {//日间模式
        [cell updateToDaySkinMode];
    } else {
        [cell updateToNightSkinMode];
    }
    cell.picture = self.pictureArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTPicture *picture = self.pictureArray[indexPath.row];
    return picture.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureCommentViewController *vc = [[PictureCommentViewController alloc] init];
    vc.picture = self.pictureArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickMoreButton:(TTPicture *)picture {
    UIAlertController *controller =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

-(NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y>0) {
        self.navigationController.navigationBar.alpha = 0;
    } else {
        CGFloat yValue = - self.tableView.contentOffset.y;//纵向的差距
        CGFloat alphValue = yValue/self.tableView.contentInset.top;
        self.navigationController.navigationBar.alpha =alphValue;
    }
}

@end
