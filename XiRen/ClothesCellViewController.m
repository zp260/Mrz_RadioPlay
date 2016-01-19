//
//  ClothesCellViewController.m
//  XirenPhoto
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "ClothesCellViewController.h"
#import "UIView+Extension.h"

@interface ClothesCellViewController ()


@end

@implementation ClothesCellViewController
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



//jason转数组
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
