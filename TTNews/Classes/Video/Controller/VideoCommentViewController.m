//
//  VideoCommentViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "VideoCommentViewController.h"
#import "VideoTableViewCell.h"
#import "TTVideo.h"
#import <MJRefresh.h>
#import <SDImageCache.h>
#import "TTVideoComment.h"
#import <MJExtension.h>
#import "VideoCommentCell.h"
#import "UIBarButtonItem+Extension.h"
#import "TTConst.h"
#import "UIView+Extension.h"
#import "FullViewController.h"
#import <DKNightVersion.h>
#import "TTNetworkManager.h"

static NSString * const VideoCommentCellID = @"VideoCommentCell";

@interface VideoCommentViewController () <UITableViewDelegate, UITableViewDataSource,VideoTableViewCellDelegate,VideoPlayViewDelegate>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic, strong) TTVideoComment *saved_top_cmt;

/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;

/** 当前皮肤模式*/
@property (nonatomic, copy) NSString *currentSkinModel;

@property(nonatomic, weak) VideoTableViewCell *headerVideoCell;

@property (weak, nonatomic) IBOutlet UIView *bottomContianerView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (nonatomic, assign) NSInteger total;


@property (nonatomic, strong) FullViewController *fullVc;
@property (nonatomic, weak) VideoPlayView *playView;
@property (nonatomic, assign) BOOL isFullScreenPlaying;

@end

@implementation VideoCommentViewController

#pragma mark 懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupHeader];
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isFullScreenPlaying == NO) {//将要呈现的画面不是全屏播放页面
        [self.playView resetPlayView];
    }
    if (self.saved_top_cmt) {
        self.video.top_cmt = self.saved_top_cmt;
        [self.video setValue:@0 forKeyPath:@"cellHeight"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 基本设置
- (void)setupBasic
{
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.bottomContianerView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.title = @"评论";
    self.page = 1;
    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 背景色
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoCommentCell class]) bundle:nil] forCellReuseIdentifier:VideoCommentCellID];
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 内边距s
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, cellMargin, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark 初始化刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark 初始化TableView的headerView
- (void)setupHeader
{
    // 清空top_cmt
    if (self.video.top_cmt) {
        self.saved_top_cmt = self.video.top_cmt;
        self.video.top_cmt = nil;
        self.video.cellHeight = 0;
    }
    
    // 创建header
    UIView *header = [[UIView alloc] init];
    //     添加cell
    VideoTableViewCell *cell = [VideoTableViewCell cell];
    self.headerVideoCell = cell;
    cell.delegate = self;
    cell.video = self.video;
    cell.frame = CGRectMake(0, cellMargin, [UIScreen mainScreen].bounds.size.width, self.video.cellHeight);
    cell.contentView.frame = cell.bounds;
    
    // header的高度
    header.height =  self.video.cellHeight + cellMargin;
    [header addSubview:cell];
    
    // 设置header
    self.tableView.tableHeaderView = header;
}

#pragma mark 加载最新评论
- (void)loadNewComments
{
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.video.ID;
    params[@"hot"] = @"1";
    
//    [TTDataTool VideoCommentsWithParameters:params success:^(NSDictionary *responseObject) {
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:params Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 最热评论
        self.hotComments = [TTVideoComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [TTVideoComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码
        self.page = 1;
        
        // 刷新数据
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];

        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
     } Failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载更多评论
- (void)loadMoreComments
{
    
    // 页码
    NSInteger page = self.page + 1;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.video.ID;
    params[@"page"] = @(page);
    TTVideoComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
//    [TTDataTool VideoCommentsWithParameters:params success:^(NSDictionary *responseObject) {
        // 没有数据
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:params Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 最新评论
        NSArray *newComments = [TTVideoComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 页码
        self.page = page;
        
        // 刷新数据
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    } Failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark 接收到键盘frame将要变化的通知
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSapce.constant = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark 返回第section组的所有评论数组
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

#pragma mark 返回indexPath对应的模型数据
- (TTVideoComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark - <UITableViewDataSource>
#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

#pragma mark -UITableViewDataSource 返回tableView某一组对应的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    // 隐藏尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    // 非第0组
    return latestCount;
}

#pragma mark -UITableViewDataSource 返回tableView每一组section的HeaderView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 先从缓存池中找header
    UILabel *sectionHeaderLabel = [[UILabel alloc] init];
    sectionHeaderLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);

    // 设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        sectionHeaderLabel.text = hotCount ? @"   最热评论" : @"   最新评论";
    } else {
        sectionHeaderLabel.text = @"   最新评论";
    }
    
   
    sectionHeaderLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

    return sectionHeaderLabel;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell的高度
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCommentCellID];
    cell.comment = [self commentInIndexPath:indexPath];
   
    return cell;
}


#pragma mark -UITableViewDelegate 点击了TableView的某一行cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的cell
        VideoCommentCell *cell = (VideoCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        // 出现一个第一响应者
        [cell becomeFirstResponder];
        
        // 显示MenuController
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.frame.size.height * 0.5, cell.frame.size.width, cell.frame.size.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark -UIScrollViewDelegate scrollView将要开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - MenuItem处理
- (void)ding:(UIMenuController *)menu
{

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

#pragma mark VideoTableViewCell的代理方法
-(void)clickVideoButton:(NSIndexPath *)indexPath {
    [self.playView resetPlayView];
    VideoPlayView *playView = [VideoPlayView videoPlayView];
    playView.frame = self.video.videoFrame;
    [self.headerVideoCell addSubview:playView];
    self.headerVideoCell.playView = playView;
    self.playView = playView;
    self.playView.delegate = self;
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.video.videouri]];
    self.playView.playerItem = item;
}

#pragma mark 视频播放时窗口模式与全屏模式切换
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
            self.playView.frame = self.headerVideoCell.video.videoFrame;
            [self.headerVideoCell addSubview:self.playView];
            self.isFullScreenPlaying = NO;
            
        }];
        
    }
}

#pragma mark --UIScrollViewDelegate--scrollView滑动了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.playView.superview && self.isFullScreenPlaying == NO) {//点全屏和退出的
            [self.playView resetPlayView];
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

@end
