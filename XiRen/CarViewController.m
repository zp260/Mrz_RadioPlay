//
//  HomeViewController.m
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "CarViewController.h"
#import "WebViewController.h"
#include "XirenCoustNav.h"
#include "MBProgressHUD.h"
#include "WeiZhangViewController.h"
#include "WeiZhangCustomTableViewCell.h"

#define ZtableviewX 0
#define ZtableviewY 0 //与navigationbar hight 一样
#define ZscroolviewX 0
#define ZscroolviewY 0
#define UImenuHeight 25

@interface CarViewController ()

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

-(void)ScroolViewPicClick:(UITapGestureRecognizer *)sender;

@end

@implementation CarViewController

@synthesize ScroolClickAaary=_ScroolClickAaary;
@synthesize ContentListArray;
@synthesize webCrtrol =_webCrtrol;
@synthesize cellImageArray=_cellImageArray;
@synthesize ScroolCount=_ScroolCount;
@synthesize ScroolImageArray;
@synthesize CousterNav;
@synthesize segmentedCtrol;
@synthesize assessmentArray;
@synthesize ContentArray;
@synthesize WeiZhangBG;
@synthesize userDefaults;
@synthesize lodingIMG;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CousterNav = [[XirenCoustNav alloc]init];
    [CousterNav initXirenNav:self TitleView:nil WithTitle:@"喜人网"];
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem=backbutton;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    _webCrtrol= [[WebViewController alloc]init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //初始化loading动画图片
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"获取内容中。。。";
    _hud.opacity = 0.5f;
    // Do any additional setup after loading the view.
    _hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES afterDelay:2];
    
    //栏目导航
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"最新",@"商家优惠",@"加入车友会",@"违章查询", nil];
    segmentedCtrol= [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedCtrol.frame = CGRectMake(0, KNavgationBarHeight, kDeviceWidth, UImenuHeight);
    segmentedCtrol.tintColor = [UIColor clearColor];
    segmentedCtrol.selectedSegmentIndex=0;
    segmentedCtrol.layer.cornerRadius=1;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName, nil];
    [segmentedCtrol setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [CousterNav getNavTintColor]};
    [segmentedCtrol setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    //设置分段控件点击相应事件
    [segmentedCtrol addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrol];

    

//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        NSLog(@"%@", cookie);
//    }
    [self xiren_init];
    
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

-(void)xiren_init
{
    

    
    
    //初始化网络要用到的全局变量
    [self data_init];
    //初始化SCROLLVIEW
    [self initScroolView];
    //tableview part。
    [self initContentTableView];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"获取内容中。。。";
    _hud.opacity = 0.5f;
    
    //初始化loading动画图片
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    //获得网络接口json数据
    [self getOnlineData];

    //init WeiZhangUI
    [self makeWeiZhangFrame];
    
    //添加刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [_ContentListTable addSubview:_refreshControl];
    
    _hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES afterDelay:2];
}

-(void)data_init
{

    _ScroolClickAaary = [[NSMutableArray alloc]init];
    ContentListArray=[[NSMutableArray alloc]init];
    _cellImageArray = [[NSMutableArray alloc]init];
    ScroolImageArray = [[NSMutableArray alloc]init];
    ContentArray=[[NSArray alloc]init];
    _ScroolCount = 0;
    self.pageControl =[[UIPageControl alloc]init];
    self.timer = [[NSTimer alloc]init];
    
}

-(void) initScroolView
{
    
    
    _FoucsScrool=[[UIScrollView alloc] initWithFrame:CGRectMake(ZscroolviewX, ZscroolviewY, kDeviceWidth, ScroolViewHeight)];
    [_FoucsScrool setContentSize:CGSizeMake(kDeviceWidth*5, 0)];
    [_FoucsScrool setBackgroundColor:[UIColor whiteColor]];
    _FoucsScrool.pagingEnabled=YES;
    

}
-(void) refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新日期 %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [self getOnlineData];
    [_ContentListTable reloadData];
    [refresh endRefreshing];
}

-(void)getOnlineData
{
    
            [self AFgetOLdata:Api_Url];
    
}

-(void) AFgetOLdata:(NSString *)ApiUrlString
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager GET:ApiUrlString parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
            //传递返回数据
             [self func_back_data:responseObject];
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"出错了" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"json:%@",error);
         
     }];
    
}

