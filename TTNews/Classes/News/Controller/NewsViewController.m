//
//  NewsViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NewsViewController.h"
#import <POP.h>
#import <SVProgressHUD.h>
#import "ContentTableViewController.h"
#import "ChannelCollectionViewCell.h"
#import "TTJudgeNetworking.h"
#import "TTConst.h"
#import "TTTopChannelContianerView.h"

@interface NewsViewController()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate, ChannelCollectionViewCellDelegate,TTTopChannelContianerViewDelegate>

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, strong) NSMutableArray *remainChannelsArray;
@property (nonatomic, strong) NSMutableArray *allChannelsArray;
@property (nonatomic, strong) NSMutableDictionary *channelsUrlDictionary;
@property (nonatomic, weak) TTTopChannelContianerView *topContianerView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *currentSkinModel;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation NewsViewController

-(void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTopContianerView];
    [self setupChildController];
    [self setupContentScrollView];
    [self setupCollectionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
    [self updateSkinModel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateSkinModel {
    self.currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.topContianerView.backgroundColor = [UIColor colorWithRed:34/255.0 green:30/255.0 blue:33/255.0 alpha:1.0];
        self.topContianerView.scrollView.backgroundColor = [UIColor colorWithRed:34/255.0 green:30/255.0 blue:33/255.0 alpha:1.0];
        for (UIView *view in self.topContianerView.scrollView.subviews) {
            if ([view isKindOfClass:[UIControl class]]) {//是按钮
                UIButton *button = (UIButton *)view;
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            }
        }
    } else {//日间模式
        self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.topContianerView.backgroundColor = [UIColor whiteColor];
        self.topContianerView.scrollView.backgroundColor = [UIColor whiteColor];
        for (UIView *view in self.topContianerView.scrollView.subviews) {
            if ([view isKindOfClass:[UIControl class]]) {//是按钮
                UIButton *button = (UIButton *)view;
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }

}

-(void)setupChildController {
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray[i];
        viewController.channelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];
    }
    
}

- (void)setupTopContianerView{
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    TTTopChannelContianerView *topContianerView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30)];
    topContianerView.channelNameArray = self.currentChannelsArray;
    topContianerView.delegate = self;
    self.topContianerView  = topContianerView;
    self.topContianerView.scrollView.delegate = self;
    [self.view addSubview:topContianerView];
}

- (void)setupContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];
}

-(void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 35);//头部
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alpha = 0.98;
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:collectionCellID];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID];

}

-(void)showChannelsEditCollectionView:(BOOL)show {
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kDeviceHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + self.topContianerView.scrollView.frame.size.height;
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.springBounciness = 5;
    animation.springSpeed = 5;
    if (show == YES) {//显示频道编辑View
        [UIView animateWithDuration:0.25 animations:^{
            self.topContianerView.addButton.transform = CGAffineTransformRotate(self.topContianerView.addButton.transform, -M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, 0)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, kDeviceHeight - top)];
        self.tabBarController.tabBar.hidden = YES;
        [self.topContianerView didShowEditChannelView:YES];
    } else {//隐藏频道编辑View
        [UIView animateWithDuration:0.25 animations:^{
            self.topContianerView.addButton.transform = CGAffineTransformRotate(self.topContianerView.addButton.transform, M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, kDeviceHeight - top)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, 0)];
        self.tabBarController.tabBar.hidden = NO;
        [self.topContianerView didShowEditChannelView:NO];
        [self startOrStopShakingCellsWithValue:NO];
    }
    [self.collectionView pop_addAnimation:animation forKey:nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.currentChannelsArray.count;
    } else {
        return self.remainChannelsArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.channelName = self.currentChannelsArray[indexPath.row];
        cell.theIndexPath = indexPath;
    } else {
        cell.channelName = self.remainChannelsArray[indexPath.row];

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//跳转到相应的频道
        [self.topContianerView selectChannelButtonWithIndex:indexPath.row];
        [self showChannelsEditCollectionView:NO];
    }else {//新增自控制器
        [self.currentChannelsArray addObject:self.remainChannelsArray[indexPath.row]];
        [self.remainChannelsArray removeObjectAtIndex:indexPath.row];
        [self storeCurrentChannelsArray];
        
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray.lastObject;
        viewController.channelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];
        
        //新增频道
        [self.topContianerView addAChannelButtonWithChannelName:self.currentChannelsArray.lastObject];
        
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
        [self.collectionView reloadData];
    }

    
}

- (void)tapCollectionView {
    [self startOrStopShakingCellsWithValue:NO];
    self.collectionView.gestureRecognizers = nil;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 20, headerView.frame.size.height);
    if (indexPath.section == 0) {
        label.text = @"已添加栏目 (点击跳转，长按删除)";
    }else if (indexPath.section == 1) {
        label.text = @"可添加栏目 (点击添加)";
    }
    [headerView.subviews.firstObject removeFromSuperview];
    [headerView addSubview:label];
    
    return headerView;
}

- (void)wantToDeleteCell {
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (tapCollectionView)]];
    [self startOrStopShakingCellsWithValue:YES];
}

