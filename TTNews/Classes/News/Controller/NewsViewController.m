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
#import "ChannelsSectionHeaderView.h"

@interface NewsViewController()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate, ChannelCollectionViewCellDelegate,TTTopChannelContianerViewDelegate>

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, strong) NSMutableArray *remainChannelsArray;
@property (nonatomic, strong) NSMutableArray *allChannelsArray;
@property (nonatomic, strong) NSMutableDictionary *channelsUrlDictionary;
@property (nonatomic, weak) TTTopChannelContianerView *topContianerView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, assign) BOOL isCellShouldShake;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation NewsViewController

-(void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isCellShouldShake = NO;
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

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray[i];
        viewController.channelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];
    }
}

#pragma mark --private Method--初始化上方的新闻频道选择的View
- (void)setupTopContianerView{
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    TTTopChannelContianerView *topContianerView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30)];
    topContianerView.channelNameArray = self.currentChannelsArray;
    topContianerView.delegate = self;
    self.topContianerView  = topContianerView;
    self.topContianerView.scrollView.delegate = self;
    [self.view addSubview:topContianerView];
}

#pragma mark --private Method--初始化相信新闻内容的scrollView
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

#pragma mark --private Method--初始化点击加号按钮弹出的新闻频道编辑的CollectionView
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
    [collectionView registerClass:[ChannelsSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID];
}

#pragma mark --UIScrollViewDelegate-- 重新设置了UIScrollView的contentOffset,并且animate=YES会调用这个方法，scrollViewDidEndDecelerating中也调用了这个方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
    }
}

#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView的cell是否能被选中
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView的组标题View
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ChannelsSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID forIndexPath:indexPath];
    if (indexPath.section == 0) {
            headerView.titleLabel.text = @"已添加栏目 (点击跳转，长按删除)";
        }else if (indexPath.section == 1) {
            headerView.titleLabel.text = @"可添加栏目 (点击添加)";
        }
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {
        [headerView updateToNightSkinMode];
    } else {
        [headerView updateToDaySkinMode];
    }
    return headerView;
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView的组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView的每一组对应的cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.currentChannelsArray.count;
    } else {
        return self.remainChannelsArray.count;
    }
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView每个indexpath对应的cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell stopShake];
    cell.deleteButton.hidden = YES;
    if (indexPath.section == 0) {
        cell.channelName = self.currentChannelsArray[indexPath.row];
        cell.theIndexPath = indexPath;
        if (self.isCellShouldShake == YES) {
            [cell startShake];
            cell.deleteButton.hidden = NO;
        }
    } else {
        cell.channelName = self.remainChannelsArray[indexPath.row];
    }
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {
        [cell updateToNightSkinMode];
    } else {
        [cell updateToDaySkinMode];
    }
    return cell;
}

#pragma mark --UICollectionViewDataSource-- 返回每个UICollectionViewCell发Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView每一组的外边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark --UICollectionViewDataSource-- 返回collectionView每个item之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark --UICollectionViewDelegate-- 点击了某个UICollectionViewCell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//点击的是第一组的cell，跳转到相应的新闻频道
        [self.topContianerView selectChannelButtonWithIndex:indexPath.row];
        [self shouldShowChannelsEditCollectionView:NO];
    }else {//点击的是第二组的cell，新增自控制器
        [self.currentChannelsArray addObject:self.remainChannelsArray[indexPath.row]];
        [self.remainChannelsArray removeObjectAtIndex:indexPath.row];
        [self updateCurrentChannelsArrayToDefaults];
        //新增自控制器
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray.lastObject;
        viewController.channelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];
        //新增新闻频道
        [self.topContianerView addAChannelButtonWithChannelName:self.currentChannelsArray.lastObject];
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
        [self.collectionView reloadData];
    }
}

#pragma mark --ChannelCollectionViewCellDelegate-- 长按第一组某个ChannelCollectionViewCell的回调方法
- (void)didLongPressAChannelCell {
    [self shouldStartShakingCellsWithValue:YES];
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (tapCollectionView)]];
}

#pragma mark --ChannelCollectionViewCellDelegate-- 点击第一组ChannelCollectionViewCell左上角的删除按钮的回调方法
- (void)deleteTheCellAtIndexPath:(NSIndexPath *)indexPath {
    [self shouldStartShakingCellsWithValue:NO];
    NSInteger index = indexPath.row;
    [self.remainChannelsArray addObject:self.currentChannelsArray[index]];
    [self.currentChannelsArray removeObjectAtIndex:index];
    [self updateCurrentChannelsArrayToDefaults];
    [self.childViewControllers[index] removeFromParentViewController];
    [self.topContianerView deleteChannelButtonWithIndex:index];
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    [self.collectionView reloadData];
    [self shouldStartShakingCellsWithValue:YES];
    
}