//处理返回数据
-(void) func_back_data:(NSMutableArray *)backarray
{
    ContentArray =nil;
    if (backarray.count>0)
    {
        
        ContentListArray=[backarray valueForKey:@"carlist"];//文章列表
        ContentArray = ContentListArray;//默认
        __weak UITableView *weakSelf = _ContentListTable;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadData];
        });
        //[_ContentListTable reloadData];
        //[self cellUIimagevews:ContentListArray];

        assessmentArray = [backarray valueForKey:@"usedcarlist"];
        
        
        ScroolImageArray = [backarray valueForKey:@"foucs"];//轮播数组
        if (ScroolImageArray.count>0)
        {
            for (NSInteger i=0;i< [ScroolImageArray count];i++)
            {
                [self AddScroolViews:i];
            }
        }
        

    }
    
}
-(void)AddScroolViews:(NSInteger)i
{
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ScroolViewPicClick:)];
    singleFingerOne.numberOfTouchesRequired =1;
    singleFingerOne.numberOfTapsRequired=1;
    singleFingerOne.delegate =self;
    
    
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0+kDeviceWidth*i, ZscroolviewY, kDeviceWidth, ScroolViewHeight)];
    [imgview sd_setImageWithURL:[NSURL URLWithString:[[ScroolImageArray objectAtIndex:i]valueForKey:@"image"]] placeholderImage:lodingIMG];
    [_ScroolClickAaary addObject:[[ScroolImageArray objectAtIndex:i]valueForKey:@"url"]];
    imgview.userInteractionEnabled=YES;
    if(imgview.image != lodingIMG)
    {
        imgview.contentMode=UIViewContentModeScaleToFill;
    }
    
    [imgview addGestureRecognizer:singleFingerOne];
    imgview.tag=i;
    [_FoucsScrool addSubview:imgview];

}
//异步加载cell用de图片,解决上下滚动的卡顿现象
-(void)cellUIimagevews:(NSMutableArray *)ImageArray
{
    for (id object in  ImageArray)
    {
        NSURL *url =[NSURL URLWithString:[object objectForKey:@"image"]];
        UIImage *cellIMG=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [_cellImageArray addObject:cellIMG];
    }
}
//异步加载ScroolView用de图片,解决上下滚动的卡顿现象
-(void)getScroolImages:(NSMutableArray *)ImageArray
{
    for (id object in  ImageArray)
    {
        if([object objectForKey:@"url"])
        {
            [_ScroolClickAaary addObject:[object objectForKey:@"url"]];
            NSURL *ImgUrl =[NSURL URLWithString:[object objectForKey:@"image"]];
            UIImage *IMG=[UIImage imageWithData:[NSData dataWithContentsOfURL:ImgUrl]];
            if(!IMG)
            {
                IMG = [UIImage imageNamed:@"tab_photo"];
            }
            [ScroolImageArray addObject:IMG];

        }
            
    }
}

#pragma mark-图片点击相关
-(void)ScroolViewPicClick:(UITapGestureRecognizer *)sender
{

    _webCrtrol.url =[_ScroolClickAaary objectAtIndex:sender.view.tag];
    //NSLog(@"data is %@",[_ScroolClickAaary objectAtIndex:sender.view.tag]);
    if (sender.numberOfTapsRequired==1) {
        [self.navigationController pushViewController:_webCrtrol animated:YES];
        [self removeTimer];
    }
    
}

