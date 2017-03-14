//
//  MusicCell.h
//  10音乐下载demo
//
//  Created by HM09 on 17/3/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@class MusicCell;

@protocol MusicCellDelegate <NSObject>

- (void)startorPause:(MusicCell *)cell;

@end

@interface MusicCell : UITableViewCell

@property (nonatomic, weak) id<MusicCellDelegate> delegate;
@property (nonatomic, strong) MusicModel *model;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UIButton *startOrPauseButton;

@end
