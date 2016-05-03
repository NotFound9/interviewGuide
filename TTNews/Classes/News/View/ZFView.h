//
//  ZFView.h
//  ZFCustomLayout
//
//  Created by Yip on 16/5/3.
//  Copyright (c) 2016年 Yip. All rights reserved.
//

//主屏幕宽高
#define WINDOW_W [UIScreen mainScreen].bounds.size.width
#define WINDOW_H [UIScreen mainScreen].bounds.size.height

//图片的宽高
#define Imgw 68
#define ImgH 30

//第一个按钮开始的Y值
#define oneY 55

//调配颜色
#define CustomColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//粉红色
#define COLOR_PINK [UIColor colorWithRed:255.0/255.0 green:82.0/255.0 blue:141.0/255.0 alpha:1.0]

//动画时间
#define AnimateDuration 0.5

#import <UIKit/UIKit.h>
#import "ZFButton.h"

@interface ZFView : UIView <ZFButtonDelegate>
{
    ZFButton * _selected;   //被选择按钮
    UIView * _topView;
    UIView * _bottomView;
    UIButton * _deleteBtn;
}

//空白按钮
@property (nonatomic, strong) ZFButton *blankBtn;

/** 被选择按钮数组*/
@property (nonatomic, strong) NSMutableArray * selectedbtnArray;

/** 未被选择按钮数组*/
@property (nonatomic, strong) NSMutableArray * unSelectedBtnArray;

/** 标题数组*/
@property (nonatomic, strong) NSMutableArray * titlesArray;

/* 按钮底部背景数组*/
@property (nonatomic, strong) NSMutableArray * btnBgArray;

/**
 *  实现功能的View
 *
 *  @param frame       尺寸,位置
 *  @param titlesArray  标题数组
 *
 *  @return 实现功能的View
 */
-(instancetype)initWithFrame:(CGRect)frame titlesArray:(NSMutableArray *)titlesArray;

@end
