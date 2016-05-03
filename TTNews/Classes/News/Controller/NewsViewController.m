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


@interface NewsViewController()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ChannelCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, strong) NSMutableArray *remainChannelsArray;
@property (nonatomic, strong) NSMutableArray *allChannelsArray;
@property (nonatomic, strong) NSMutableDictionary *channelsUrlDictionary;
@property (nonatomic, weak) UIView *topContianerView;
@property (nonatomic, weak) UIScrollView *topScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, assign) BOOL isAddChannelsViewShow;
@property (nonatomic, weak) UIView *collectionView;
@property (nonatomic, assign) CGRect collectionViewFrame;
@property (nonatomic, copy) NSString *currentSkinModel;

/** 标题数组*/
@property (nonatomic, strong) NSMutableArray * titlesArray;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";
static CGFloat titleLabelNorimalFont = 13;
static CGFloat titleLabelSelectedFont = 17;

@implementation NewsViewController

-(void)viewDidLoad {
    [self setupBasic];
    [self setupTopScrollView];
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
        self.topScrollView.backgroundColor = [UIColor colorWithRed:34/255.0 green:30/255.0 blue:33/255.0 alpha:1.0];
        self.addButton.backgroundColor = [UIColor colorWithRed:34/255.0 green:30/255.0 blue:33/255.0 alpha:1.0];
        for (UIView *view in self.topScrollView.subviews) {
            if ([view isKindOfClass:[UIControl class]]) {//是按钮
                UIButton *button = (UIButton *)view;
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            }
        }
    } else {//日间模式
        self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.topContianerView.backgroundColor = [UIColor whiteColor];
        self.topScrollView.backgroundColor = [UIColor whiteColor];
        self.addButton.backgroundColor = [UIColor whiteColor];
        for (UIView *view in self.topScrollView.subviews) {
            if ([view isKindOfClass:[UIControl class]]) {//是按钮
                UIButton *button = (UIButton *)view;
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }

}


-(void)setupBasic {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isAddChannelsViewShow = NO;
}

-(void)setupChildController {
    
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray[i];
        viewController.channelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];
    }
    
}

- (void)setupTopScrollView {
    
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    UIView *topContianerView = [[UIView alloc] init];
    self.topContianerView  = topContianerView;
    topContianerView.frame = CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30);
    topContianerView.alpha = 0.9;
    
    [self.view addSubview:topContianerView];
    
    UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    [addButton setImage:[UIImage imageNamed:@"home_header_add_slim"] forState:UIControlStateNormal];
    CGFloat addButtonWidth = topContianerView.frame.size.height;
    addButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - addButtonWidth, 0, addButtonWidth, addButtonWidth);
    [addButton addTarget:self action:@selector(showAddChannelsView) forControlEvents:UIControlEventTouchUpInside];
    [topContianerView addSubview:addButton];
    
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    self.topScrollView = topScrollView;

    topScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - addButtonWidth, topContianerView.frame.size.height);
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.showsVerticalScrollIndicator = NO;
    [topContianerView addSubview:topScrollView];
    

    CGFloat slideViewWidth = 10;
    UIImageView *slideView = [[UIImageView alloc] init];
    slideView.frame = CGRectMake(topScrollView.frame.size.width - slideViewWidth, 0, slideViewWidth, topContianerView.frame.size.height);
    slideView.alpha = 0.9;
    slideView.image = [UIImage imageNamed:@"slidetab_mask"];
    [topContianerView addSubview:slideView];
    

    UIView *indicatorView = [[UIView alloc] init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];
    [topScrollView addSubview:indicatorView];

    [self setupTopScrollViewButtons];

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
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kDeviceHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + self.topScrollView.frame.size.height;
    CGFloat bottom = self.tabBarController.tabBar.frame.size.height;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(kDeviceWidth, 35);//头部
    
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, 0, 0)collectionViewLayout:flowLayout];
    ZFView *collectionView = [[ZFView alloc] initWithFrame:CGRectMake(0, top, kDeviceWidth, kDeviceHeight) titlesArray:self.titlesArray];
    self.collectionViewFrame = CGRectMake(0, top, kDeviceWidth, kDeviceHeight - top - bottom);
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alpha = 0.95;
    [self.view addSubview:collectionView];
//    collectionView.dataSource = self;
//    collectionView.delegate = self;
//    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:collectionCellID];
//    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID];

    self.collectionView.hidden = YES;
}

