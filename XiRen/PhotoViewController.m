//
//  PhotoViewController.m
//  XiRen
//
//  Created by pipi on 15/9/22.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import "PhotoViewController.h"
#import "XirenCoustNav.h"

@interface PhotoViewController ()<WHcrollViewViewDelegate>

{
    WHScrollAndPageView *_whView;
}

@end

@implementation PhotoViewController

@synthesize HomeScrollView;
@synthesize HomeGuanggao;
@synthesize ClothesImageArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //照相馆Navigation
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *navLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
    navLable.text=@"喜人照相馆";
    navLable.textColor=[UIColor whiteColor];
    navLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=navLable;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:251.0f/255.0f green:87.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem=backbutton;
    
    //照相馆大scrollview
    float bili1 = 409.0f/617.0f;
    float ImageWidth1=(kDeviceWidth-5)/2;
    HomeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, KNavgationBarHeight, kDeviceWidth, kDeviceHeight-KTabarHeight-KNavgationBarHeight)];
    HomeScrollView.backgroundColor = [UIColor blackColor];
    HomeScrollView.contentSize = CGSizeMake(kDeviceWidth,kDeviceWidth*0.54+kDeviceWidth*0.26+ImageWidth1*bili1*2+5);
    HomeScrollView.showsVerticalScrollIndicator=FALSE;
    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
    [self.view addSubview:HomeScrollView];
    
    _whView = [[WHScrollAndPageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*0.54)];
    [_whView shouldAutoShow:YES];
    //把图片展示的view加到当前页面
    [HomeScrollView addSubview:_whView];
    [self afnetwork];
    

    
    //首页广告条
    HomeGuanggao=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanggaotiao"]];
    HomeGuanggao.frame=CGRectMake(0, _whView.bottom, kDeviceWidth, kDeviceWidth*0.26);
    HomeGuanggao.contentMode=UIViewContentModeScaleToFill;
    [HomeScrollView addSubview:HomeGuanggao];
    
    
    //首页Button
    float bili = 409.0f/617.0f;
    float ImageWidth=(kDeviceWidth-5)/2;
    
    UIButton *zuixintaocan=[[UIButton alloc]initWithFrame:CGRectMake(0, HomeGuanggao.bottom, ImageWidth, ImageWidth*bili)];
    UIButton *fuzhuangchangjing=[[UIButton alloc]initWithFrame:CGRectMake(zuixintaocan.right+5, HomeGuanggao.bottom, ImageWidth, ImageWidth*bili)];
    UIButton *sheyingtuandui=[[UIButton alloc]initWithFrame:CGRectMake(0, zuixintaocan.bottom+5, ImageWidth, ImageWidth*bili)];
    UIButton *guanyuwomen=[[UIButton alloc]initWithFrame:CGRectMake(sheyingtuandui.right+5, fuzhuangchangjing.bottom+5, ImageWidth, ImageWidth*bili)];
    
    
    [zuixintaocan setBackgroundImage:[UIImage imageNamed:@"zuixintaocanh.jpg"] forState:UIControlStateNormal];
    [fuzhuangchangjing setBackgroundImage:[UIImage imageNamed:@"fuzhuangchangjingh.jpg"] forState:UIControlStateNormal];
    [sheyingtuandui setBackgroundImage:[UIImage imageNamed:@"sheyingtuandui.jpg"] forState:UIControlStateNormal];
    [guanyuwomen setBackgroundImage:[UIImage imageNamed:@"guanyuwomenh.jpg"] forState:UIControlStateNormal];
    
    
    [zuixintaocan addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    [fuzhuangchangjing addTarget:self action:@selector(buttonPress1) forControlEvents:UIControlEventTouchUpInside];
    [sheyingtuandui addTarget:self action:@selector(buttonPress2) forControlEvents:UIControlEventTouchUpInside];
    [guanyuwomen addTarget:self action:@selector(buttonPress3) forControlEvents:UIControlEventTouchUpInside];
    
    
    [HomeScrollView addSubview:zuixintaocan];
    [HomeScrollView addSubview:fuzhuangchangjing];
    [HomeScrollView addSubview:sheyingtuandui];
    [HomeScrollView addSubview:guanyuwomen];
}


#pragma mark - button action
//button点击事件
-(void)buttonPress
{
    TaocanViewController*taocanCtrol =[[TaocanViewController alloc]init];
    [self.navigationController pushViewController:taocanCtrol animated:YES];
}

-(void)buttonPress1
{
    FuzhuangViewController *fuzhuangCtrol=[[FuzhuangViewController alloc]init];
    [self.navigationController pushViewController:fuzhuangCtrol animated:YES];
}

-(void)buttonPress2
{
    SheyingViewController *sheyingCtrol=[[SheyingViewController alloc]init];
    [self.navigationController pushViewController:sheyingCtrol animated:YES];
}

-(void)buttonPress3
{
    WomenViewController *womenCtrol=[[WomenViewController alloc]init];
    [self.navigationController pushViewController:womenCtrol animated:YES];
}
#pragma mark 协议里面方法，点击某一页
-(void)didClickPage:(WHScrollAndPageView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击了第%li页",index);
}

#pragma mark 界面消失的时候，停止自动滚动
-(void)viewDidDisappear:(BOOL)animated
{
//    [_whView shouldAutoShow:NO];
}

#pragma mark - network
-(void)afnetwork
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://www.xiren.com/api.php?action=listapi" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         ClothesImageArray=[responseObject valueForKey:@"data"];
         
;
         
         

         NSMutableArray *imageViews = [[NSMutableArray alloc] initWithCapacity:[ClothesImageArray count]];
         for(int i = 0; i < [ClothesImageArray count]; i++){
             NSDictionary *dict = ClothesImageArray[i];
             NSString *urlStr = dict[@"image"];
             UIImageView *imageView = [[UIImageView alloc]init];
             [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
             [imageViews addObject:imageView];
         }
         //把imageView数组存到whView里
         [_whView setImageViewAry:imageViews];
         
         //把图片展示的view加到当前页面
         [HomeScrollView addSubview:_whView];
         
         //开启自动翻页
         [_whView shouldAutoShow:YES];
         
         //遵守协议
         _whView.delegate = self;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"Error: %@", error);
         
     }];
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
