//
//  MeViewController.m
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "MeViewController.h"
#import "XirenCoustNav.h"
#import "WebViewController.h"
#import "SystemConfigViewController.h"
#include "LoginViewController.h"
@interface MeViewController ()

@property (strong,nonatomic) UITableView *ContentListTable;
@property (strong,nonatomic) NSMutableArray *ListArray;
@property (strong,nonatomic) NSMutableArray *ListIconAryyay;
@property (strong,nonatomic) UIView *TableHeader;
@property (strong,nonatomic) WebViewController *web;

@property (strong,nonatomic) NSString *DefaultUserName;
@property (strong,nonatomic) NSString *DefaultUserID;
@property (strong,nonatomic) UIImage *DefaultUserIMG;
@property (strong,nonatomic) NSUserDefaults *userDefaults;

@property (strong,nonatomic) UILabel *UserName;
@property (strong,nonatomic) UIImage *HeaderImg;
@property (strong,nonatomic) UIImageView *HeaderImgView;
@property (strong,nonatomic) UILabel *UserNickName;
@property (strong,nonatomic) UIButton *BtLogin;

@end

@implementation MeViewController
#define ZtableviewX 0
#define ZtableviewY 0
@synthesize web;
@synthesize TableHeader;
@synthesize userDefaults;


- (void)viewDidLoad {
    [super viewDidLoad];
    web = [[WebViewController alloc]init];
    [self initUI];
    [self initData];
    [self initContentTableView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self ReadDefaultUser];
    NSLog(@"userDefaults = %@,%@",_DefaultUserName,[userDefaults valueForKey:@"userdefaultsCookie"]);
   
    

    if (_DefaultUserIMG)
    {
        _HeaderImg = _DefaultUserIMG;
        
    }
    else
    {
        _HeaderImg = [UIImage imageNamed:@"sign-in"];
    }
    _HeaderImgView.image = _HeaderImg;
    _HeaderImgView.contentMode = UIViewContentModeScaleToFill;
    
    if (_DefaultUserName)
    {
        _UserName.text = _DefaultUserName;
        _UserNickName.text = [NSString stringWithFormat:@"喜人号:%@",@"ABC"];
        if (_BtLogin)
        {
            [_BtLogin removeFromSuperview];
        }
        [TableHeader addSubview:_HeaderImgView];
        [TableHeader addSubview:_UserName];
        [TableHeader addSubview:_UserNickName];
    }
    else
    {
        _UserName.text = nil;
        _UserNickName.text = nil;
        
        
        
        [_BtLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_BtLogin setTitle:@"未登录" forState:UIControlStateNormal];
        [_BtLogin addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
        [TableHeader addSubview:_HeaderImgView];
        
        [TableHeader addSubview:_BtLogin];
    }

}
-(void)initUI
{
    XirenCoustNav *xirenNav = [[XirenCoustNav alloc]init];
    [xirenNav initXirenNav:self TitleView:nil WithTitle:@"我的信息"];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    TableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 80)];
    
    _HeaderImg = [[UIImage alloc]init];
    _HeaderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];

    
    _UserName = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 200 , 20)];
    _UserNickName =[[UILabel alloc]initWithFrame:CGRectMake(80, 45, 200, 20)];
    _UserNickName.font = [UIFont fontWithName:@"Arial-BoldMT" size:9];
    _UserName.font =[UIFont fontWithName:@"Arial-BoldMT" size:12];
    _BtLogin = [[UIButton alloc]initWithFrame:CGRectMake(80, 30, 100, 20)];
}
-(void)Login
{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}
-(void)initData
{
    
    //初始化Table列表数据
    _ListArray = [[NSMutableArray alloc]init];
   
    
    NSArray *GroupList2=[[NSArray alloc]initWithObjects:@"我的关注",@"我的图说",@"我的收藏", nil];
    
    NSArray *GroupList3=[[NSArray alloc]initWithObjects:@"关于我的",@"浏览记录", nil];
    
    NSArray *GroupList4=[[NSArray alloc]initWithObjects:@"我的相册", nil];
    
    NSArray *GroupList5=[[NSArray alloc]initWithObjects:@"系统设置", nil];
    
    

    [_ListArray addObject:GroupList2];
    [_ListArray addObject:GroupList3];
    [_ListArray addObject:GroupList4];
    [_ListArray addObject:GroupList5];
    
    UIImage * Icon2_0 = [UIImage imageNamed:@"followed"];
    UIImage * Icon2_1 = [UIImage imageNamed:@"my pic"];
    UIImage * Icon2_2 = [UIImage imageNamed:@"my favorite"];
    NSArray *GroupIconList2= [[NSArray alloc]initWithObjects:Icon2_0,Icon2_1,Icon2_2, nil];
    
    UIImage * Icon3_0 = [UIImage imageNamed:@"about me"];
    UIImage * Icon3_1 = [UIImage imageNamed:@"browing history"];
    NSArray *GroupIconList3 = [[NSArray alloc]initWithObjects:Icon3_0,Icon3_1, nil];
 
    UIImage * Icon4_0 = [UIImage imageNamed:@"emoticon"];
    NSArray *GroupIconList4 = [[NSArray alloc]initWithObjects:Icon4_0, nil];

    UIImage * Icon5_0 = [UIImage imageNamed:@"system setting"];
    NSArray *GroupIconList5 = [[NSArray alloc]initWithObjects:Icon5_0, nil];
    
    _ListIconAryyay = [[NSMutableArray alloc]init];
    [_ListIconAryyay addObject:GroupIconList2];
    [_ListIconAryyay addObject:GroupIconList3];
    [_ListIconAryyay addObject:GroupIconList4];
    [_ListIconAryyay addObject:GroupIconList5];
    

}
-(void)ReadDefaultUser
   {
       userDefaults = [NSUserDefaults standardUserDefaults];
       _DefaultUserName = [userDefaults valueForKey:@"username"];
       _DefaultUserID = [userDefaults valueForKey:@"userid"];
       _DefaultUserIMG = [userDefaults valueForKey:@"userimg"];
   }
