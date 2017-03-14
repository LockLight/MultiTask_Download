//
//  MusicCell.m
//  10音乐下载demo
//
//  Created by HM09 on 17/3/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) setModel:(MusicModel *)model {
    _model = model;
    _musicLabel.text = model.name;
    
    NSString *title = model.isDownLoading ? @"暂停" : @"开始";
    [_startOrPauseButton setTitle:title forState:UIControlStateNormal];
    
    _startOrPauseButton.enabled = model.isFinish ? NO : YES;
    _progressView.progress = model.progress;
}

- (IBAction)startOrPauseButton:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(startorPause:)]){
       [self.delegate startorPause:self];
    }
}
@end
