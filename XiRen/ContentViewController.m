//
//  ContentViewController.m
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize webaddress;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    //    [web setScalesPageToFit:YES];
    
    [self.view addSubview:web];
    if (webaddress!=nil) {
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
