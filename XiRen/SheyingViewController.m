//
//  SheyingViewController.m
//  XirenPhoto
//
//  Created by mac on 15/11/15.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "SheyingViewController.h"

@interface SheyingViewController ()

@end

@implementation SheyingViewController
@synthesize HomeTab;
- (void)viewDidLoad {
    [super viewDidLoad];
    //Navi
    UILabel *navLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
    navLable.text=@"摄影/化妆";
    navLable.textColor=[UIColor whiteColor];
    navLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=navLable;

    
    //Tabbarcontroller
    HomeTab=[[UITabBarController alloc]init];
    HomeTab.tabBar.frame=CGRectMake(0, KNavgationBarHeight, kDeviceWidth, KTabarHeight);
    HomeTab.tabBar.tintColor=[UIColor colorWithRed:251.0f/255.0f green:87.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    
    //Tabbar页面1
    TaocanContentViewController *HomeView1=[[TaocanContentViewController alloc]init];
    HomeView1.tabBarItem.image=[UIImage imageNamed:@"最新套餐"];
    HomeView1.tabBarItem.title=@"最新套餐";
    
    UINavigationController *HomeNav1=[[UINavigationController alloc]initWithRootViewController:HomeView1];
    
    
    
    //Tabbar页面2
    FuzhuangContentViewController *HomeView2=[[FuzhuangContentViewController alloc]init];
    HomeView2.tabBarItem.image=[UIImage imageNamed:@"fuzhuang"];
    HomeView2.tabBarItem.title=@"服装/场景";
    
    UINavigationController *HomeNav2=[[UINavigationController alloc]initWithRootViewController:HomeView2];
    
    //Tabbar页面3
    SheyingContentViewController *HomeView3=[[SheyingContentViewController alloc]init];
    HomeView3.tabBarItem.image=[UIImage imageNamed:@"sheying"];
    HomeView3.tabBarItem.title=@"摄影/化妆";
    
    UINavigationController *HomeNav3=[[UINavigationController alloc]initWithRootViewController:HomeView3];
    
    //Tabbar页面4
    WomenContentViewController *HomeView4=[[WomenContentViewController alloc]init];
    HomeView4.tabBarItem.image=[UIImage imageNamed:@"guanyuwomen"];
    HomeView4.tabBarItem.title=@"关于我们";
    
    UINavigationController *HomeNav4=[[UINavigationController alloc]initWithRootViewController:HomeView4];
    //添加view到Tabbar
    HomeTab.viewControllers=[NSArray arrayWithObjects:HomeNav1,HomeNav2,HomeNav3,HomeNav4, nil];
    
    HomeTab.selectedIndex=2;
    
    [self.view addSubview:HomeTab.view];
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
