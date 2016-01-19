//
//  CarClubViewController.m
//  XiRen
//
//  Created by mac on 15/12/10.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import "CarClubViewController.h"
#import "WebViewController.h"
#include "XirenCoustNav.h"
#include "MBProgressHUD.h"
#include "WeiZhangViewController.h"

#import "LoadingImageview.h"
#import "CarWebViewController.h"
@interface CarClubViewController ()<WHcrollViewViewDelegate>
{
    WHScrollAndPageView *_whView;
}

@property (strong,nonatomic) WebViewController *webCrtrol;
@property (strong,nonatomic) XirenCoustNav *CousterNav;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic,strong) UISegmentedControl *segmentedCtrol;
@property (nonatomic,strong) NSMutableArray *assessmentArray;
@property (nonatomic,strong) NSArray *ContentArray;
@property (nonatomic,strong) UIView *WeiZhangBG;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) UILabel *WzCount;
@property (strong,nonatomic) UITextField *ChePaiHao;//车牌号
@property (strong,nonatomic) UITextField *FadongjiText;//大架号
@property (strong,nonatomic) NSUserDefaults *userDefaults;
@property (strong,nonatomic) WeiZhangViewController *weizhang;

@end

@implementation CarClubViewController
@synthesize WeiZhangBG;
@synthesize CousterNav;
@synthesize segmentedCtrol;
@synthesize carView1;
@synthesize carView2;
@synthesize carView3;
@synthesize carView4;
@synthesize LunboImageArray;
@synthesize HuodongImageArray;
@synthesize ShangjiaArray;
@synthesize ContentArray;
@synthesize carTable;
@synthesize shopTable;
@synthesize weizhangTable;
@synthesize lodingIMG;
@synthesize HomeScrollView;
@synthesize userDefaults;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载动画
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    
    CousterNav = [[XirenCoustNav alloc]init];
    [CousterNav initXirenNav:self TitleView:nil WithTitle:@"喜人网"];
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem=backbutton;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self afnetwork];
    //栏目导航
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"最新",@"商家优惠",@"加入车友会",@"违章查询", nil];
    segmentedCtrol= [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedCtrol.frame = CGRectMake(0, KNavgationBarHeight, kDeviceWidth, 25);
    segmentedCtrol.tintColor = [UIColor clearColor];
    segmentedCtrol.selectedSegmentIndex=0;
    segmentedCtrol.layer.cornerRadius=1;
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName, nil];
    [segmentedCtrol setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName: [CousterNav getNavTintColor]};
    
    [segmentedCtrol setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//第一页面
    carView1=[[UIView alloc]initWithFrame:CGRectMake(0, segmentedCtrol.bottom, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight)];
    
    _whView = [[WHScrollAndPageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*0.54)];
    [_whView shouldAutoShow:YES];
    [carView1 addSubview:_whView];
    self.carView1.hidden=NO;
    
    //title
    UIImageView *Dot=[[UIImageView alloc]initWithFrame:CGRectMake(0, _whView.bottom+5, 8, 8*2.5)];
    Dot.image=[UIImage imageNamed:@"orange"];
    [carView1 addSubview:Dot];
    
    UILabel *New=[[UILabel alloc]initWithFrame:CGRectMake(Dot.right, _whView.bottom+8, 70, Dot.height-5)];
    New.text=@"最新活动";
    [carView1 addSubview:New];
    
    //最新table
    carTable=[[UITableView alloc]initWithFrame:CGRectMake(0,Dot.bottom+5, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-_whView.height)];
    carTable.backgroundColor=[UIColor whiteColor];
    carTable.dataSource=self;
    carTable.delegate=self;
    carTable.separatorStyle=UITableViewCellSelectionStyleNone;//去掉分割线
    [carView1 addSubview:carTable];
    
//第二页面
    carView2=[[UIView alloc]initWithFrame:CGRectMake(0, segmentedCtrol.bottom, kDeviceWidth, kDeviceHeight-KNavgationBarHeight)];
    carView2.hidden=YES;
    //最新table
    shopTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-12)];
    shopTable.backgroundColor=[UIColor whiteColor];
    shopTable.dataSource=self;
    shopTable.delegate=self;
//    shopTable.separatorStyle=UITableViewCellSelectionStyleNone;//去掉分割线
    [carView2 addSubview:shopTable];

    
