//
//  ChannelCollectionViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/30.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelCollectionViewCellDelegate <NSObject>

- (void)didLongPressAChannelCell;
- (void)deleteTheCellAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface ChannelCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *channelName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSIndexPath *theIndexPath;
@property (nonatomic, weak) id delegate;

- (void)startShake;
- (void)stopShake;

@end