-(void)buttonClick:(UIButton *)button {
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:titleLabelNorimalFont];
    self.selectButton.enabled = YES;
    self.selectButton = button;
    self.selectButton.enabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
    [button.titleLabel setFont:[UIFont systemFontOfSize:titleLabelSelectedFont]];
        [button layoutIfNeeded];
    self.indicatorView.frame = CGRectMake(button.frame.origin.x + button.titleLabel.frame.origin.x -5, self.topScrollView.frame.size.height - 2, button.titleLabel.frame.size.width + 10, 2);
    NSInteger index = [self.topScrollView.subviews indexOfObject:button] - 1;
    [self.contentScrollView setContentOffset:CGPointMake(index * self.contentScrollView.frame.size.width, 0) animated:YES];

    CGFloat contentOffsetX = button.center.x - 0.5*[UIScreen mainScreen].bounds.size.width;
        CGFloat maxContentOffsetX = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
    if (contentOffsetX > maxContentOffsetX) {
        contentOffsetX = maxContentOffsetX;
        }
    if (contentOffsetX<0) {
            contentOffsetX = 0;
        }
    [self.topScrollView setContentOffset:CGPointMake(contentOffsetX, 0)];
        }];
    
}

-(void)showAddChannelsView{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    if (self.isAddChannelsViewShow == NO) {//下拉
        self.collectionView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, -M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, self.collectionViewFrame.origin.y, self.collectionViewFrame.size.width, 0)];
        animation.toValue = [NSValue valueWithCGRect:self.collectionViewFrame];
        self.isAddChannelsViewShow = YES;
    } else {//收回
        [UIView animateWithDuration:0.25 animations:^{
            self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, M_PI_4);
        }];
        self.collectionView.hidden = YES;
        self.isAddChannelsViewShow = NO;
    }
    
    animation.springBounciness = 5;
    animation.springSpeed = 5;
    [self.collectionView pop_addAnimation:animation forKey:nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topScrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        UIButton *button = self.topScrollView.subviews[index+1];
        [self buttonClick:button];
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
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(kDeviceWidth-20)/2-5-5 所以总高(kDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 35);
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
    if (indexPath.section == 1) {
        //新增自控制器
        [self.currentChannelsArray addObject:self.remainChannelsArray[indexPath.row]];
        [self.remainChannelsArray removeObjectAtIndex:indexPath.row];
        [self storeCurrentChannelsArray];
        
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray.lastObject;
        viewController.channelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];

        CGFloat buttonWidth = self.topScrollView.frame.size.width/5;
        self.topScrollView.contentSize = CGSizeMake(self.currentChannelsArray.count*buttonWidth, 0);
        
        //新增按钮
        UIButton *button = [self createChannelButton];
        button.frame = CGRectMake(self.topScrollView.contentSize.width - buttonWidth, 0, buttonWidth, self.topScrollView.frame.size.height);
        [button setTitle:self.currentChannelsArray.lastObject forState:UIControlStateNormal];
        [self.topScrollView addSubview:button];
        
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
//        [self.collectionView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
        [self showAddChannelsView];
        [self buttonClick:button];
    }

    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor lightGrayColor];
   
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 20, headerView.frame.size.height);
    if (indexPath.section == 0) {
        label.text = @"已添加栏目(长按可进行删除)";
    }else if (indexPath.section == 1) {
        label.text = @"可添加栏目(点击可添加到已有栏目)";
    }
    [headerView.subviews.firstObject removeFromSuperview];
    [headerView addSubview:label];
    
    return headerView;

}

- (void)deleteTheCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.remainChannelsArray addObject:self.currentChannelsArray[indexPath.row]];
    [self.currentChannelsArray removeObjectAtIndex:indexPath.row];
    [self storeCurrentChannelsArray];
    [self.childViewControllers[indexPath.row] removeFromParentViewController];
//    [self.collectionView reloadData];
    
    [self.topScrollView.subviews.lastObject removeFromSuperview];
    for (NSInteger i = 1; i<self.topScrollView.subviews.count; i++) {
        UIButton *button = self.topScrollView.subviews[i];
        [button setTitle:self.currentChannelsArray[i-1] forState:UIControlStateNormal];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    CGFloat buttonWidth = self.topScrollView.frame.size.width/5;
    self.topScrollView.contentSize = CGSizeMake(self.currentChannelsArray.count*buttonWidth, 0);

}

