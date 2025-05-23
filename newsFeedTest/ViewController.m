//
//  ViewController.m
//  newsDisplay
//
//  Created by 孔维辰 on 2025/5/21.
//

#import "ViewController.h"
#import "NewsDataItem.h"
#import "NewsTableViewCell.h"
#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImage.h>
#import <UIKit/UIKit.h>
#define newsDataSrcURL "https://ranks.hao.360.com/mbsug-api/hotnewsquery?type=news&realhot_limit=15"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsItems;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UITabBar *tabBar;
@property (nonatomic, strong) UITabBarItem *tabBarItem;
@property (nonatomic, strong) UIView *tabBarView;
@end

@implementation ViewController
- (int)getNewsData
{
    NSLog(@"Begin to fetch news data");
    char *cStringURL = newsDataSrcURL;
    NSString *urlString = [NSString stringWithUTF8String:cStringURL];
    NSURL *nsNewsDataSrcURL = [NSURL URLWithString:urlString];
    if (!nsNewsDataSrcURL)
    {
        NSLog(@"Error: Invalid URL");
        return 1;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task =
        [session dataTaskWithURL:nsNewsDataSrcURL
               completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response,
                                   NSError *_Nullable error) {
                   if (error)
                   {
                       NSLog(@"请求失败: %@", error.localizedDescription);
                       return;
                   }
                   NSError *jsonError;
                   NSArray *newsDataJson = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0
                                                                             error:&jsonError];
                   if (jsonError)
                   {
                       NSLog(@"JSON 解析失败: %@", jsonError.localizedDescription);
                   }
                   else
                   {
                       self.newsItems = [NSMutableArray arrayWithArray:newsDataJson];
                       // 更新UI
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self.tableView reloadData];
                       });
                   }
               }];
    [task resume];
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsItems = [NSMutableArray array]; // 初始化 newsItems 数组
    NSInteger res = [self getNewsData];
    if (res)
    {
        NSLog(@"Error: Failed to fetch news data");
        return;
    }
    // 实例化tableview
    CGRect screenBounds = self.view.bounds;
    CGFloat tabBarHeight = 0;
    CGRect tableViewFrame =
        CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height - tabBarHeight);
    // 设置tabbar的遮罩
    // UIView *tabBarMaskView = [[UIView alloc] initWithFrame:screenBounds];
    // tabBarMaskView.backgroundColor = [UIColor whiteColor];
    // tabBarMaskView.alpha = 0.5; // 设置遮罩透明度
    // [self.view addSubview:tabBarMaskView];
    // 设置tableview的frame
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame
                                                  style:UITableViewStyleGrouped];

    // 放置TabBar在底部
    // CGRect tabBarFrame = CGRectMake(0, screenBounds.size.height - tabBarHeight,
    //                                 screenBounds.size.width, tabBarHeight);
    // self.tabBar = [[UITabBar alloc] initWithFrame:tabBarFrame];
    // self.tabBar.backgroundColor = [UIColor whiteColor]; // 设置背景色

    // 创建TabBar项目
    // UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"首页"
    //                                                        image:[UIImage
    //                                                        systemImageNamed:@"house"]
    //                                                          tag:0];
    // UITabBarItem *settingsItem =
    //     [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage systemImageNamed:@"gear"]
    //     tag:1];

    // 添加TabBar项目
    // [self.tabBar setItems:@[ homeItem, settingsItem ] animated:NO];
    // self.tabBar.selectedItem = homeItem; // 设置选中项

    self.testButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.testButton setTitle:@"点击我" forState:UIControlStateNormal];
    [self.testButton addTarget:self
                        action:@selector(buttonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    self.testButton.frame = CGRectMake(100, 100, 100, 50);

    // 设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tabBar.delegate = self;

    // 添加到视图
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.testButton];
    // [self.view addSubview:self.tabBar];

    // 添加日志确认视图已加载
    NSLog(@"视图尺寸: %@", NSStringFromCGRect(self.view.bounds));
}
// 按钮点击事件
- (void)buttonClicked:(UIButton *)sender
{
    NSLog(@"按钮被点击了");
    [self.testButton removeFromSuperview];
    // 随机Button位置
    CGFloat x = arc4random_uniform(self.view.bounds.size.width - 100);
    CGFloat y = arc4random_uniform(self.view.bounds.size.height - 50);
    self.testButton.frame = CGRectMake(x, y, 100, 50);
    [self.view addSubview:self.testButton];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置固定的行高
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsItems.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"今日热点";
    }
    else
    {
        return @"Not Implemented";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*{"img_url":"","news_url":"None","status":"3","long_title":"","rank":"1","url":"https:\/\/www.so.com\/s?q=%E5%B9%BF%E8%A5%BF%E5%AE%A3%E5%B8%83%E5%80%92%E6%9F%A5%E5%8D%81%E5%B9%B4&src=know_side_nlp_sohot&tn=news","newscard_imgurl":"https:\/\/p3.qhimg.com\/t11508c75c8e8953ba680b01569.jpg?size=547x313","index":"881187","murl":"","face":"","brieftxt":"广西壮族自治区党委书记陈刚在会上提到，对非法采矿和涉重金属污染问题开展倒查十年专项行动。","rise":"1","hot_src":"human","ifnew":"0","title":"广西宣布倒查十年","updateTime":"2025-05-22
     * 09:22:18","recordTime":"2025-05-22
     * 11:04:07","keyword":"广西宣布倒查十年","score":"881187","sumtxt":"广西壮族自治区党委书记陈刚在会上提到，对非法采矿和涉重金属污染问题开展倒查十年专项行动。","category":"办公"},
     */
    static NSString *CellIdentifier = @"NewsCellIdentifier";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < self.newsItems.count)
    {
        NSDictionary *newsItem = self.newsItems[indexPath.row];
        NSString *title;
        NSString *brieftxt;
        NSString *newscard_imgurl;
        @try
        {
            title = newsItem[@"title"];
            brieftxt = newsItem[@"brieftxt"];
            newscard_imgurl = newsItem[@"newscard_imgurl"];
        }
        @catch (NSException *exception)
        {
            NSLog(@"数据解析错误: %@", exception.reason);
            cell.titleLabel.text = @"数据错误";
            return cell;
        }
        if ([title isKindOfClass:[NSString class]] && [brieftxt isKindOfClass:[NSString class]])
        {
            cell.titleLabel.text = ![title isEqualToString:@""] ? title : @"未获取到内容";
            cell.detailLabel.text = ![brieftxt isEqualToString:@""] ? brieftxt : @"未获取到内容";
        }
        else
        {
            cell.titleLabel.text = @"无效标题";
        }
        // 构造图片URL
        NSURL *imgURL = [NSURL URLWithString:newscard_imgurl];

        // 占位图
        // UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
        UIImage *placeholder = [UIImage systemImageNamed:@"photo"]; // iOS 13+

        // 调用 SDWebImage 加载图片
        [cell.newsImageView sd_setImageWithURL:imgURL placeholderImage:placeholder];
    }
    else
    {
        cell.titleLabel.text = @"数据错误";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用indexPath得到用户点击的行序号
    NSInteger index = indexPath.row;
    NSDictionary *selectedNews = [_newsItems objectAtIndex:index];
    NSLog(@"点击了第 %ld 行: %@", (long)index, selectedNews[@"title"]);
    // 获取新闻的URL
    NSString *newsURL = selectedNews[@"url"];
    // 检查URL是否有效
    if (!newsURL || [newsURL isEqualToString:@""])
    {
        NSLog(@"无效的新闻URL");
        return;
    }
    // 打开新闻链接
    NSURL *nsNewsURL = [NSURL URLWithString:newsURL];
    if (nsNewsURL)
    {
        [[UIApplication sharedApplication] openURL:nsNewsURL
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                     if (success)
                                     {
                                         NSLog(@"URL 成功打开: %@", newsURL);
                                     }
                                     else
                                     {
                                         NSLog(@"无法打开 URL: %@", newsURL);
                                     }
                                 }];
    }
    else
    {
        NSLog(@"无效的新闻跳转URL");
    }
    // 将行重置为未点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