- (void)deleteTheCellAtIndexPath:(NSIndexPath *)indexPath {
    [self startOrStopShakingCellsWithValue:NO];
    NSInteger index = indexPath.row;
    [self.remainChannelsArray addObject:self.currentChannelsArray[index]];
    [self.currentChannelsArray removeObjectAtIndex:index];
    [self storeCurrentChannelsArray];
    [self.childViewControllers[index] removeFromParentViewController];
    [self.topContianerView deleteChannelButtonWithIndex:index];
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    [self.collectionView reloadData];
    [self startOrStopShakingCellsWithValue:YES];
    
}

- (void)startOrStopShakingCellsWithValue:(BOOL)value {
    for (NSInteger i = 0; i < self.currentChannelsArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ChannelCollectionViewCell *cell = (ChannelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (value == YES) {
            cell.deleteButton.hidden = NO;
            [cell startShake];
        } else {
            cell.deleteButton.hidden = YES;
            [cell stopShake];
        }
    }
}

#pragma mark TTTopChannelContianerViewDelegate 点击加号按钮，展示或隐藏添加频道页面
- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button {
    if (button.selected == NO) {//点击状态正常的加号buuton，显示编辑频道View
        [self showChannelsEditCollectionView:YES];
    } else {//点击状态为已经被选中的加号buuton，显示编辑频道View
        [self showChannelsEditCollectionView:NO];

    }
}


#pragma mark TTTopChannelContianerViewDelegate 选择了某个频道，更新scrollView的contenOffset
- (void)chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startOrStopShakingCellsWithValue:NO];
}

-(void)storeCurrentChannelsArray {
    [[NSUserDefaults standardUserDefaults] setObject:self.currentChannelsArray forKey:@"currentChannelsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        _currentChannelsArray = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"currentChannelsArray"];
        [_currentChannelsArray addObjectsFromArray:array];
        if (_currentChannelsArray.count == 0) {
            [_currentChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车"]];
            [self storeCurrentChannelsArray];
        }
    }
    return _currentChannelsArray;
}

-(NSMutableArray *)remainChannelsArray {
    if (!_remainChannelsArray) {
        _remainChannelsArray = [NSMutableArray array];
        [_remainChannelsArray addObjectsFromArray:self.allChannelsArray];
        [_remainChannelsArray removeObjectsInArray:self.currentChannelsArray];
    }
    return _remainChannelsArray;
}

-(NSMutableArray *)allChannelsArray {
    if (!_allChannelsArray) {
        _allChannelsArray = [NSMutableArray array];
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"allChannelsArray"];
        [_allChannelsArray addObjectsFromArray:tempArray];
        if (_allChannelsArray.count == 0) {
            [_allChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车", @"军事", @"理财", @"经济", @"房产", @"国际足球", @"国内足球", @"综合体育", @"电影", @"电视", @"游戏", @"教育", @"美容", @"情感",@"养生", @"数码", @"电脑", @"科普", @"社会", @"台湾", @"港澳"]];
            [[NSUserDefaults standardUserDefaults] setObject:_allChannelsArray forKey:@"allChannelsArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    return _allChannelsArray;
}

-(NSMutableDictionary *)channelsUrlDictionary {
    if (!_channelsUrlDictionary) {
        _channelsUrlDictionary = [NSMutableDictionary dictionary];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"channelsUrlDictionary"];
        [_channelsUrlDictionary addEntriesFromDictionary:dict];
        if (_channelsUrlDictionary.count == 0) {
            NSDictionary *tempDictionary = @{
              @"国内": @"5572a109b3cdc86cf39001db",
              @"国际": @"5572a109b3cdc86cf39001de",
              @"娱乐": @"5572a10ab3cdc86cf39001eb",
              @"互联网": @"5572a109b3cdc86cf39001e3",
              @"体育": @"5572a109b3cdc86cf39001e6",
              @"财经": @"5572a109b3cdc86cf39001e0",
              @"科技": @"5572a10ab3cdc86cf39001f4",
              @"汽车": @"5572a109b3cdc86cf39001e5",
              @"军事": @"5572a109b3cdc86cf39001df",
              @"理财": @"5572a109b3cdc86cf39001e1",
              @"经济": @"5572a109b3cdc86cf39001e2",
              @"房产": @"5572a109b3cdc86cf39001e4",
              @"国际足球": @"5572a10ab3cdc86cf39001e7",
              @"国内足球": @"5572a10ab3cdc86cf39001e8",
              @"综合体育": @"5572a10ab3cdc86cf39001ea",
              @"电影": @"5572a10ab3cdc86cf39001ec",
              @"电视": @"5572a10ab3cdc86cf39001ed",
              @"游戏": @"5572a10ab3cdc86cf39001ee",
              @"教育": @"5572a10ab3cdc86cf39001ef",
              @"美容": @"5572a10ab3cdc86cf39001f1",
              @"情感": @"5572a10ab3cdc86cf39001f2",
              @"养生": @"5572a10ab3cdc86cf39001f3",
              @"数码": @"5572a10bb3cdc86cf39001f5",
              @"电脑": @"5572a10bb3cdc86cf39001f6",
              @"科普": @"5572a10bb3cdc86cf39001f7",
              @"社会": @"5572a10bb3cdc86cf39001f8",
              @"台湾": @"5572a109b3cdc86cf39001dc",
              @"港澳": @"5572a109b3cdc86cf39001dd"
                                          };
            [_channelsUrlDictionary addEntriesFromDictionary:tempDictionary];
            [[NSUserDefaults standardUserDefaults] setObject:_channelsUrlDictionary forKey:@"channelsUrlDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _channelsUrlDictionary;
}

@end

