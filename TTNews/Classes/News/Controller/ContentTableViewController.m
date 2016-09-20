//
//  ContentTableViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/26.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ContentTableViewController.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"
#import "DetailViewController.h"
#import "ShowMultiPictureViewController.h"
#import "TTNormalNewsFetchDataParameter.h"
#import "TTDataTool.h"
#import "TTConst.h"
#import <DKNightVersion.h>
#import <SDImageCache.h>
#import "SXNetworkTools.h"
#import "SXNewsEntity.h"
#import <MJExtension.h>
#import "TopTextTableViewCell.h"
#import "TopPictureTableViewCell.h"
#import "BigPictureTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface ContentTableViewController ()

@property (nonatomic, strong) NSMutableArray *headerNewsArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *normalNewsArray;
@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, strong) NSMutableArray *arrayList;
@property(nonatomic,assign)BOOL update;

@end

static NSString * const singlePictureCell = @"SinglePictureCell";
static NSString * const multiPictureCell = @"MultiPictureCell";
static NSString * const bigPictureCell = @"BigPictureCell";
static NSString * const topTextPictureCell = @"TopTextPictureCell";
static NSString * const topPictureCell = @"TopPictureCell";

@implementation ContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBasic];
    [self setupRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.update == YES) {
        [self.tableView.mj_header beginRefreshing];
        self.update = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark --private Method--设置tableView
-(void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:topPictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopTextTableViewCell class]) bundle:nil] forCellReuseIdentifier:topTextPictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BigPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:bigPictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:singlePictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MultiPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:multiPictureCell];
}


#pragma mark --private Method--初始化刷新控件
-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}


#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    // http://c.m.163.com//nc/article/headline/T1348647853363/0-30.html
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/0-20.html",self.urlString];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,(self.arrayList.count - self.arrayList.count%10)];
    //    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,self.arrayList.count];
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    [[[SXNetworkTools sharedNetworkTools] GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSLog(@"%@",allUrlstring);
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSArray *arrayM = [SXNewsEntity mj_objectArrayWithKeyValuesArray:temArray];
        
        if (type == 1) {
            self.arrayList = [arrayM mutableCopy];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }] resume];
}// ------想把这里改成block来着



#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SXNewsEntity *NewsModel = self.arrayList[indexPath.row];
    if (NewsModel.hasHead && NewsModel.photosetID) {
        TopPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topPictureCell];
        [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
        cell.LblTitleLabel.text = NewsModel.title;
        return cell;
    }else if (NewsModel.hasHead){
        TopTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topTextPictureCell];
        [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
        cell.LblTitleLabel.text = NewsModel.title;
        return cell;
    }else if (NewsModel.imgType){
        BigPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bigPictureCell];
        [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
        cell.LblTitleLabel.text = NewsModel.title;
        cell.subTitleLabel.text = NewsModel.subtitle;
        return cell;
    }else if (NewsModel.imgextra){
        MultiPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
        cell.theTitle = NewsModel.title;
        cell.imageUrls = [NSArray arrayWithObjects:NewsModel.imgsrc, NewsModel.imgextra[0], NewsModel.imgextra[0], nil];
        return cell;
    }else{
        SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
        cell.imageUrl = NewsModel.imgsrc;
        cell.contentTittle = NewsModel.title;
        cell.desc = NewsModel.digest;

        return cell;
    }
//    if (newsModel.imgextra){
//        MultiPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
//        cell.theTitle = newsModel.title;
//        cell.imageUrls = [NSArray arrayWithObjects:newsModel.imgsrc, newsModel.imgextra[0], newsModel.imgextra[0], nil];
//        return cell;
//    } else {
//        SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
//        cell.imageUrl = newsModel.imgsrc;
//        cell.contentTittle = newsModel.title;
//        cell.desc = newsModel.digest;
//        
//        return cell;
//    }
    
//    TTNormalNews *news = self.normalNewsArray[indexPath.row];
//    if (news.normalNewsType == NormalNewsTypeMultiPicture) {
//        MultiPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
//        cell.title = news.title;
//        cell.imageUrls = news.imageurls;
//        
//        return cell;
//    } else if (news.normalNewsType == NormalNewsTypeSigalPicture) {
//        SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
//        cell.contentTittle = news.title;
//        cell.desc = news.desc;
//        NSDictionary *dict = news.imageurls.firstObject;
//        if (dict) {
//            cell.imageUrl = dict[@"url"];
//        }
//            return cell;
//    } else {
//        NoPictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noPictureCell];
//        cell.titleText = news.title;
//        cell.contentText = news.desc;
//        
//        return cell;
//    }
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SXNewsEntity *NewsModel = self.arrayList[indexPath.row];
//
//    return newsModel.cellHeight;
    if (NewsModel.hasHead && NewsModel.photosetID){
        return 245;
    }else if(NewsModel.hasHead) {
        return 245;
    }else if(NewsModel.imgType) {
        return 170;
    }else if (NewsModel.imgextra){
        return 130;
    }else{
        return 100;
    }
}

#pragma mark -UITableViewDelegate 点击了某个cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SXNewsEntity *NewsModel = self.arrayList[indexPath.row];
    if (NewsModel.hasHead && NewsModel.photosetID) {
        [self pushToDetailViewControllerWithUrl:NewsModel.url];
    }else if (NewsModel.hasHead){
        [self pushToDetailViewControllerWithUrl:NewsModel.url];

    }else if (NewsModel.imgType){
        [self pushToDetailViewControllerWithUrl:NewsModel.url];

    }else if (NewsModel.imgextra){
        ShowMultiPictureViewController *viewController = [[ShowMultiPictureViewController alloc] init];
        viewController.imageUrls =  [NSArray arrayWithObjects:NewsModel.imgsrc, NewsModel.imgextra[0], NewsModel.imgextra[0], nil];
        NSString *text = NewsModel.digest;
        if (text == nil || [text isEqualToString:@""]) {
            text = NewsModel.title;
        }
        viewController.text = text;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self pushToDetailViewControllerWithUrl:NewsModel.url];
    }

}

#pragma mark --private Method--点击了某一条新闻，调转到新闻对应的网页去
-(void)pushToDetailViewControllerWithUrl:(NSString *)url {
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.url = url;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark --懒加载--normalNewsArray
-(NSMutableArray *)normalNewsArray {
    if (!_normalNewsArray) {
        _normalNewsArray = [NSMutableArray array];
    }
    return _normalNewsArray;
}

#pragma mark --懒加载--headerNewsArray
-(NSMutableArray *)headerNewsArray {
    if (!_headerNewsArray) {
        _headerNewsArray = [NSMutableArray array];
    }
    return _headerNewsArray;
}
-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
    
}
@end