#pragma mark- init tableview
-(void) initContentTableView
{
    _ContentListTable=[[UITableView alloc] initWithFrame:CGRectMake(ZtableviewX,ZtableviewY, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    [_ContentListTable setDelegate:self];
    [_ContentListTable setDataSource:self];
    
    
    _ContentListTable.scrollEnabled=YES;
    
    
    
    
    _ContentListTable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    _ContentListTable.backgroundView=nil;
    [self.view addSubview:_ContentListTable];
    _ContentListTable.tableHeaderView = TableHeader;
}


#pragma mark-tableview delegate
//TABLEviewdatasouce 代理部分
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSArray *cellArray =  _ListArray[indexPath.section];
    NSArray *IconArray = _ListIconAryyay[indexPath.section];
    NSUInteger row= indexPath.row;
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    cell.textLabel.text=cellArray[row];
    cell.imageView.image = IconArray[row];
    
    return cell;
}

#pragma mark-tableview datasource delege

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _ListArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _ListArray[section];
    return array.count;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemConfigViewController *systemCtrol = [[SystemConfigViewController alloc]init];
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                   web.url = @"http://www.xiren.com/u.php?a=friend&type=attention";
                    break;
                case 1:
                    web.url = @"http://www.xiren.com/apps.php?q=article";
                    break;
                case 2:
                    web.url = @"http://www.xiren.com/apps.php?q=collection";
                    break;
                
                default:
                    web.url = @"http://www.xiren.com/u.php?a=friend&type=attention";
                    break;
            }
            [self.navigationController pushViewController:web animated:YES];
            break;
        case 1:
            switch (indexPath.row)
        {
            case 0:
                web.url = @"http://www.xiren.com/u.php";
                break;
            case 1:
                web.url = @"http://www.xiren.com/apps.php?q=article";
                break;
            default:
                web.url = @"http://www.xiren.com/u.php";
                break;
        }
            [self.navigationController pushViewController:web animated:YES];
            break;
        case 2:
            web.url = @"http://www.xiren.com/apps.php?q=photos";
            [self.navigationController pushViewController:web animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:systemCtrol animated:YES];
            break;
            
        default:
            break;
    }
    NSLog(@"did select index %ld",(long)indexPath.section);
    
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
