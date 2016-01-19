//
//  CarWebViewController.m
//  XiRen
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import "CarWebViewController.h"

@interface CarWebViewController ()

@end

@implementation CarWebViewController
@synthesize webaddress;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *navLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
    navLable.text=@"喜人网";
    navLable.textColor=[UIColor whiteColor];
    navLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=navLable;
    
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    //    [web setScalesPageToFit:YES];
    
    [self.view addSubview:web];
    if (webaddress!=nil) {
        webaddress = [webaddress stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:webaddress]];
        
        [web loadRequest:request];
    }

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
