//
//  ChannelCollectionViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/30.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ChannelCollectionViewCell.h"

@interface ChannelCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;

@end

static NSString * const kShakeAnimationKey = @"kCollectionViewCellShake";

@implementation ChannelCollectionViewCell

- (void)awakeFromNib {

}

-(void)longPress {
    if([self.delegate respondsToSelector:@selector(didLongPressAChannelCell)]) {
        [self.delegate didLongPressAChannelCell];
    }
}

- (IBAction)DeleteTheChannel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteTheCellAtIndexPath:)]) {//判断代理对象是否有removeTheCell方法;
        [self.delegate deleteTheCellAtIndexPath:self.theIndexPath];
    }
    self.deleteButton.hidden = YES;
}

-(void)setTheIndexPath:(NSIndexPath *)theIndexPath {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    recognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:recognizer];
    _theIndexPath = theIndexPath;
}

-(void)setChannelName:(NSString *)channelName {
    _channelName = channelName;
    self.deleteButton.hidden = YES;
    self.channelNameLabel.text = channelName;
}

- (void)startShake {
    CGPoint point = self.contentView.center;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y+1)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(point.x + 2, point.y+2)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y+1)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(point.x + 1, point.y-1)];
    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(point.x - 2, point.y-1)];
    animation.values=@[value1,value2,value3,value4,value5];
    animation.repeatCount = MAXFLOAT;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeRemoved;
    animation.duration = 0.25;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.delegate=self;
    [self.contentView.layer addAnimation:animation forKey:kShakeAnimationKey];
}

- (void)stopShake {
    [self.contentView.layer removeAnimationForKey:kShakeAnimationKey];
}

#pragma mark 切换至日间模式
-(void)updateToDaySkinMode {
    self.channelNameLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark 切换至夜间模式
-(void)updateToNightSkinMode {
    self.channelNameLabel.textColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
}

@end
