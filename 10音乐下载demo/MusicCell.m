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
    [_startOrPauseButton setTitle:@"开始" forState:UIControlStateNormal];
    _progressView.progress = 0.5;
}

- (IBAction)startOrPauseButton:(UIButton *)sender {
}
@end
