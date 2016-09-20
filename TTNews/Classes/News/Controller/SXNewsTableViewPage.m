//
//  SXTableViewPage.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.//

#import "SXNewsTableViewPage.h"
//#import "SXDetailPage.h"
//#import "SXPhotoSetPage.h"
//#import "SXNewsCell.h"
#import "SXNetworkTools.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"
#import "NoPictureNewsTableViewCell.h"
#import <DKNightVersion.h>

static NSString * const singlePictureCell = @"SinglePictureCell";
static NSString * const multiPictureCell = @"MultiPictureCell";
static NSString * const noPictureCell = @"NoPictureCell";

@interface SXNewsTableViewPage ()

@property(nonatomic,strong) NSMutableArray *arrayList;
@property(nonatomic,assign)BOOL update;

@end

@implementation SXNewsTableViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoPictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:noPictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:singlePictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MultiPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:multiPictureCell];

    self.view.backgroundColor = [UIColor clearColor];
    __weak SXNewsTableViewPage *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.update = YES;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(welcome) name:@"SXAdvertisementKey" object:nil];
//    self.tableView.headerHidden = NO;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

//- (void)welcome
//{
//    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
//    [self.tableView.mj_header beginRefreshing];
//}

- (void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
//    NSLog(@"bbbb");
    if (self.update == YES) {
        [self.tableView.mj_header beginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}


#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    // http://c.m.163.com//nc/article/headline/T1348647853363/0-30.html
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/0-20.html",self.urlString];
    [self loadDataForType:1 withURL:allUrlstring];
}

// ------上拉加载
- (void)loadMoreData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,(self.arrayList.count - self.arrayList.count%10)];
//    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,self.arrayList.count];
    [self loadDataForType:2 withURL:allUrlstring];
}

// ------公共方法
- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    [[[SXNetworkTools sharedNetworkTools] GET:allUrlstring parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSLog(@"%@",allUrlstring);
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSArray *arrayM = [SXNewsEntity objectArrayWithKeyValuesArray:temArray];
        
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

#pragma mark - /************************* tbv数据源方法 ***************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SXNewsEntity *newsModel = self.arrayList[indexPath.row];
//    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
//        ID = @"NewsCell";
//    }
    if (newsModel.imgextra){
        MultiPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
        cell.theTitle = newsModel.title;
        cell.imageUrls = [NSArray arrayWithObjects:newsModel.imgsrc, newsModel.imgextra[0], newsModel.imgextra[0], nil];
        return cell;
    }
    
    SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
    cell.imageUrl = newsModel.imgsrc;
    cell.contentTittle = newsModel.title;
    cell.desc = newsModel.digest;
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXNewsEntity *newsModel = self.arrayList[indexPath.row];
//    CGFloat rowHeight = [SXNewsCell heightForRow:newsModel];
//    
//    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
//        rowHeight = 80;
//    }
    
    return newsModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    
//    SXNewsCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0]];
//    
//    NSLog(@"%f",cell.height);
//    if ([segue.destinationViewController isKindOfClass:[SXDetailPage class]]) {
//        
//        NSInteger x = self.tableView.indexPathForSelectedRow.row;
//        SXDetailPage *dc = segue.destinationViewController;
//        dc.newsModel = self.arrayList[x];
//        dc.index = self.index;
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//        }
//    }else{
//        NSInteger x = self.tableView.indexPathForSelectedRow.row;
//        SXPhotoSetPage *pc = segue.destinationViewController;
//        pc.newsModel = self.arrayList[x];
//    }
    
}

@end