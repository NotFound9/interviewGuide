//
//  ZFView.m
//  ZFCustomLayout
//
//  Created by Yip on 16/5/3.
//  Copyright (c) 2016年 Yip. All rights reserved.
//

#import "ZFView.h"

@implementation ZFView

/**
 *  初始化数组
 */
-(NSMutableArray *)unSelectedBtnArray
{
    if (!_unSelectedBtnArray) {
        _unSelectedBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _unSelectedBtnArray;
}

-(NSMutableArray *)selectedbtnArray
{
    if (!_selectedbtnArray) {
        _selectedbtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectedbtnArray;
}

-(NSMutableArray *)btnBgArray
{
    if (!_btnBgArray) {
        _btnBgArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _btnBgArray;
}

-(ZFButton *)blankBtn
{
    if (!_blankBtn) {
        _blankBtn = [[ZFButton alloc] init];
    }
    return _blankBtn;
}

-(instancetype)initWithFrame:(CGRect)frame titlesArray:(NSMutableArray *)titlesArray
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = CustomColor(246, 246, 246, 1);
        
        //获取已选定按钮数组
        self.titlesArray = titlesArray;
        
        //初始化按钮布局
        [self adjustOfListNum:4 num:titlesArray.count];
        
        //初始化底部候选按钮
        [self setupBottomView];
        
        //初始化顶部候选按钮
        [self setupTopView];
    }
    return self;
}


/**
 *  初始化底部候选按钮所在View
 */
-(void)setupBottomView
{
    //待选按钮区Y值
    CGFloat bottomViewY = [self getBottomViewY];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, WINDOW_W, WINDOW_H - bottomViewY)];
    _bottomView.backgroundColor = CustomColor(246, 246, 246, 1);
    [self addSubview:_bottomView];
    [self bringSubviewToFront:_bottomView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, oneY - 25, WINDOW_W, 20)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @" 点击添加更多栏目";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.backgroundColor = CustomColor(220, 220, 220, 1);
    [_bottomView addSubview:titleLabel];
}

/**
 *  初始化顶部栏目条
 */
-(void)setupTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_W, 26)];
    _topView.backgroundColor = CustomColor(240, 240, 240, 1);
    [self addSubview:_topView];
    
    //切换栏目标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 26)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @" 切换栏目";
    titleLabel.textColor = [UIColor grayColor];
    [_topView addSubview:titleLabel];
    
    //删除按钮
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_W - 80, 3, 50, 20)];
    [_deleteBtn setTitle:@"排序删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:COLOR_PINK forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_deleteBtn addTarget:self action:@selector(deleteAndCompletionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_deleteBtn];
}

-(void)deleteAndCompletionBtnClick:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"排序删除"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [self allBtnIsEditing:YES];
    }else{
        [sender setTitle:@"排序删除" forState:UIControlStateNormal];
        [self allBtnIsEditing:NO];
    }
}

/**
 *  根据数组最后一个按钮Y值,获取bottom位置
 */
-(CGFloat)getBottomViewY
{
    ZFButton * btn = [self.selectedbtnArray lastObject];
    
    CGFloat bottomViewY = btn.frame.size.height + btn.frame.origin.y;
    return bottomViewY;
}


/**
 *  初始化按钮,及底部背景
 *
 *  @param listNum 列数
 *  @param num     按钮数
 */
