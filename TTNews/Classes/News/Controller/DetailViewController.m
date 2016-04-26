//
//  DetailViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "DetailViewController.h"
#import <SVProgressHUD.h>
#import "TTConst.h"
#import "TTJudgeNetworking.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIView *shadeView;
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
    
    [self setupBasic];
    [self setupNaigationBar];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    self.navigationController.toolbarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
    [self updateSkinModel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    self.navigationController.toolbarHidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateSkinModel {
    NSString  *currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([currentSkinModel isEqualToString:NightSkinModelValue]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.shadeView.hidden = NO;
        self.refreshItem.tintColor = [UIColor whiteColor];
        self.backItem.tintColor = [UIColor whiteColor];
        self.forwardItem.tintColor = [UIColor whiteColor];
    } else {//日间模式
        self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.shadeView.hidden = YES;
        self.refreshItem.tintColor = [UIColor colorWithRed:245/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
        self.backItem.tintColor = [UIColor colorWithRed:245/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
        self.forwardItem.tintColor = [UIColor colorWithRed:245/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
    }
}

-(void)setupNaigationBar {
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectButton = collectButton;
    collectButton.frame =CGRectMake(0, 0, 30, 30);
    [collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"navigationBarItem_favorite_pressed"] forState:UIControlStateHighlighted];
    [self.collectButton setImage:[[UIImage imageNamed:@"navigationBarItem_favorited_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectThisNews) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    
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
}

-(void)goBack {
    [self.webView goBack];
}

-(void)goForward {
    [self.webView goForward];
}
-(void)refresh {
    [self.webView reload];
}

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

- (void)setupBasic {
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    webView.frame = self.view.frame;
    webView.delegate = self;
    [self.view addSubview:webView];
    [SVProgressHUD show];
    
    UIView *shadeView = [[UIView alloc] init];
    self.shadeView = shadeView;
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0.3;
    shadeView.userInteractionEnabled = NO;
    shadeView.frame = webView.bounds;
    [webView addSubview:shadeView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
 }


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           //执行事件
        [SVProgressHUD dismiss];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [SVProgressHUD dismiss];
}


@end
