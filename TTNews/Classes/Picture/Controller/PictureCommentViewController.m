//
//  PictureCommentViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//
#import "PictureCommentViewController.h"
#import "pictureTableViewCell.h"
#import "TTpicture.h"
#import <MJRefresh.h>
#import <SDImageCache.h>
#import "TTpictureComment.h"
#import <MJExtension.h>
#import "PictureCommentCell.h"
#import "UIBarButtonItem+Extension.h"
#import "TTConst.h"
#import "UIView+Extension.h"
#import <DKNightVersion.h>
#import "TTDataTool.h"
#import "TTNetworkManager.h"

static NSString * const PictureCommentCellID = @"PictureCommentCell";



@interface PictureCommentViewController () <UITableViewDelegate, UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContianerView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic, strong) TTPictureComment *saved_top_cmt;

/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;


@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, weak) PictureTableViewCell *headerPictureCell;

@end

@implementation PictureCommentViewController

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
    if (self.saved_top_cmt) {
        self.picture.top_cmt = self.saved_top_cmt;
        [self.picture setValue:@0 forKeyPath:@"cellHeight"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark 基本设置
- (void)setupBasic
{
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.bottomContianerView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.title = @"评论";
    // 内边距s
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 背景色
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCommentCell class]) bundle:nil] forCellReuseIdentifier:PictureCommentCellID];
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    if (self.picture.top_cmt) {
        self.saved_top_cmt = self.picture.top_cmt;
        self.picture.top_cmt = nil;
        self.picture.cellHeight = 0;
    }
    
    // 创建header
    UIView *header = [[UIView alloc] init];
    //     添加cell
    PictureTableViewCell *cell = [PictureTableViewCell cell];
    self.headerPictureCell = cell;
    cell.picture = self.picture;
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.picture.cellHeight);
    cell.contentView.frame = cell.bounds;
    
    // header的高度
    header.height =  self.picture.cellHeight+ cellMargin;
    [header addSubview:cell];
    
    // 设置header
    self.tableView.tableHeaderView = header;
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
    params[@"data_id"] = self.picture.ID;
    params[@"page"] = @(page);
    TTPictureComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
//    [TTDataTool PictureCommentsWithParameters:params success:^(NSDictionary *responseObject) {
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:params Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 最新评论
        NSArray *newComments = [TTPictureComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

#pragma mark 加载最新评论
- (void)loadNewComments
{
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.picture.ID;
    params[@"hot"] = @"1";
    
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:params Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        // 最热评论
        self.hotComments = [TTPictureComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [TTPictureComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码
        self.page = 1;
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 刷新数据
        [self.tableView reloadData];
        NSLog(@"%@",[NSThread currentThread]);
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
    } Failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
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

- (TTPictureComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark - <UITableViewDataSource>
#pragma mark -UITableViewDataSource 返回tableView的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

#pragma mark -UITableViewDataSource 返回某一组对应的cell个数
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

#pragma mark -UITableViewDataSource 返回indexPath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PictureCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:PictureCommentCellID];

    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

#pragma mark -UIScrollViewDelegate scrollView将要开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark -UITableViewDelegate 点击了tableView的某一行cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的cell
        PictureCommentCell *cell = (PictureCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
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
@end
