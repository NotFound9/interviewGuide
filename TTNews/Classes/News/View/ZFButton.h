//
//  ZFButton.h
//  ZFCustomLayout
//
//  Created by Yip on 15/5/3.
//  Copyright (c) 2016年 Yip. All rights reserved.
//



#import <UIKit/UIKit.h>

@class ZFButton;
@protocol ZFButtonDelegate <NSObject>

/**
 *  删除按钮
 *
 *  @param btn     父视图按钮
 */
-(void)deleteButton:(ZFButton *)btn;

/**
 *  按钮已经被长按
 *
 *  @param btn     按钮
 *  @param gesture 手势
 */
-(void)button:(ZFButton *)btn didLongPress:(UIGestureRecognizer *)gesture;

/**
 *  按钮已经被拖动
 *
 *  @param btn     按钮
 *  @param gesture 手势
 */
-(void)button:(ZFButton *)btn didPan:(UIGestureRecognizer *)gesture;

@end

@interface ZFButton : UIButton

/** 相交*/
@property (nonatomic, assign) BOOL isIntersect;

/** 编辑状态*/
@property (nonatomic, assign) BOOL isEditing;

/** 被选择*/
@property (nonatomic, assign) BOOL isSelect;

/** 删除按钮*/
@property (nonatomic, strong) UIButton * deleteBtn;


@property (nonatomic, weak) id<ZFButtonDelegate> delegate;


@end
