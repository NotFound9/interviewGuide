//
//  TTImageCyclePlayView.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/28.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTImageCyclePlayView.h"
#import <UIImageView+WebCache.h>
#import <DKNightVersion.h>

@interface TTImageCyclePlayView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *middleImageView;
@property (nonatomic, weak) UIImageView *rightImageView;
@property (nonatomic, weak) UIView *bottomContianerView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation TTImageCyclePlayView

#pragma mark 初始化View
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

#pragma mark 初始化子控件
- (void)initialization {
    //初始化scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = self.bounds;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*3, 0);
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    //初始化scrollView上的左中右三张imageView,
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        if (i==0) {
            self.leftImageView = imageView;
        } else if (i==1) {
            self.middleImageView = imageView;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMiddleImageView)]];

        } else if (i==2) {
            self.rightImageView = imageView;
        }
    }
    
    //初始化View下方的存放titleLabel和pageControl的contianerView
    CGFloat kBottomContianerViewlHeight = 30;
    UIView *bottomContianerView = [[UIView alloc] init];
    self.bottomContianerView = bottomContianerView;
    bottomContianerView.frame = CGRectMake(0, self.bounds.size.height -kBottomContianerViewlHeight, self.bounds.size.width, kBottomContianerViewlHeight);
    bottomContianerView.backgroundColor = [UIColor darkGrayColor];
    bottomContianerView.alpha = 0.8;
    [self addSubview:bottomContianerView];
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl  = pageControl;
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    CGFloat kPageControlWidth = [pageControl sizeForNumberOfPages:5].width;
    CGFloat margin = 10;
    pageControl.frame = CGRectMake(bottomContianerView.frame.size.width - kPageControlWidth - margin, 0, kPageControlWidth, bottomContianerView.frame.size.height);

    [bottomContianerView addSubview:pageControl];
    
    //初始化titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

    titleLabel.frame = CGRectMake(0, 0, bottomContianerView.frame.size.width - kPageControlWidth - 2*margin, bottomContianerView.frame.size.height);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor darkGrayColor];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bottomContianerView addSubview:titleLabel];
    
}

#pragma mark UIScrollViewDelegate scrollView开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

#pragma mark UIScrollViewDelegate scrollView将要停止拖动（即手指将离开屏幕）
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self addTimer];
}

#pragma mark UIScrollViewDelegate scrollView将要停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (self.imageUrls == nil || self.imageUrls.count == 0 || self.titles == nil || self.titles.count == 0) return;
        
        if (scrollView.contentOffset.x>=scrollView.frame.size.width) {//向右滑动
            self.currentMiddleImageViewIndex = (self.currentMiddleImageViewIndex + 1)%self.imageUrls.count;
        } else {//向左滑动
            self.currentMiddleImageViewIndex = (self.currentMiddleImageViewIndex - 1 + self.imageUrls.count)%self.imageUrls.count;
        }
        
        [self updateImageViewsAndTitleLabel];
    }
}

#pragma mark 数据刷新后更新imageView和TitleLabel
- (void)updateImageViewsAndTitleLabel {
    if (self.imageUrls == nil || self.imageUrls.count == 0 || self.titles == nil || self.titles.count == 0) return;
    
    NSInteger leftIndex = (self.currentMiddleImageViewIndex - 1 + self.imageUrls.count)%self.imageUrls.count;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[leftIndex]]];
    
    self.titleLabel.text = [NSString stringWithFormat:@"   %@", self.titles[self.currentMiddleImageViewIndex]];
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.currentMiddleImageViewIndex]]];
    
    NSInteger rightIndex = (self.currentMiddleImageViewIndex + 1)%self.imageUrls.count;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[rightIndex]]];
    
    self.pageControl.numberOfPages = self.imageUrls.count;
    self.pageControl.currentPage = self.currentMiddleImageViewIndex;
    //重新设置scrollView的contentOffset,即将滑动后的imageView显示在最中间
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
}

#pragma mark 添加定时器
- (void)addTimer {
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

#pragma mark 移除定时器
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark scrollView轮播到下一个ImageView
- (void)nextNews {
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+[UIScreen mainScreen].bounds.size.width, 0)];
    }];
    [self scrollViewDidEndDecelerating:self.scrollView];
}

#pragma mark 点击了中间的ImageView即当前显示的ImageView
- (void)clickMiddleImageView {
    if ([self.delegate respondsToSelector:@selector(clickCurrentImageViewInImageCyclePlay)]) {
        [self.delegate clickCurrentImageViewInImageCyclePlay];
    }
}



@end