- (void)setupTopScrollViewButtons {
    
    CGFloat buttonWidth = self.topScrollView.frame.size.width/5;
    self.topScrollView.contentSize = CGSizeMake(self.currentChannelsArray.count*buttonWidth, 0);
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        UIButton *button = [self createChannelButton];
        button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, self.topScrollView.frame.size.height);
        [button setTitle:self.currentChannelsArray[i] forState:UIControlStateNormal];
        [button layoutIfNeeded];
        [self.topScrollView addSubview:button];
        if (i == 0) {
            self.selectButton = button;
            [self buttonClick:button];
        }
    }
}

-(UIButton *)createChannelButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.currentSkinModel isEqualToString:DaySkinModelValue]) {//日间模式
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:titleLabelNorimalFont]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)storeCurrentChannelsArray {
    [[NSUserDefaults standardUserDefaults] setObject:self.currentChannelsArray forKey:@"currentChannelsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)titlesArray{
    if (!_titlesArray) {
        //初始化标题数组
        _titlesArray = [NSMutableArray arrayWithObjects:@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车", @"军事", @"理财", @"经济", @"房产", @"国际足球", @"国内足球", @"综合体育", @"电影", @"电视", @"游戏", @"教育", @"美容", @"情感",@"养生", @"数码", @"电脑", @"科普", @"社会", @"台湾", @"港澳", nil];
    }
    return _titlesArray;
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
            _channelsUrlDictionary[@"国内"] = @"5572a109b3cdc86cf39001db";
            _channelsUrlDictionary[@"国际"] = @"5572a109b3cdc86cf39001de";
            _channelsUrlDictionary[@"娱乐"] = @"5572a10ab3cdc86cf39001eb";
            _channelsUrlDictionary[@"互联网"] = @"5572a109b3cdc86cf39001e3";
            _channelsUrlDictionary[@"体育"] = @"5572a109b3cdc86cf39001e6";
            _channelsUrlDictionary[@"财经"] = @"5572a109b3cdc86cf39001e0";
            _channelsUrlDictionary[@"科技"] = @"5572a10ab3cdc86cf39001f4";
            _channelsUrlDictionary[@"汽车"] = @"5572a109b3cdc86cf39001e5";
            _channelsUrlDictionary[@"军事"] = @"5572a109b3cdc86cf39001df";
            _channelsUrlDictionary[@"理财"] = @"5572a109b3cdc86cf39001e1";
            _channelsUrlDictionary[@"经济"] = @"5572a109b3cdc86cf39001e2";
            _channelsUrlDictionary[@"房产"] = @"5572a109b3cdc86cf39001e4";
            _channelsUrlDictionary[@"国际足球"] = @"5572a10ab3cdc86cf39001e7";
            _channelsUrlDictionary[@"国内足球"] = @"5572a10ab3cdc86cf39001e8";
            _channelsUrlDictionary[@"综合体育"] = @"5572a10ab3cdc86cf39001ea";
            _channelsUrlDictionary[@"电影"] = @"5572a10ab3cdc86cf39001ec";
            _channelsUrlDictionary[@"电视"] = @"5572a10ab3cdc86cf39001ed";
            _channelsUrlDictionary[@"游戏"] = @"5572a10ab3cdc86cf39001ee";
            _channelsUrlDictionary[@"教育"] = @"5572a10ab3cdc86cf39001ef";
            _channelsUrlDictionary[@"美容"] = @"5572a10ab3cdc86cf39001f1";
            _channelsUrlDictionary[@"情感"] = @"5572a10ab3cdc86cf39001f2";
            _channelsUrlDictionary[@"养生"] = @"5572a10ab3cdc86cf39001f3";
            _channelsUrlDictionary[@"数码"] = @"5572a10bb3cdc86cf39001f5";
            _channelsUrlDictionary[@"电脑"] = @"5572a10bb3cdc86cf39001f6";
            _channelsUrlDictionary[@"科普"] = @"5572a10bb3cdc86cf39001f7";
            _channelsUrlDictionary[@"社会"] = @"5572a10bb3cdc86cf39001f8";
            _channelsUrlDictionary[@"台湾"] = @"5572a109b3cdc86cf39001dc";
            _channelsUrlDictionary[@"港澳"] = @"5572a109b3cdc86cf39001dd";
            [[NSUserDefaults standardUserDefaults] setObject:_channelsUrlDictionary forKey:@"channelsUrlDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _channelsUrlDictionary;
}

@end