//三页面
    carView3=[[UIView alloc]initWithFrame:CGRectMake(0, segmentedCtrol.bottom, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight)];
    carView3.hidden=YES;
    
    //车友会图片
    UIImageView *carClub=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight)];
    carClub.image=[UIImage imageNamed:@"加入车友会内容.jpg"];
    
    //车友会scrollview
    HomeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-KTabarHeight-KNavgationBarHeight)];
    HomeScrollView.backgroundColor = [UIColor blackColor];
    HomeScrollView.contentSize = CGSizeMake(kDeviceWidth,carClub.height+20);
    HomeScrollView.showsVerticalScrollIndicator=FALSE;
    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
    [HomeScrollView addSubview:carClub];
    [carView3 addSubview:HomeScrollView];
    
    
    [self makeWeiZhangFrame];
//第四页面
    carView4=[[UIView alloc]initWithFrame:CGRectMake(0, segmentedCtrol.bottom, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight)];
    carView4.hidden=YES;
    //违章table
    weizhangTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-12)];
    weizhangTable.backgroundColor=[UIColor whiteColor];
    weizhangTable.dataSource=self;
    weizhangTable.delegate=self;
    [weizhangTable setTableHeaderView:WeiZhangBG];
    
    [carView4 addSubview:weizhangTable];
    
    [self.view addSubview:carView1];
    [self.view addSubview:carView2];
    [self.view addSubview:carView3];
    [self.view addSubview:carView4];
    //设置分段控件点击相应事件
    [segmentedCtrol addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrol];


    
//    [self tapBackground];
    
}