#pragma mark --TTTopChannelContianerViewDelegate--点击加号按钮，展示或隐藏编辑新闻频道CollectionView
- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button {
    if (button.selected == NO) {//点击状态正常的加号buuton，显示编辑频道CollectionView
        [self shouldShowChannelsEditCollectionView:YES];
    } else {//点击状态为已经被选中的加号buuton，显示编辑频道CollectionView
        [self shouldShowChannelsEditCollectionView:NO];
    }
}

#pragma mark --TTTopChannelContianerViewDelegate--选择了某个新闻频道，更新scrollView的contenOffset
- (void)chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}

#pragma mark --private Method--更新皮肤模式 接到模式切换的通知后会调用此方法
-(void)updateSkinModel {
    self.currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([self.currentSkinModel isEqualToString:NightSkinModelValue]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.collectionView.backgroundColor = [UIColor colorWithRed:34/255.0 green:30/255.0 blue:33/255.0 alpha:1.0];
        [self.topContianerView updateToNightSkinMode];
    } else {//日间模式
        self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.collectionView.backgroundColor  = [UIColor whiteColor];
        [self.topContianerView updateToDaySkinMode];
    }
    [self.collectionView reloadData];
}

#pragma mark --private Method--显示或隐藏点击加号按钮弹出的新闻频道编辑的CollectionView
-(void)shouldShowChannelsEditCollectionView:(BOOL)value {
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kDeviceHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + self.topContianerView.scrollView.frame.size.height;
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.springBounciness = 5;
    animation.springSpeed = 5;
    if (value == YES) {//显示新闻频道编辑View
        [UIView animateWithDuration:0.25 animations:^{
            self.topContianerView.addButton.transform = CGAffineTransformRotate(self.topContianerView.addButton.transform, -M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, 0)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, kDeviceHeight - top)];
        self.tabBarController.tabBar.hidden = YES;
        [self.topContianerView didShowEditChannelView:YES];
    } else {//隐藏新闻频道编辑View
        [UIView animateWithDuration:0.25 animations:^{
            self.topContianerView.addButton.transform = CGAffineTransformRotate(self.topContianerView.addButton.transform, M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, kDeviceHeight - top)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, top, kDeviceWidth, 0)];
        self.tabBarController.tabBar.hidden = NO;
        [self.topContianerView didShowEditChannelView:NO];
        [self shouldStartShakingCellsWithValue:NO];
    }
    [self.collectionView pop_addAnimation:animation forKey:nil];
}

#pragma mark --private Method--collectionView添加手势识别器后,轻点collectionView会调用的方法
- (void)tapCollectionView {
    [self shouldStartShakingCellsWithValue:NO];
    [self.collectionView removeGestureRecognizer:self.collectionView.gestureRecognizers.lastObject];
}

#pragma mark --private Method--是否应该开始抖动，如果Value为YES那么会开始抖动，Value为NO会停止抖动
- (void)shouldStartShakingCellsWithValue:(BOOL)value {
    self.isCellShouldShake= value;
    [self.collectionView reloadData];
}

#pragma mark --private Method--存储更新后的currentChannelsArray到偏好设置中
-(void)updateCurrentChannelsArrayToDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentChannelsArray forKey:@"currentChannelsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark --private Method--懒加载currentChannelsArray
-(NSMutableArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        _currentChannelsArray = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"currentChannelsArray"];
        [_currentChannelsArray addObjectsFromArray:array];
        if (_currentChannelsArray.count == 0) {
            [_currentChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车"]];
            [self updateCurrentChannelsArrayToDefaults];
        }
    }
    return _currentChannelsArray;
}

#pragma mark --懒加载--remainChannelsArray
-(NSMutableArray *)remainChannelsArray {
    if (!_remainChannelsArray) {
        _remainChannelsArray = [NSMutableArray array];
        [_remainChannelsArray addObjectsFromArray:self.allChannelsArray];
        [_remainChannelsArray removeObjectsInArray:self.currentChannelsArray];
    }
    return _remainChannelsArray;
}

#pragma mark --懒加载--allChannelsArray
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

#pragma mark --懒加载--channelsUrlDictionary
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

