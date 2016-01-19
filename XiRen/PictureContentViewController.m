//
//  PictureContentViewController.m
//  XirenPhoto
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "PictureContentViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

@interface PictureContentViewController ()

@end

@implementation PictureContentViewController
@synthesize webaddress;
@synthesize web;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *navLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
    navLable.text=@"摄影师";
    navLable.textColor=[UIColor whiteColor];
    navLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=navLable;
    
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    [self.navigationItem setBackBarButtonItem:backbutton];

    
    web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    //    [web setScalesPageToFit:YES];
    
    [self.view addSubview:web];
    if (webaddress!=nil) {
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:webaddress]];
        [web loadRequest:request];
    }
}

- (void)back {
    [self.web goBack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
