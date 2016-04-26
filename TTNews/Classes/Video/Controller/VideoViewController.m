//
//  VideoViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "VideoViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "TTVideo.h"
#import "TTVideoFetchDataParameter.h"
#import <UIImageView+WebCache.h>
#import "VideoTableViewCell.h"
#import "VideoPlayView.h"
#import "FullViewController.h"
#import "VideoCommentViewController.h"
#import "TTDataTool.h"
#import "TTConst.h"
#import "TTJudgeNetworking.h"

@interface VideoViewController ()<VideoTableViewCellDelegate, VideoPlayViewDelegate>

@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *maxtime;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) FullViewController *fullVc;
@property (nonatomic, weak) VideoPlayView *playView;
@property (nonatomic, weak) VideoTableViewCell *currentSelectedCell;
@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, assign) BOOL isFullScreenPlaying;

@end

static NSString * const VideoCell = @"VideoCell";

@implementation VideoViewController

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
    if (self.isFullScreenPlaying == NO) {//将要呈现的画面不是全屏播放页面
        [self.playView resetPlayView];
    }
    self.navigationController.navigationBar.alpha = 1;
}

-(void)updateSkinModel {
    self.currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {//日间模式
        self.tableView.backgroundColor = [UIColor blackColor];
    } else {
        self.tableView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    [self.tableView reloadData];
}

-(void)setupBasic {
    self.currentPage = 0;
    self.isFullScreenPlaying = NO;
}

- (void)setupTableView {
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:VideoCell];
}

- (void)setupMJRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
}

- (void)LoadNewData {
    TTVideoFetchDataParameter *params = [[TTVideoFetchDataParameter alloc] init];
    TTVideo *firstVideo = self.videoArray.firstObject;
    params.recentTime = firstVideo.created_at;
    params.page = 0;
    params.maxtime = nil;
    [TTDataTool videoWithParameters:params success:^(NSArray *array, NSString *maxtime){
        self.maxtime = maxtime;
        self.videoArray = [array mutableCopy];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@LoadNewData%@",self,error);
    }];
    
}

- (void)LoadMoreData {
    TTVideoFetchDataParameter *parammeters = [[TTVideoFetchDataParameter alloc] init];
    TTVideo *lastVideo = self.videoArray.lastObject;
    self.currentPage = self.currentPage+1;
    parammeters.page = self.currentPage;
    parammeters.remoteTime = lastVideo.created_at;
    parammeters.maxtime = self.maxtime;
    [TTDataTool videoWithParameters:parammeters success:^(NSArray *array, NSString *maxtime){
        self.maxtime = maxtime;
        [self.videoArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        self.currentPage = self.currentPage-1;
        NSLog(@"%@LoadMoreData%@",self,error);
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
    cell.video = self.videoArray[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if ([self.currentSkinModel isEqualToString:DaySkinModelValue]) {//日间模式
        [cell updateToDaySkinMode];
    } else {
        [cell updateToNightSkinMode];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTVideo *video = self.videoArray[indexPath.row];
    return video.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCommentViewController *vc = [[VideoCommentViewController alloc] init];
    vc.video = self.videoArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickMoreButton:(TTVideo *)video {
    UIAlertController *controller =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        self.isFullScreenPlaying = YES;
        [self presentViewController:self.fullVc animated:YES completion:^{
            self.playView.frame = self.fullVc.view.bounds;
            [self.fullVc.view addSubview:self.playView];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:YES completion:^{
            self.playView.frame = self.currentSelectedCell.video.videoFrame;
            [self.currentSelectedCell addSubview:self.playView];
            self.isFullScreenPlaying = NO;

        }];
        
    }
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        self.fullVc = [[FullViewController alloc] init];
    }
    
    return _fullVc;
}

-(void)clickVideoButton:(NSIndexPath *)indexPath {
    [self.playView resetPlayView];

    VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.currentSelectedCell = cell;
    VideoPlayView *playView = [VideoPlayView videoPlayView];
    TTVideo *video = self.videoArray[indexPath.row];
    playView.frame = video.videoFrame;
    [cell addSubview:playView];
    cell.playView = playView;
    self.playView = playView;
    self.playView.delegate = self;
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:video.videouri]];
    self.playView.playerItem = item;
}

-(NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.playView.superview && self.isFullScreenPlaying == NO) {//点全屏和退出的时候，也会调用scrollViewDidScroll这个方法
        NSIndexPath *indePath = [self.tableView indexPathForCell:self.currentSelectedCell];
        if (![self.tableView.indexPathsForVisibleRows containsObject:indePath]) {//播放video的cell已离开屏幕
            [self.playView resetPlayView];
        }
    }
    if (self.tableView.contentOffset.y>0) {
        self.navigationController.navigationBar.alpha = 0;
    } else {
        CGFloat yValue = - self.tableView.contentOffset.y;//纵向的差距
        CGFloat alphValue = yValue/self.tableView.contentInset.top;
        self.navigationController.navigationBar.alpha =alphValue;
    }
    
}

@end