#pragma mark - tableview delegate
//cell数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(segmentedCtrol.selectedSegmentIndex ==0)
    {
        return HuodongImageArray.count;
    }
    else if (segmentedCtrol.selectedSegmentIndex==1)
    {
        return ShangjiaArray.count;
    }
    else if (segmentedCtrol.selectedSegmentIndex==2)
    {
        return 0;
    }
    else
    {
        return WeizhangArray.count;
    }
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(segmentedCtrol.selectedSegmentIndex ==0)
    {
        return (kDeviceWidth-20)*0.6+10;
    }
    else if (segmentedCtrol.selectedSegmentIndex==2)
    {
        return 0;
    }
    else if (segmentedCtrol.selectedSegmentIndex==3)
    {
        return 200;
    }
    else
    {
        return 100;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentListIdentifier= @"WildContentLIST";
    UITableViewCell *TaocanCell=[tableView dequeueReusableCellWithIdentifier:contentListIdentifier];
    if (TaocanCell ==nil)
    {
        TaocanCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentListIdentifier];
    }
    else
    {
        //删除cell中的子对象
        while([TaocanCell.contentView.subviews lastObject]!=nil)
        {
            [(UIView *)[TaocanCell.contentView.subviews lastObject] removeFromSuperview];
            
            
        }
        
    }
    TaocanCell.accessoryType=UITableViewCellAccessoryNone;//cell无色
    TaocanCell.backgroundColor=[UIColor clearColor];
    TaocanCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (segmentedCtrol.selectedSegmentIndex==0) {
        //摄影作品
        UIImageView *cellImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0,kDeviceWidth-20, (kDeviceWidth-20)*0.6)];
        [cellImage sd_setImageWithURL:[[HuodongImageArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
        
        
        [TaocanCell.contentView addSubview:cellImage];
    }
    else if (segmentedCtrol.selectedSegmentIndex==1)
    {
        UIImageView *shopImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 100, 100
                                                                            *0.73)];
        [shopImage sd_setImageWithURL:[[ShangjiaArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
        
        [TaocanCell.contentView addSubview:shopImage];
        
        UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(shopImage.right+8, shopImage.top+3, kDeviceWidth-shopImage.width-50, 10)];
        titleLable.numberOfLines=0;
        titleLable.lineBreakMode=NSLineBreakByWordWrapping;
        titleLable.text=[[ShangjiaArray objectAtIndex:indexPath.row]valueForKey:@"shangjia"];
        CGSize titlesize=[titleLable sizeThatFits:CGSizeMake(titleLable.width, MAXFLOAT)];
        titleLable.frame=CGRectMake(shopImage.right+8, shopImage.top+3, kDeviceWidth-shopImage.width-50, titlesize.height);
        [TaocanCell.contentView addSubview:titleLable];
        
        UILabel *addressLable=[[UILabel alloc]initWithFrame:CGRectMake(titleLable.left, shopImage.bottom-13, titleLable.width, 10)];
        addressLable.font = [UIFont systemFontOfSize:12];
        addressLable.textColor=[UIColor grayColor];
        titleLable.numberOfLines=0;
        titleLable.lineBreakMode=NSLineBreakByWordWrapping;
        addressLable.text=[[ShangjiaArray objectAtIndex:indexPath.row]valueForKey:@"address"];
        CGSize addsize=[addressLable sizeThatFits:CGSizeMake(titleLable.width, MAXFLOAT)];
        addressLable.frame=CGRectMake(titleLable.left, shopImage.bottom-13, titleLable.width, addsize.height);
        [TaocanCell.contentView addSubview:addressLable];
    }
    else if (segmentedCtrol.selectedSegmentIndex==3)
    {
        UILabel *titleLable=[[UILabel alloc]init];
        titleLable.numberOfLines=0;
        titleLable.lineBreakMode=NSLineBreakByWordWrapping;
        titleLable.text= @"违章地点：";
        CGSize titlesize=[titleLable sizeThatFits:CGSizeMake(titleLable.width, MAXFLOAT)];
        titleLable.frame=CGRectMake(10, 0, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:titleLable];
        
        UILabel *AddressLable=[[UILabel alloc]init];
        AddressLable.numberOfLines=0;
        AddressLable.lineBreakMode=NSLineBreakByWordWrapping;
        AddressLable.text= [[WeizhangArray objectAtIndex:indexPath.row]valueForKey:@"address"];
//        CGSize titlesize=[titleLable sizeThatFits:CGSizeMake(titleLable.width, MAXFLOAT)];
        AddressLable.frame=CGRectMake(10,titleLable.bottom+2, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:AddressLable];
        
        UILabel *AgencyLable=[[UILabel alloc]init];
        AgencyLable.numberOfLines=0;
        AgencyLable.lineBreakMode=NSLineBreakByWordWrapping;
        AgencyLable.text= @"罚款机构：";
        AgencyLable.frame=CGRectMake(10, AddressLable.bottom+2, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:AgencyLable];
        
        UILabel *AgencyContentLable=[[UILabel alloc]init];
        AgencyContentLable.numberOfLines=0;
        AgencyContentLable.lineBreakMode=NSLineBreakByWordWrapping;
        AgencyContentLable.text= [[WeizhangArray objectAtIndex:indexPath.row]valueForKey:@"agency"];
        AgencyContentLable.frame=CGRectMake(10,AgencyLable.bottom+2, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:AgencyContentLable];
        
        UILabel *FineLable=[[UILabel alloc]init];
        FineLable.numberOfLines=0;
        FineLable.lineBreakMode=NSLineBreakByWordWrapping;
        FineLable.text= @"罚款金额：";
        FineLable.frame=CGRectMake(10, AgencyContentLable.bottom+2, 90, titlesize.height);
        [TaocanCell.contentView addSubview:FineLable];
        
        UILabel *FineContentLable=[[UILabel alloc]init];
        FineContentLable.numberOfLines=0;
        FineContentLable.lineBreakMode=NSLineBreakByWordWrapping;
        FineContentLable.text= [NSString stringWithFormat:@"%@",[[WeizhangArray objectAtIndex:indexPath.row]valueForKey:@"fine"]];;
        FineContentLable.frame=CGRectMake(FineLable.right+5,FineLable.top, kDeviceWidth-FineLable.width, titlesize.height);
        [TaocanCell.contentView addSubview:FineContentLable];
        
        UILabel *PointLable=[[UILabel alloc]init];
        PointLable.numberOfLines=0;
        PointLable.lineBreakMode=NSLineBreakByWordWrapping;
        PointLable.text= @"扣分：";
        PointLable.frame=CGRectMake(10, FineLable.bottom+2, 60, titlesize.height);
        [TaocanCell.contentView addSubview:PointLable];
        
        UILabel *PointContentLable=[[UILabel alloc]init];
        PointContentLable.numberOfLines=0;
        PointContentLable.lineBreakMode=NSLineBreakByWordWrapping;
        PointContentLable.text= [[WeizhangArray objectAtIndex:indexPath.row]valueForKey:@"point"];
        PointContentLable.frame=CGRectMake(PointLable.right+5,PointLable.top, kDeviceWidth-PointLable.width, titlesize.height);
        [TaocanCell.contentView addSubview:PointContentLable];
        
        UILabel *DateLable=[[UILabel alloc]init];
        DateLable.numberOfLines=0;
        DateLable.lineBreakMode=NSLineBreakByWordWrapping;
        DateLable.text= [[WeizhangArray objectAtIndex:indexPath.row]valueForKey:@"time"];
        DateLable.frame=CGRectMake(10,PointContentLable.bottom+2, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:DateLable];
        
        UILabel *ReasonLable=[[UILabel alloc]init];
        ReasonLable.numberOfLines=0;
        ReasonLable.lineBreakMode=NSLineBreakByWordWrapping;
        ReasonLable.text= @"罚款原因：";
        ReasonLable.frame=CGRectMake(10, DateLable.bottom+2, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:ReasonLable];
        
        UILabel *ReasonContentLable=[[UILabel alloc]init];
        ReasonContentLable.numberOfLines=0;
        ReasonContentLable.lineBreakMode=NSLineBreakByWordWrapping;
        ReasonContentLable.text= [[WeizhangArray objectAtIndex:indexPath.row]valueForKey:@"violation_type"];
        ReasonContentLable.frame=CGRectMake(10,ReasonLable.bottom+2, kDeviceWidth, titlesize.height);
        [TaocanCell.contentView addSubview:ReasonContentLable];
    }
    
    
    return TaocanCell;
}
//table点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentedCtrol.selectedSegmentIndex==0) {
        CarWebViewController *pushContent=[[CarWebViewController alloc]init];
        pushContent.webaddress=[[HuodongImageArray objectAtIndex:indexPath.row]valueForKey:@"url"];
        pushContent.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pushContent animated:YES];
    }
    else if (segmentedCtrol.selectedSegmentIndex==1)
    {
        CarWebViewController *pushShop=[[CarWebViewController alloc]init];
        pushShop.webaddress=[[ShangjiaArray objectAtIndex:indexPath.row]valueForKey:@"url"];
        pushShop.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pushShop animated:YES];
    }
}




