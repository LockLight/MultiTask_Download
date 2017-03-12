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
static NSString *identifier = @"musicCell";

@interface ViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasourceArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasourceArr = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.rowHeight = 100;
    
    [self loadMusic];
}


/**
 加载音乐列表
 */
- (void) loadMusic {
    NSURL *url = [NSURL URLWithString:@"http://42.62.15.100/yyting/snsresource/getAblumnAudios.action?ablumnId=2719&imei=RkVGNzBFMkYtNjc2QS00NkQwLUEwOTYtNUU5Q0QyOUVGMzdE&nwt=1&q=50506&sc=1438f6d61a2907bfa8b3ea0973474ac1&sortType=1&token=j5xm1WPkdnI-uxtFXlv6CsWiNfwjfQYPQb63ToXOFc8%2A"];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *musicDicArr = dic[@"list"];
        
        _datasourceArr = [NSArray yy_modelArrayWithClass:[MusicModel class] json:musicDicArr];
        
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
    MusicModel *model = _datasourceArr[indexPath.row];
    cell.model = model;
    return  cell;
}


@end
