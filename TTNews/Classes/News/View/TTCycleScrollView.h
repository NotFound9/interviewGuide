//
//  TTCycleScrollView.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/28.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTCycleScrollViewDelegate <NSObject>
@optional

- (void)clickCurrentImageViewInCycleScrollView;

@end

@interface TTCycleScrollView : UIView


@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger currentMiddleImageViewIndex;
@property (nonatomic, weak) id<TTCycleScrollViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
- (void)updateImageViewsAndTitleLabel;
- (void)addTimer;
- (void)removeTimer;
-(void)updateToDaySkinMode;
-(void)updateToNightSkinMode;


@end