#pragma mark 协议里面方法，点击某一页
-(void)didClickPage:(WHScrollAndPageView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击了第%li页",index);
    index = index-1;
    CarWebViewController *pushShop=[[CarWebViewController alloc]init];
    pushShop.webaddress=[[LunboImageArray objectAtIndex:index]valueForKey:@"url"];
    NSLog(@"%@",[[LunboImageArray objectAtIndex:index]valueForKey:@"url"]);

    pushShop.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushShop animated:YES];
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
    
    [manager GET:@"http://www.xiren.com/androidapi.php?action=carfriendapi" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         LunboImageArray=[responseObject valueForKey:@"friend-tui"];
         HuodongImageArray=[responseObject valueForKey:@"friend-activity"];
         ShangjiaArray=[responseObject valueForKey:@"friend-shangjia"];
         [carTable reloadData];

//                  [self carTable:ClothesImageArray];
         
         
         //         NSLog(@"JSON: %@", [responseObject valueForKey:@"data"]);
                  NSLog(@"%@",HuodongImageArray);
         NSMutableArray *imageViews = [[NSMutableArray alloc] initWithCapacity:[LunboImageArray count]];
         for(int i = 0; i < [LunboImageArray count]; i++){
             NSDictionary *dict = LunboImageArray[i];
             NSString *urlStr = dict[@"image"];
             UIImageView *imageView = [[UIImageView alloc]init];
             [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
             [imageViews addObject:imageView];
         }
         //把imageView数组存到whView里
         [_whView setImageViewAry:imageViews];
         
         //把图片展示的view加到当前页面
//         [carView1 addSubview:_whView];
         
         //开启自动翻页
         [_whView shouldAutoShow:YES];
         
         //遵守协议
         _whView.delegate = self;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"Error: %@", error);
         
     }];
}