#pragma mark-TABLE init
-(void) initContentTableView
{
    _ContentListTable=[[UITableView alloc] initWithFrame:CGRectMake(ZtableviewX,KNavgationBarHeight+UImenuHeight, kDeviceWidth, kDeviceHeight-KTabarHeight-UImenuHeight-KNavgationBarHeight) style:UITableViewStylePlain];
    [_ContentListTable setDelegate:self];
    [_ContentListTable setDataSource:self];
    [_ContentListTable setTableHeaderView:_FoucsScrool];


    _ContentListTable.scrollEnabled=YES;


    
    _ContentListTable.backgroundColor = [UIColor clearColor];
    _ContentListTable.backgroundView=nil;
    [self.view addSubview:_ContentListTable];
//    NSLog(@"_ContentListTable  %@", _ContentListTable);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-tableview delegate
//TABLEviewdatasouce 代理部分
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returncell = [[UITableViewCell alloc]init];
    NSUInteger row= indexPath.row;
    NSString *contentListIdentifier= @"XirenContentLIST";
    if (segmentedCtrol.selectedSegmentIndex == 3) //违章
    {
        contentListIdentifier= @"weizhang";
        WeiZhangCustomTableViewCell *WzCell = [tableView dequeueReusableCellWithIdentifier:contentListIdentifier forIndexPath:indexPath];
        //NSLog(@"row %i data is %@ ,class is %@",row, [ContentArray objectAtIndex:row],[[ContentArray objectAtIndex:row]class]);
        NSArray *datadic =[[NSArray alloc]initWithArray:[ContentArray objectAtIndex:row]];
        
        WzCell.LableDate.text = [datadic objectAtIndex:0];
        WzCell.LableAdrres.text = [datadic objectAtIndex:1];
        WzCell.LableReason.text = [datadic objectAtIndex:2];
        WzCell.LableCoin.text = [datadic objectAtIndex:3];
        returncell = WzCell;

    }
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:contentListIdentifier];
        if (cell ==nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contentListIdentifier];
        }
        else
        {
            //删除cell中的子对象
            while([cell.contentView.subviews lastObject]!=nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        NSDictionary *datadic =[[NSDictionary alloc]initWithDictionary:[ContentArray objectAtIndex:row]];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[datadic valueForKey:@"image"]] placeholderImage:lodingIMG];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        cell.textLabel.text=[datadic objectForKey:@"title"];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        
        cell.detailTextLabel.text = [datadic objectForKey:@"postdate"];
        cell.detailTextLabel.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        UILabel *rightDetailText=[[UILabel alloc]init];
        rightDetailText.frame = CGRectMake(kDeviceWidth-70, cell.height-15, 50, 10);
        if (segmentedCtrol.selectedSegmentIndex==1)
        {
            rightDetailText.font = cell.detailTextLabel.font;
            rightDetailText.textColor = [UIColor redColor];
            rightDetailText.text =[NSString stringWithFormat:@"%@%@",[datadic objectForKey:@"readNum"],@"万"];
        }
        else
        {
            
            rightDetailText.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
            rightDetailText.font = cell.detailTextLabel.font;
            if([datadic objectForKey:@"readNum"])
            {
                rightDetailText.text =[NSString stringWithFormat:@"%@%@",[datadic objectForKey:@"readNum"],@"人看过"];
            }
            else
            {
                rightDetailText.text =@"";
            }
            
            
            
        }
        [cell.contentView addSubview:rightDetailText];
        returncell =cell;

    }
    

    
  
    return returncell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segmentedCtrol.selectedSegmentIndex ==1)
    {
        return 50;
    }
    else
    {
        return 100;
    }

    
}
#pragma mark-tableview datasource delege

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ContentArray count];
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(segmentedCtrol.selectedSegmentIndex !=3)
    {
        
        NSUInteger row= indexPath.row;
        NSDictionary *datadic =[[NSDictionary alloc]initWithDictionary:[ContentArray objectAtIndex:row]];
        
        _webCrtrol.url=[datadic objectForKey:@"url"];
        [self.navigationController pushViewController:_webCrtrol animated:YES];
        [self removeTimer];

    }

    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{

    
    [super viewDidAppear:animated];
    _FoucsScrool.delegate =self;
    self.pageControl.numberOfPages=5;

        [self addTimer];
}
#pragma mark-SCroll and TIMER
-(void)nextImage
{
    NSInteger i=self.pageControl.currentPage;
    if (i==5-1)
    {
        i=-1;
    }
    i++;
    [_FoucsScrool setContentOffset:CGPointMake(i*_FoucsScrool.frame.size.width, 0) animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
     //    计算页码
     //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    self.pageControl.currentPage=(_FoucsScrool.frame.size.width*0.5+_FoucsScrool.contentOffset.x)/_FoucsScrool.frame.size.width;
    //NSLog(@"滚动中,%d",self.pageControl.currentPage);
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     [self addTimer];
}
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)removeTimer
{
     [self.timer invalidate];
    self.timer=nil;
}
#pragma mark -UISegmentedControl
-(void)selected:(id)sender
{
    
    
    
    switch (segmentedCtrol.selectedSegmentIndex)
    {
        case 0:
            ContentArray = ContentListArray;
            [_ContentListTable setTableHeaderView:_FoucsScrool];
            
            break;
        case 1:
            ContentArray = ContentListArray;
            [_ContentListTable setTableHeaderView:nil];
            
            break;
        case 2:
            ContentArray = assessmentArray;
            [_ContentListTable setTableHeaderView:nil];
            
            break;
        case 3:
            [_ContentListTable setTableHeaderView:WeiZhangBG];
            [_ContentListTable registerClass:[WeiZhangCustomTableViewCell class] forCellReuseIdentifier:@"weizhang"];
            ContentArray  = nil;
            break;
        default:
            ContentArray = ContentListArray;
            
            break;
    }
    [_ContentListTable reloadData];
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
        
    }
    
    
}
-(void)MakeTableListData:(NSArray *)data
{
    ContentArray = data;
    if (_weizhang.ListArray.count >0)
    {
        _WzCount.text = [NSString stringWithFormat:@"违章数量:%@,罚款:%@,扣分:%@",_weizhang.WeiZhangNum,_weizhang.NeedPayMoney,_weizhang.NeedPayPoint];
        NSLog(@"%@",_WzCount.text);
    }

    [_ContentListTable reloadData];
    [_ContentListTable.tableHeaderView reloadInputViews];
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
#pragma mark-refresh

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
