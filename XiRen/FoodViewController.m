//
//  FoodViewController.m
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "FoodViewController.h"
#import "XirenCoustNav.h"
#import "NetGetController.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"

@interface FoodViewController ()
    
@property (strong,nonatomic) UITableView *ContentListTable;
@property (strong,nonatomic) UIView *HeadView;
@property (strong,nonatomic) NetGetController *netGetController;
@property (strong,nonatomic) NSArray *ContentListArray;
@property (strong,nonatomic) NSMutableArray *ArrayHuoDongImage;
@property (strong,nonatomic) MBProgressHUD *hud;

@property (strong,nonatomic) UIImageView *HeaderImgView;
@property (strong,nonatomic) UIImage *HeaderImg;
@property (strong,nonatomic) NSString *headerClickUrl;
@property (strong,nonatomic) WebViewController *web;

@end


@implementation FoodViewController
#define ZtableviewX 0
#define ZtableviewY 0
#define API_Url @"http://www.xiren.com/androidapi.php?action=picture_video_activity"

@synthesize netGetController;
@synthesize ContentListArray;
@synthesize ArrayHuoDongImage;
@synthesize hud;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self iniUI];
    [self getOlData];
    
}

-(void)iniUI
{

    XirenCoustNav *xirenNav = [[XirenCoustNav alloc]init];
    [xirenNav initXirenNav:self TitleView:nil WithTitle:@"喜人活动"];
    
    _HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kDeviceWidth, 150)];
    _HeaderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
    _HeaderImg = [[UIImage alloc]init];

    _web = [[WebViewController alloc]init];
    ContentListArray = [[NSArray alloc]init];
    
}
-(void)initTableView
{
    _ContentListTable=[[UITableView alloc] initWithFrame:CGRectMake(ZtableviewX,ZtableviewY, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    [_ContentListTable setDelegate:self];
    [_ContentListTable setDataSource:self];
    _ContentListTable.scrollEnabled=YES;
    
    
    
    
    _ContentListTable.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:241.0f/255.0f blue:214.0f/255.0f alpha:0.5];
    _ContentListTable.backgroundView=nil;
    [self.view addSubview:_ContentListTable];
}

#pragma mark-tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentListIdentifier= @"XirenContentLIST";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:contentListIdentifier];
    if (cell ==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentListIdentifier];
    }
    else{
        //删除cell中的子对象
        while([cell.contentView.subviews lastObject]!=nil){
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            
            
        }
    }

    NSUInteger row= indexPath.row;
    
    
    
    cell.imageView.image = [ArrayHuoDongImage objectAtIndex:row];

    
    return cell;
}

#pragma mark-tableview datasource delege
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ContentListArray.count;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *urlStr=[[ContentListArray objectAtIndex:indexPath.row] valueForKey:@"url"];
    _web = [[WebViewController alloc]init];
    _web.url = urlStr;
    [self.navigationController pushViewController:_web animated:YES];
    
    
}

-(void)getOlData
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取内容中。。。";
    hud.opacity = 0.5f;
    
    netGetController = [[NetGetController alloc]init];
    [netGetController AFgetOLdata:API_Url target:self selector:@selector(DoLoadData:) parameters:nil];
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    
    
}

-(void)DoLoadData:(NSArray *)backdata
{
    if (backdata.count>0)
    {
        NSArray *ArrayHuoDong = [[NSArray alloc]initWithArray:[backdata valueForKey:@"activity"]];
        NSArray *HeaderImgArray = [[NSArray alloc]initWithArray:[backdata valueForKey:@"activity-bigpic"]];
        
        if (ArrayHuoDong.count>0)
        {
            ContentListArray = ArrayHuoDong;
            ArrayHuoDongImage =[[NSMutableArray alloc]init];
            
            
            [self MakeImageArrayCache:ArrayHuoDong CacheImageArray:ArrayHuoDongImage];//活动的
        }
        if (HeaderImgArray.count >0)
        {
            NSString *url = [[HeaderImgArray objectAtIndex:0]valueForKey:@"image"];
            _headerClickUrl = [NSString stringWithString:[[HeaderImgArray objectAtIndex:0]valueForKey:@"url"]];
            NSURL *Nurl = [NSURL URLWithString:url];
            _HeaderImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:Nurl]];
            _HeaderImgView.image = _HeaderImg;
            _HeaderImgView.userInteractionEnabled =YES;
            
            
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HeaderViewPicClick:)];
            singleFingerOne.numberOfTouchesRequired =1;
            singleFingerOne.numberOfTapsRequired=1;
            singleFingerOne.delegate =self;
            
            [_HeaderImgView addGestureRecognizer:singleFingerOne];
            
            [_HeadView addSubview:_HeaderImgView];
            _ContentListTable.tableHeaderView = _HeadView;
        }
        
        

    }
    [_ContentListTable reloadData];
}
//图片点击事件代理
-(void)HeaderViewPicClick:(UITapGestureRecognizer *)sender
{
    

    //NSLog(@"data is %@",[_ScroolClickAaary objectAtIndex:sender.view.tag]);
    if (sender.numberOfTapsRequired==1)
    {
        if (_headerClickUrl)
        {
            _web.url = _headerClickUrl;
            [self.navigationController pushViewController:_web animated:YES];
        }
    }
    
}
-(void)MakeImageArrayCache:(NSArray *)array CacheImageArray:(NSMutableArray *)CacheImageArray
{
    
    for (id object  in array)
    {
        NSString *imgUrlStr = [object valueForKey:@"image"];
        NSURL *imgUrl = [NSURL URLWithString:imgUrlStr];
        UIImage *IMG = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
        [CacheImageArray addObject:IMG];
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
