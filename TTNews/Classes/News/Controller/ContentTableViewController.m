//
//  ContentTableViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/26.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ContentTableViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"
#import "NoPictureNewsTableViewCell.h"
#import "TTNormalNews.h"
#import "TTHeaderNews.h"
#import "DetailViewController.h"
#import "ShowMultiPictureViewController.h"
#import "TTNormalNewsFetchDataParameter.h"
#import "TTDataTool.h"
#import "TTConst.h"
#import "UIImageView+Extension.h"
#import "TTJudgeNetworking.h"

@interface ContentTableViewController ()

@property (nonatomic, strong) NSMutableArray *headerNewsArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *normalNewsArray;
@property (nonatomic, weak) UIScrollView *headerScrollView;
@property (nonatomic, weak) UILabel *headerLabel;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentHeaderIndex;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *middleImageView;
@property (nonatomic, weak) UIImageView *rightImageView;
@property (nonatomic, copy) NSString *currentSkinModel;

@end

static NSString * const singlePictureCell = @"SinglePictureCell";
static NSString * const multiPictureCell = @"MultiPictureCell";
static NSString * const noPictureCell = @"NoPictureCell";
static NSString * const apikey = @"8b72ce2839d6eea0869b4c2c60d2a449";

@implementation ContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([TTJudgeNetworking judge]==NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        return;
    }
    [self setupBasic];
    [self setupRefresh];
    [self setupHeader];
    [self addTimer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
    [self updateSkinModel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeTimer];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateSkinModel {
    self.currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {        self.tableView.backgroundColor = [UIColor blackColor];
        self.headerLabel.textColor = [UIColor lightGrayColor];
    } else {//日间模式
        self.tableView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.headerLabel.textColor = [UIColor whiteColor];
    }
    [self.tableView reloadData];
}

-(void)setupHeader {
    CGFloat headerLabelHeight = 30;
    CGFloat margin = 10;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);

    UIScrollView *headerScrollView = [[UIScrollView alloc] init];
    self.headerScrollView = headerScrollView;
    headerScrollView.showsHorizontalScrollIndicator = NO;
    headerScrollView.showsVerticalScrollIndicator = NO;
    headerScrollView.frame = headerView.frame;
    [headerView addSubview:headerScrollView];
    headerScrollView.contentSize = CGSizeMake(headerScrollView.frame.size.width*3, 0);
    headerScrollView.contentOffset = CGPointMake(headerScrollView.frame.size.width, 0);
    headerScrollView.pagingEnabled = YES;
    headerScrollView.delegate = self;
    
    for (NSInteger i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (i==0) {
            self.leftImageView = imageView;
        } else if (i==1) {
            self.middleImageView = imageView;
        } else if (i==2) {
            self.rightImageView = imageView;
        }
        imageView.frame = CGRectMake(i*headerScrollView.frame.size.width, 0, headerScrollView.frame.size.width, headerScrollView.frame.size.height);
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderImageView:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:recognizer];
        [headerScrollView addSubview:imageView];
    }

    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, headerView.frame.size.height - headerLabelHeight, headerView.frame.size.width, headerLabelHeight);
    view.alpha = 0.8;
    view.backgroundColor =[UIColor darkGrayColor];
    [headerView addSubview:view];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 5;
    CGFloat pageControlWidth = [pageControl sizeForNumberOfPages:pageControl.numberOfPages].width;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];

    self.pageControl = pageControl;
    pageControl.frame = CGRectMake(headerView.frame.size.width - pageControlWidth-0.5*margin, 0, pageControlWidth, headerLabelHeight);
    pageControl.currentPage = 0;
    [view addSubview:pageControl];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    self.headerLabel = headerLabel;
    headerLabel.frame = CGRectMake(0, 0, headerView.frame.size.width - pageControlWidth-1.5*margin, headerLabelHeight);
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor darkGrayColor];
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:headerLabel];
    
    headerView.hidden = YES;
    self.tableView.tableHeaderView = headerView;
}

-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}

-(void)setupBasic {
    self.currentHeaderIndex = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:singlePictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MultiPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:multiPictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoPictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:noPictureCell];

}

