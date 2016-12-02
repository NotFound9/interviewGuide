//
//  DetailViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "DetailViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "TTConst.h"
#import "TTJudgeNetworking.h"
#import <DKNightVersion.h>

@interface DetailViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIView *shadeView;//(页面模式时，用来使页面变暗)

@property (nonatomic, weak) UIButton *collectButton;
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) UIBarButtonItem *backItem;
@property (nonatomic, weak) UIBarButtonItem *forwardItem;
@property (nonatomic, weak) UIBarButtonItem *refreshItem;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([TTJudgeNetworking judge] == NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);

    [self setupWebView];
    [self setupNaigationBar];
    [self setupToolBars];
//    [self setupShadeView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    self.navigationController.toolbarHidden = NO;

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    self.navigationController.toolbarHidden = YES;
}

#pragma mark --private Method--初始化webView
- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    webView.frame = self.view.frame;
    webView.delegate = self;
    [self.view addSubview:webView];
    [SVProgressHUD show];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];

}

#pragma mark --private Method--初始化NavigationBar
-(void)setupNaigationBar {
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectButton = collectButton;
    collectButton.frame =CGRectMake(0, 0, 30, 30);
    [collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorite_pressed"] forState:UIControlStateHighlighted];
    [self.collectButton setImage:[[UIImage imageNamed:@"navigationBarItem_favorited_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectThisNews) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
}

#pragma mark --private Method--初始化toolBar
- (void)setupToolBars{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_back_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backItem.enabled = NO;
    self.backItem = backItem;
    
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_forward_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic]  style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    forwardItem.enabled = NO;
    self.forwardItem = forwardItem;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.refreshItem = refreshItem;
    
    self.toolbarItems = @[backItem,forwardItem,flexibleItem,refreshItem];
    backItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    forwardItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    refreshItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    self.navigationController.toolbar.dk_tintColorPicker =  DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
}

#pragma mark --private Method--初始化shadeView(页面模式时，用来使页面变暗)
- (void)setupShadeView {
    UIView *shadeView = [[UIView alloc] init];
    self.shadeView = shadeView;
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0.3;
    shadeView.userInteractionEnabled = NO;
    shadeView.frame = self.webView.bounds;
    [self.webView addSubview:shadeView];
}

#pragma mark -UIWebViewDelegate-将要加载Webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark -UIWebViewDelegate-已经开始加载Webview
- (void)webViewDidStartLoad:(UIWebView *)webView {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           //执行事件
        [SVProgressHUD dismiss];
    });
}

#pragma mark -UIWebViewDelegate-已经加载Webview完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}

#pragma mark -UIWebViewDelegate-加载Webview失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}


#pragma mark --private Method--返回上一个页面
-(void)goBack {
    [self.webView goBack];
}

#pragma mark --private Method--前进到下一个页面
-(void)goForward {
    [self.webView goForward];
}

#pragma mark --private Method--刷新当前页面
-(void)refresh {
    [self.webView reload];
}

#pragma mark --private Method--收藏这条新闻
-(void)collectThisNews {
    self.collectButton.selected = !self.collectButton.selected;
    if (self.collectButton.selected) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        [self.collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorited_normal"] forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorited_pressed"] forState:UIControlStateHighlighted];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
        [self.collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorite_pressed"] forState:UIControlStateHighlighted];
    }
}

@end
