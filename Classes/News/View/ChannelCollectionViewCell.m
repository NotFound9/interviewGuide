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
}

- (IBAction)DeleteTheChannel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteTheCellAtIndexPath:)]) {//判断代理对象是否有removeTheCell方法;
        [self.delegate deleteTheCellAtIndexPath:self.theIndexPath];
    }
    self.deleteButton.hidden = YES;
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
@end