//segmentControl方法
- (void)segmentClick:(id)sender
{
    switch (self.segmentedCtrol.selectedSegmentIndex)
    {
        case 0:
            self.carView1.hidden =NO;
            self.carView2.hidden= YES;
            self.carView3.hidden= YES;
            self.carView4.hidden= YES;
            //            segmentControl.backgroundColor = [UIColor orangeColor];
            
            
            break;
        case 1:
            self.carView1.hidden =YES;
            self.carView2.hidden= NO;
            self.carView3.hidden= YES;
            self.carView4.hidden= YES;
            [shopTable reloadData];
            break;
        case 2:
            self.carView1.hidden =YES;
            self.carView2.hidden= YES;
            self.carView3.hidden= NO;
            self.carView4.hidden= YES;
            
            break;
        case 3:
            self.carView1.hidden =YES;
            self.carView2.hidden= YES;
            self.carView3.hidden= YES;
            self.carView4.hidden= NO;
            [weizhangTable reloadData];
            
            break;
        default:
            break;
    }
}
-(void)makeWeiZhangFrame
{
    WeiZhangBG= [[UIView alloc]init];
    WeiZhangBG.frame=CGRectMake(0, 0, kDeviceWidth, 150);
    WeiZhangBG.backgroundColor=[UIColor clearColor];
    
    UILabel *ChePaiLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
    ChePaiLable.text = @"车牌号码:";
    ChePaiLable.textColor = [UIColor grayColor];
    UILabel *JinB = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 25, 20)];
    JinB.text= @"晋";
    JinB.textAlignment = NSTextAlignmentCenter;
    JinB.textColor = [UIColor grayColor];
    JinB.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:251.0f/255.0f];
    _ChePaiHao = [[UITextField alloc]initWithFrame:CGRectMake(155, 10, kDeviceWidth-135, 20)];
    _ChePaiHao.placeholder = @"请输入车牌号";
    _ChePaiHao.borderStyle = UITextBorderStyleNone;
    
    UILabel *line =[[UILabel alloc]initWithFrame:CGRectMake(10, 35, kDeviceWidth-20, 0.5f)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    
    UILabel *FaDongJiHao = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 120, 20)];
    FaDongJiHao.text = @"大架号后6位:";
    FaDongJiHao.textColor = [UIColor grayColor];
    
    _FadongjiText = [[UITextField alloc]initWithFrame:CGRectMake(155, 40, kDeviceWidth-135, 20)];
    _FadongjiText.placeholder= @"请输入发动机号";
    
    UIButton *SubmitBT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [SubmitBT setTintColor:[UIColor whiteColor]];
    SubmitBT.backgroundColor = [CousterNav getNavTintColor];
    SubmitBT.frame = CGRectMake(10, 70, kDeviceWidth-20, 40);
    [SubmitBT setTitle:@"查询" forState:UIControlStateNormal];
    SubmitBT.titleLabel.textColor= [UIColor whiteColor];
    [SubmitBT addTarget:self action:@selector(DoCheck) forControlEvents:UIControlEventTouchUpInside];
    
    _WzCount = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, kDeviceWidth-20, 20)];//违章总数量
    _WzCount.textColor  = [CousterNav getNavTintColor];
    _WzCount.textAlignment = NSTextAlignmentCenter;
    
    [WeiZhangBG addSubview:ChePaiLable];
    [WeiZhangBG addSubview:JinB];
    [WeiZhangBG addSubview:_ChePaiHao];
    [WeiZhangBG addSubview:FaDongJiHao];
    [WeiZhangBG addSubview:_FadongjiText];
    [WeiZhangBG addSubview:SubmitBT];
    [WeiZhangBG addSubview:line];
    [WeiZhangBG addSubview:_WzCount];
    
    [self readNSUserDefaults];
}
#pragma mark-查询违章
-(void)DoCheck
{
    
    
    NSString *PostUrl = @"http://light.weiche.me/front/do-index.php";
    _weizhang= [[WeiZhangViewController alloc]init];
    [_weizhang initCtrol];
    if (_ChePaiHao.text && _FadongjiText.text)
    {
        [_weizhang MakeParameters:_ChePaiHao.text FaDongJi:_FadongjiText.text];
        [_weizhang AFgetOLdata:PostUrl target:self selector:@selector(MakeTableListData:)];
        [self saveNSUserDefaults];
        [self.ChePaiHao resignFirstResponder];
        [self.FadongjiText resignFirstResponder];
    }
    
    
}
-(void)MakeTableListData:(NSArray *)data
{
    WeizhangArray = [[NSArray alloc]initWithArray:data];
    [weizhangTable reloadData];
//    ContentArray = data;
//    if (_weizhang.ListArray.count >0)
//    {
//        _WzCount.text = [NSString stringWithFormat:@"违章数量:%@,罚款:%@,扣分:%@",_weizhang.WeiZhangNum,_weizhang.NeedPayMoney,_weizhang.NeedPayPoint];
//    }
//    NSLog(@"%@",_WzCount.text);
////    [_ContentListTable reloadData];
////    [_ContentListTable.tableHeaderView reloadInputViews];
}

#pragma mark - NSUserDefaults
-(void)saveNSUserDefaults
{
    [userDefaults setObject:_ChePaiHao.text forKey:@"chepaihao"];
    [userDefaults setObject:_FadongjiText.text forKey:@"fadongjihao"];
    
}
-(void)readNSUserDefaults
{
    _FadongjiText.text = [userDefaults valueForKey:@"fadongjihao"];
    _ChePaiHao.text = [userDefaults valueForKey:@"chepaihao"];
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
