//
//  ViewController.m
//  newsDisplay
//
//  Created by 孔维辰 on 2025/5/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"hello world");
    
    // 在UI上显示hello world
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    label.text = @"hello world";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}


@end
