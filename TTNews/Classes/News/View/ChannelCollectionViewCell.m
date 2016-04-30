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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end

@implementation ChannelCollectionViewCell

- (void)awakeFromNib {
    self.deleteButton.hidden = YES;
}

-(void)wantToDeleteTheChannel {
    self.deleteButton.hidden = NO;
    [self BeginWobble];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5000 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self EndWobble];
    });
}

- (IBAction)DeleteTheChannel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteTheCellAtIndexPath:)]) {//判断代理对象是否有removeTheCell方法;
        [self.delegate deleteTheCellAtIndexPath:self.theIndexPath];
    }
    self.deleteButton.hidden = YES;
    [self EndWobble];
}

-(void)setTheIndexPath:(NSIndexPath *)theIndexPath {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(wantToDeleteTheChannel)];
    recognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:recognizer];
    _theIndexPath = theIndexPath;
}

-(void)setChannelName:(NSString *)channelName {
    _channelName = channelName;
    self.channelNameLabel.text = channelName;
}

-(void)BeginWobble
{
    
    srand([[NSDate date] timeIntervalSince1970]);
    float rand=(float)random();
    CFTimeInterval t=rand*0.0000000001;
    
    [UIView animateWithDuration:0.1 delay:t options:0  animations:^
     {
         self.specialcell_nav_btn.transform=CGAffineTransformMakeRotation(-0.05);
         self.deleteButton.transform=CGAffineTransformMakeRotation(-0.05);
         
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
          {
              self.specialcell_nav_btn.transform=CGAffineTransformMakeRotation(0.05);
              self.deleteButton.transform=CGAffineTransformMakeRotation(0.05);
          } completion:^(BOOL finished) {}];
     }];
}

-(void)EndWobble
{
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         self.specialcell_nav_btn.transform=CGAffineTransformIdentity;
         self.deleteButton.transform=CGAffineTransformIdentity;
     } completion:^(BOOL finished) {
         self.deleteButton.hidden = YES;
     }];
}
@end
