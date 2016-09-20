//
//  TTTopChannelContianerView.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//这是新闻首页上方的新闻频道选择的scrollview

#import <UIKit/UIKit.h>

@protocol TTTopChannelContianerViewDelegate <NSObject>

@optional

- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button;
- (void)chooseChannelWithIndex:(NSInteger)index;

@end

@interface TTTopChannelContianerView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addAChannelButtonWithChannelName:(NSString *)channelName;
- (void)selectChannelButtonWithIndex:(NSInteger)index;
- (void)deleteChannelButtonWithIndex:(NSInteger)index;

//- (void)didShowEditChannelView:(BOOL)value;

@property (nonatomic, strong) NSArray *channelNameArray;
@property (nonatomic, weak) UIScrollView *scrollView;
//@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) id<TTTopChannelContianerViewDelegate> delegate;

@end