- (void)loadNewData {
    [SVProgressHUD show];
    [self fetchNewHeaderNews];
    [self fetchNewNormalNews];
}

-(void)fetchNewHeaderNews {
    [self removeTimer];
    [TTDataTool TTHeaderNewsFromServerOrCacheWithMaxTTHeaderNews:self.headerNewsArray.lastObject success:^(NSMutableArray *array) {
            self.headerNewsArray = array;
            self.tableView.tableHeaderView.hidden = NO;
            [SVProgressHUD dismiss];
            [self updateHeaderView];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"加载失败！"];
            [self.tableView.mj_header endRefreshing];
            [self removeTimer];
            NSLog(@"%@fetchHeaderNews%@",self, error);
    }];
  
    [self addTimer];
}

-(void)fetchNewNormalNews {
    TTNormalNews *news = self.normalNewsArray.firstObject;
    TTNormalNewsFetchDataParameter *parameters = [[TTNormalNewsFetchDataParameter alloc] init];
    parameters.channelId = self.channelId;
    parameters.channelName = self.channelName;
    parameters.title = @"，";
    parameters.page = 1;
    parameters.recentTime = news.createdtime;
    [TTDataTool TTNormalNewsWithParameters:parameters success:^(NSMutableArray *array) {
        self.normalNewsArray = array;
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];

}

-(void)loadMoreData {
    [SVProgressHUD show];
    TTNormalNews *news = self.normalNewsArray.lastObject;
    if (self.currentPage >= news.allPages) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD showErrorWithStatus:@"全部加载完毕!"];
        return;
    }
    NSInteger currenpage = self.currentPage +1;
    TTNormalNewsFetchDataParameter *parameters = [[TTNormalNewsFetchDataParameter alloc] init];
    parameters.channelId = self.channelId;
    parameters.channelName = self.channelName;
    parameters.title = @":";
    parameters.page = currenpage;
    parameters.remoteTime = news.createdtime;
    [TTDataTool TTNormalNewsWithParameters:parameters success:^(NSMutableArray *array) {
        [self.normalNewsArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        self.currentPage = currenpage;

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败！"];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
    
}



-(void)clickHeaderImageView:(id)sender {
    TTHeaderNews *news = self.headerNewsArray[self.currentHeaderIndex];
    [self pushToDetailViewControllerWithUrl:news.url];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.normalNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTNormalNews *news = self.normalNewsArray[indexPath.row];
    if (news.normalNewsType == NormalNewsTypeMultiPicture) {
        MultiPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
        cell.title = news.title;
        cell.imageUrls = news.imageurls;
        if ([self.currentSkinModel isEqualToString:DaySkinModelValue]) {//日间模式
            [cell updateToDaySkinMode];
        } else {
            [cell updateToNightSkinMode];
        }
        return cell;
    } else if (news.normalNewsType == NormalNewsTypeSigalPicture) {
        SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
        cell.contentTittle = news.title;
        cell.desc = news.desc;
        NSDictionary *dict = news.imageurls.firstObject;
        if (dict) {
            cell.imageUrl = dict[@"url"];
        }
        if ([self.currentSkinModel isEqualToString:DaySkinModelValue]) {//日间模式
            [cell updateToDaySkinMode];
        } else {
            [cell updateToNightSkinMode];
        }
        return cell;
    } else {
        NoPictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noPictureCell];
        cell.titleText = news.title;
        cell.contentText = news.desc;
        if ([self.currentSkinModel isEqualToString:DaySkinModelValue]) {//日间模式
            [cell updateToDaySkinMode];
        } else {
            [cell updateToNightSkinMode];
        }
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTNormalNews *news = self.normalNewsArray[indexPath.row];
    return news.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTNormalNews *news = self.normalNewsArray[indexPath.row];
    if (news.normalNewsType == NormalNewsTypeMultiPicture) {
        ShowMultiPictureViewController *viewController = [[ShowMultiPictureViewController alloc] init];
        viewController.imageUrls = news.imageurls;
        NSString *text = news.desc;
        if (text == nil || [text isEqualToString:@""]) {
            text = news.title;
        }
        viewController.text = text;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self pushToDetailViewControllerWithUrl:news.link];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.headerScrollView) {//headerScrollView
        if (self.headerNewsArray.count==0||self.headerNewsArray==nil) return;
        
        if (scrollView.contentOffset.x>=scrollView.frame.size.width) {//向右滚动
            self.currentHeaderIndex = (self.currentHeaderIndex + 1)%self.headerNewsArray.count;
        } else {//向左滚动
            self.currentHeaderIndex = (self.currentHeaderIndex - 1 + self.headerNewsArray.count)%self.headerNewsArray.count;
        }
        self.pageControl.currentPage = self.currentHeaderIndex;

        TTHeaderNews *middleNews = self.headerNewsArray[self.currentHeaderIndex];
        [self.middleImageView TT_setImageWithURL:[NSURL URLWithString:middleNews.image_url]];
        self.headerLabel.text = [NSString stringWithFormat:@"   %@", middleNews.title];
        
        NSInteger leftIndex = (self.currentHeaderIndex - 1 + self.headerNewsArray.count)%self.headerNewsArray.count;//防止减1减成负数，所以加了一个self.headerNewsArray.count
        TTHeaderNews *leftNews = self.headerNewsArray[leftIndex];
        [self.leftImageView TT_setImageWithURL:[NSURL URLWithString:leftNews.image_url]];
        
        NSInteger rightIndex = (self.currentHeaderIndex + 1)%self.headerNewsArray.count;
        TTHeaderNews *rightNews = self.headerNewsArray[rightIndex];
        [self.rightImageView TT_setImageWithURL:[NSURL URLWithString:rightNews.image_url]];
        [self.headerScrollView setContentOffset:CGPointMake(self.headerScrollView.frame.size.width, 0)];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self addTimer];
}

-(void)pushToDetailViewControllerWithUrl:(NSString *)url {
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.url = url;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)updateHeaderView {
    if (self.headerNewsArray.count==0) return;
    self.currentHeaderIndex = 0;
    TTHeaderNews *middleNews = self.headerNewsArray[self.currentHeaderIndex];
    [self.middleImageView TT_setImageWithURL:[NSURL URLWithString:middleNews.image_url]];
    self.headerLabel.text = [NSString stringWithFormat:@"   %@", middleNews.title];
    
    NSInteger leftIndex = (self.currentHeaderIndex - 1 + self.headerNewsArray.count)%self.headerNewsArray.count;//防止减1减成负数，所以加了一个self.headerNewsArray.count
    TTHeaderNews *leftNews = self.headerNewsArray[leftIndex];
    [self.leftImageView TT_setImageWithURL:[NSURL URLWithString:leftNews.image_url]];
    
    NSInteger rightIndex = (self.currentHeaderIndex + 1)%self.headerNewsArray.count;
    TTHeaderNews *rightNews = self.headerNewsArray[rightIndex];
    [self.rightImageView TT_setImageWithURL:[NSURL URLWithString:rightNews.image_url]];
    self.pageControl.currentPage=0;
    [self.headerScrollView setContentOffset:CGPointMake(self.headerScrollView.frame.size.width, 0)];
    self.pageControl.numberOfPages = self.headerNewsArray.count;
    [self.tableView reloadData];
}



-(NSMutableArray *)normalNewsArray {
    if (!_normalNewsArray) {
        _normalNewsArray = [NSMutableArray array];
    }
    return _normalNewsArray;
}


-(NSMutableArray *)headerNewsArray {
    if (!_headerNewsArray) {
        _headerNewsArray = [NSMutableArray array];
    }
    return _headerNewsArray;
}

- (void)addTimer {
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

- (void)removeTimer{
    [self.timer invalidate];
}

- (void)nextNews {
    [UIView animateWithDuration:0.25 animations:^{
        [self.headerScrollView setContentOffset:CGPointMake(self.headerScrollView.contentOffset.x+[UIScreen mainScreen].bounds.size.width, 0)];
        [self scrollViewDidEndDecelerating:self.headerScrollView];
    }];
}

@end
