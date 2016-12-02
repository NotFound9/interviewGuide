//
//  VideoPlayView.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//


#import "VideoPlayView.h"

@interface VideoPlayView()

/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;

// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSIndexPath *indexPath;


// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)sliderValueChange;

@end

@implementation VideoPlayView

// 快速创建View的方法
+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    self.toolView.alpha = 0;
    self.isShowToolView = NO;
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    [self removeProgressTimer];
    [self addProgressTimer];
    
    self.playOrPauseBtn.selected = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player play];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        [self.progressView stopAnimating];
    }
}

// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;//隐藏
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 1;
            self.isShowToolView = YES;
        }
    }];
}
//
-(void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}
// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        [self addProgressTimer];
    } else {
        [self.progressView stopAnimating];
        [self.player pause];
        [self removeProgressTimer];
    }
}
- (void)suspendPlayVideo {
    [self.progressView stopAnimating];
    
    self.playOrPauseBtn.selected = NO;
    self.toolView.alpha = 1;
    self.isShowToolView = YES;
    
    [self.player pause];
    
    [self removeProgressTimer];
}

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

// 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        [self.delegate videoplayViewSwitchOrientation:sender.selected];
    }
}

- (IBAction)slider {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}

- (IBAction)startSlider {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    dMin = dMin<0?0:dMin;
    dSec = dSec<0?0:dSec;
    cMin = cMin<0?0:cMin;
    cSec = cSec<0?0:cSec;

    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

-(void)resetPlayView {
    [self suspendPlayVideo];
    
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;
    
    [self removeFromSuperview];


}

@end
