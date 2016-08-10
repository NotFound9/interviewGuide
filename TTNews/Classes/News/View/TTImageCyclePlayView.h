//
//  TTImageCyclePlayView.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/28.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTImageCyclePlayViewDelegate <NSObject>
@optional

- (void)clickCurrentImageViewInImageCyclePlay;

@end

@interface TTImageCyclePlayView : UIView

@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger currentMiddleImageViewIndex;
@property (nonatomic, weak) id<TTImageCyclePlayViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
- (void)updateImageViewsAndTitleLabel;
- (void)addTimer;
- (void)removeTimer;

@end
