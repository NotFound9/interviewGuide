//
//  ZFButton.m
//  ZFCustomLayout
//
//  Created by Yip on 15/5/3.
//  Copyright (c) 2016年 Yip. All rights reserved.
//


#import "ZFButton.h"

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)


@implementation ZFButton


/**
 *  初始化按钮时添加删除按钮
 *
 *  @param isEditing 是否为编辑模式
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, -5, 16, 16)];
        [_deleteBtn setImage:[UIImage imageNamed:@"button_unfollow_userspace"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        
        //添加长按手势
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] init];
        [longPress addTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        
        //拖动按钮
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        self.isEditing = NO;
        self.isSelect = YES;
    }
    return self;
}

/**
 *  设置按钮编辑状态
 *
 *  @param isEditing 是否可编辑
 */
-(void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (isEditing) {
        [self shaking];
    }else{
        [self.layer removeAnimationForKey:@"shake"];
    }
    
    self.deleteBtn.hidden = !isEditing;
}

//删除按钮
-(void)deleteBtnClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(deleteButton:)]) {
        [_delegate deleteButton:self];
        self.isSelect = NO;
    }
}

//拖动
-(void)pan:(UIGestureRecognizer *)gesture
{
    if (self.isEditing) {
        if ([_delegate respondsToSelector:@selector(button:didPan:)]) {
            [_delegate button:self didPan:gesture];
        }
    }
}

//长按
-(void)longPress:(UIGestureRecognizer *)gesture
{
    if (self.isEditing) return;
    
    if (!self.isSelect) return;
        
    if ([_delegate respondsToSelector:@selector(button:didLongPress:)]) {
        [_delegate button:self didLongPress:gesture];
    }
}

/**
 *  抖动动画
 */
- (void)shaking
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(-2)),  @(Angle2Radian(2)), @(Angle2Radian(-2))];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:anim forKey:@"shake"];
}




@end
