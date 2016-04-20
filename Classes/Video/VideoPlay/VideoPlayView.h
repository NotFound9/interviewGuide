//
//  VideoPlayView.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoPlayViewDelegate <NSObject>

@optional
- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface VideoPlayView : UIView

+ (instancetype)videoPlayView;

@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;

@property (nonatomic, strong) AVPlayerItem *playerItem;

-(void)suspendPlayVideo;

-(void)resetPlayView;
@end