-(void)adjustOfListNum:(int)listNum num:(NSUInteger)num
{
    //间隔宽度
    int interval = (self.frame.size.width - listNum * Imgw) / (listNum + 1);
    
    //获取第一个图片的坐标
    CGFloat oneX = interval;
    
    for (int i = 0; i < num; i++)
    {
        //获取每个图片的行数
        int line = i / listNum;
        //获取每个图片的列数
        int list = i % listNum;
        
        //按钮下的背景图
        UIImageView * bgImgView = [[UIImageView alloc] init];
        bgImgView.frame = CGRectMake(oneX + (Imgw + interval) * list, oneY + (ImgH + interval) * line, Imgw, ImgH);
        
        bgImgView.image = [UIImage imageNamed:@"home_page_more_buttonbg"];
        
        [self.btnBgArray addObject:bgImgView];
//        [self addSubview:bgImgView];
//        [self sendSubviewToBack:bgImgView];
        
        ZFButton * btn = [[ZFButton alloc] initWithFrame:CGRectMake(oneX + (Imgw + interval) * list, oneY + (ImgH + interval) * line, Imgw, ImgH)];
        [btn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"home_page_more_button"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.delegate = self;
        [self addSubview:btn];
        [self.selectedbtnArray addObject:btn];
        
        //观察btn是否相交
        [btn addObserver:self forKeyPath:@"isIntersect" options:NSKeyValueObservingOptionNew context:nil];
    }
}


/**
 *  自动布局
 *
 *  @param listNum 列数
 *  @param views   自动布局控件数组
 */
-(void)adjustOfListNum:(int)listNum views:(NSMutableArray *)views
{
    //间隔宽度
    int interval = (self.frame.size.width - listNum * Imgw) / (listNum + 1);
    
    //获取第一个图片的坐标
    CGFloat oneX = interval;
    
    for (int i = 0; i < views.count; i++)
    {
        //获取每个图片的行数
        int line = i / listNum;
        //获取每个图片的列数
        int list = i % listNum;
        
        ZFButton * btn = views[i];
        btn.frame = CGRectMake(oneX + (Imgw + interval) * list, oneY + (ImgH + interval) * line, Imgw, ImgH);
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL isIntersect = [change[@"new"] boolValue];
    
    //如果相交
    if (isIntersect) {
        //更换占位按钮与相交按钮位置
        [self.selectedbtnArray exchangeObjectAtIndex:[self.selectedbtnArray indexOfObject:object] withObjectAtIndex:[self.selectedbtnArray indexOfObject:self.blankBtn]];
        //刷新
        [self reloadData:self.selectedbtnArray];
    }
}

/**
 *  添加选中按钮
 */
-(void)addBtnClick:(ZFButton *)sender
{
    //按钮未被选择
    if (!sender.isSelect) {
        sender.isSelect = YES;
        //插入已选择数组
        [self.selectedbtnArray addObject:sender];
        
        //从为选择数组移除
        [self.unSelectedBtnArray removeObject:sender];
        
        //由于父视图不同,解决按钮偏差
        CGFloat senderY = _bottomView.frame.origin.y + 50;
        
        sender.frame = CGRectMake(sender.frame.origin.x, senderY, sender.frame.size.width, sender.frame.size.height);
        
        //按钮放到主视图,完成之后显示底部
        [self addSubview:sender];
        [self reloadData:self.selectedbtnArray completion:^(BOOL finished) {
            [self isHideBtnBg:NO];
        }];
        
        [self reloadData:self.unSelectedBtnArray];
    }
}

/**
 *  删除按钮
 *
 *  @param btn     父视图按钮
 */
-(void)deleteButton:(ZFButton *)btn
{
    //取消按钮标记状态
    btn.isEditing = NO;
    
    //隐藏按钮底部视图
    [self isHideBtnBg:YES];
    
    //将按钮放入待选数组
    [self.unSelectedBtnArray addObject:btn];
    
    //将按钮从已选数组移除
    [self.selectedbtnArray removeObject:btn];
    
    //按钮放到待选View
    [_bottomView addSubview:btn];
    
    //刷新按钮位置
    [self reloadData:self.selectedbtnArray];
    [self reloadData:self.unSelectedBtnArray];
}

/**
 *  按钮已经被拖动
 *
 *  @param btn     按钮
 *  @param gesture 手势
 */
-(void)button:(ZFButton *)btn didPan:(UIGestureRecognizer *)gesture
{
    //获取触摸位置
    CGPoint point = [gesture locationInView:self];
    gesture.view.center = point;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //占位按钮替换掉拖动按钮
            [self.selectedbtnArray replaceObjectAtIndex:[self.selectedbtnArray indexOfObject:gesture.view] withObject:self.blankBtn];
            [self bringSubviewToFront:gesture.view];
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            for (ZFButton * btn in self.selectedbtnArray)
            {
                //如果拖动按钮与其他按钮相交,改变按钮isIntersect属性
                if (CGRectContainsPoint(btn.frame, point) ) {
                    //如果之前不相交,改为相交,然后跳出循环
                    if (btn.isIntersect == NO) {
                        btn.isIntersect = YES;
                        return;
                    }
                }else {
                    //将其他按钮isIntersect置为NO
                    if(btn.isIntersect == YES){
                        btn.isIntersect = NO;
                    }
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            //拖动结束,用拖动按钮将空白按钮替换
            [self.selectedbtnArray replaceObjectAtIndex:[self.selectedbtnArray indexOfObject:self.blankBtn] withObject:gesture.view];
            [self reloadData:self.selectedbtnArray];
        }
            break;
        default:
            break;
    }
}


/**
 *  按钮已经被长按
 *
 *  @param btn     当前按钮
 *  @param gesture 长按手势
 */
-(void)button:(ZFButton *)btn didLongPress:(UIGestureRecognizer *)gesture
{
    [self allBtnIsEditing:YES];
}

/**
 *  设置按钮编辑状态,隐藏底部视图
 */
-(void)allBtnIsEditing:(BOOL)isEditing
{
    for (ZFButton * btn in self.selectedbtnArray) {
        btn.isEditing = isEditing;
    }
    if (isEditing) {
        [_deleteBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    _bottomView.hidden = isEditing;
}

/**
 *  刷新所有按钮位置
 */
-(void)reloadData:(NSMutableArray *)btnArray
{
    [UIView animateWithDuration:AnimateDuration animations:^{
        //重新布局按钮
        [self adjustOfListNum:4 views:btnArray];
        
        //被选择按钮数组为空时,固定底部按钮位置
        if (self.selectedbtnArray.count == 0) {
            _bottomView.frame = CGRectMake(0, 70, WINDOW_W, 200);
        }else{
            _bottomView.frame = CGRectMake(0, [self getBottomViewY], WINDOW_W, 200);
        }
    }];
}

/**
 *  刷新所有按钮位置
 */
-(void)reloadData:(NSMutableArray *)btnArray completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:AnimateDuration animations:^{
        //重新布局按钮
        [self adjustOfListNum:4 views:btnArray];
        
        //被选择按钮数组为空时,固定底部按钮位置
        if (self.selectedbtnArray.count == 0) {
            _bottomView.frame = CGRectMake(0, 70, WINDOW_W, 200);
        }else{
            _bottomView.frame = CGRectMake(0, [self getBottomViewY], WINDOW_W, 200);
        }
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}


/**
 *  隐藏背景视图
 *
 *  @param isHide 是否隐藏
 */
-(void)isHideBtnBg:(BOOL)isHide
{
    if (isHide) {
        //从数组倒序隐藏按钮底部视图
        for (NSUInteger i = 0; i < self.btnBgArray.count; i++) {
            UIImageView * bgImgView = self.btnBgArray[self.btnBgArray.count - 1 - i];
            if (!bgImgView.hidden) {
                bgImgView.hidden = YES;
                return;
            }
        }
    }else{
        //从数组正序显示按钮底部视图
        for (NSUInteger i = 0; i < self.btnBgArray.count; i++) {
            UIImageView * bgImgView = self.btnBgArray[i];
            if (bgImgView.hidden) {
                bgImgView.hidden = NO;
                return;
            }
        }
    }
}

-(void)dealloc
{
    for (ZFButton * btn in self.selectedbtnArray) {
        [btn removeObserver:self forKeyPath:@"isIntersect"];
    }
}

@end
