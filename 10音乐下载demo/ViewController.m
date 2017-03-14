//
//  ViewController.m
//  10音乐下载demo
//
//  Created by HM09 on 17/3/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "ViewController.h"
#import "MusicCell.h"
#import "YYModel.h"
#import "MusicModel.h"
#import "AudioDownLoadTool.h"

static NSString *identifier = @"musicCell";

@interface ViewController ()<UITableViewDataSource,MusicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasourceArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据源数组
    _datasourceArr = [NSMutableArray array];
    
    //设置controller不自动调整scrollView的contentInsets
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置tableView
    [_tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.rowHeight = 100;
    
    //开始加载音乐
    [self loadMusic];
}


/**
 加载音乐列表
 */
- (void) loadMusic {
    
    //发起网络请求, 获取音乐的列表数据
    NSURL *url = [NSURL URLWithString:@"http://42.62.15.100/yyting/snsresource/getAblumnAudios.action?ablumnId=2719&imei=RkVGNzBFMkYtNjc2QS00NkQwLUEwOTYtNUU5Q0QyOUVGMzdE&nwt=1&q=50506&sc=1438f6d61a2907bfa8b3ea0973474ac1&sortType=1&token=j5xm1WPkdnI-uxtFXlv6CsWiNfwjfQYPQb63ToXOFc8%2A"];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        //json解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *musicDicArr = dic[@"list"];
        
        //字典数组转模型数组
        _datasourceArr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[MusicModel class] json:musicDicArr];
        
        //主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    }] resume];
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasourceArr.count;
}

- (MusicCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //给cell设置model
    cell.delegate = self;
    MusicModel *model = _datasourceArr[indexPath.row];
    cell.model = model;
    
    return  cell;
}

- (void)startorPause:(MusicCell *)cell{
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    //获取当前要下载的url
    MusicModel *model = cell.model;
    NSURL *url = [NSURL URLWithString:model.path];
    if( ![[AudioDownLoadTool shareTool] isDownloading:url]){
        [[AudioDownLoadTool shareTool] startTaskWithUrl:url progress:^(float progress) {
            //更新当前MODEL
            model.isDownLoading = YES;
            
            MusicCell *cell = [_tableView cellForRowAtIndexPath:path];
            cell.progressView.progress = progress;
            [cell.startOrPauseButton setTitle:@"暂停" forState:UIControlStateNormal];
            
        } completion:^(BOOL isfinish) {
            model.isFinish = YES;
            cell.startOrPauseButton.enabled = false;
        }];
    }else{
        [[AudioDownLoadTool shareTool] pauseWithUrl:url];
        model.isDownLoading = NO;
        
        MusicCell *cell = [_tableView cellForRowAtIndexPath:path];
        [cell.startOrPauseButton setTitle:@"开始" forState:UIControlStateNormal];
    }
}


@end
