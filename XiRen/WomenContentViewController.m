//
//  WomenContentViewController.m
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "WomenContentViewController.h"



@interface WomenContentViewController ()

@end

@implementation WomenContentViewController
@synthesize HomeScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    HomeScrollView.backgroundColor = [UIColor whiteColor];
    HomeScrollView.contentSize = CGSizeMake(kDeviceWidth,kDeviceWidth*1.67+KTabarHeight+15);
    HomeScrollView.showsVerticalScrollIndicator=FALSE;
    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
    [self.view addSubview:HomeScrollView];

    UIImageView *AboutUs=[[UIImageView alloc]initWithFrame:CGRectMake(0, KTabarHeight+KNavgationBarHeight, kDeviceWidth, kDeviceWidth*1.67)];
    AboutUs.image=[UIImage imageNamed:@"关于我们-内容.jpg"];
    

    [HomeScrollView addSubview:AboutUs];
    



    
//    [self afnetwork];
}

//#pragma mark - network
//
//
//-(void)afnetwork
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    [manager GET:@"http://www.xiren.com/androidapi.php?action=photoartist" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//     
//     {
//         //         SheyingshiImageArray=[responseObject valueForKey:@"photographer"];
//         //         HuazhuangshiImageArray=[responseObject valueForKey:@"artist"];
//         //         [SheyingshiTable reloadData];
//         //         [HuazhuangshiCollection reloadData];
//         _titleArray=[responseObject valueForKey:@"photographer"];
//         NSDictionary *titleARR=_titleArray[0];
////         NSLog(@"JSON: %@", titleARR);
//         
//         UILabel *myLable2=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, kDeviceWidth, 50)];
//         
//         myLable2.text=[titleARR objectForKey:@"title"];
////         NSLog(@"lable的text%@",[[_titleArray valueForKey:@"title"] class] );
//         myLable2.backgroundColor=[UIColor orangeColor];
//         [self.view addSubview:myLable2];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         
//         NSLog(@"Error: %@", error);
//         
//     }];
//}

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
