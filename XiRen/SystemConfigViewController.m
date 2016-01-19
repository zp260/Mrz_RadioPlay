//
//  SystemConfigViewController.m
//  XiRen
//
//  Created by PIPI on 15/7/27.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "SystemConfigViewController.h"
#import "WebViewController.h"
#include "XirenCoustNav.h"
#import "RegisterViewController.h"
#import "NetGetController.h"

@interface SystemConfigViewController ()
@property (nonatomic,strong) NSMutableArray *ListArray;
@property (strong,nonatomic) UITableView *ContentListTable;
@property (strong,nonatomic) WebViewController *web;

@end

@implementation SystemConfigViewController
#define ZtableviewX 0
#define ZtableviewY 0
@synthesize web;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    web=[[WebViewController alloc]init];
    
    [self initUI];
    [self initData];
    [self initContentTableView];
}

-(void)initUI
{
//    XirenCoustNav *xirenNav = [[XirenCoustNav alloc]init];
//    [xirenNav initXirenNav:self TitleView:nil WithTitle:@"我的信息"];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
//    backbutton.title=@"返回";
//    xirenNav.navigationItem.backBarButtonItem=backbutton;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *navLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
    navLable.text=@"我的信息";
    navLable.textColor=[UIColor whiteColor];
    navLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=navLable;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:251.0f/255.0f green:87.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem=backbutton;
}


-(void)initData
{
    
    //初始化Table列表数据
    _ListArray = [[NSMutableArray alloc]init];
    
    
    NSArray *GroupList2=[[NSArray alloc]initWithObjects:@"修改密码", nil];
    
    NSArray *GroupList3=[[NSArray alloc]initWithObjects:@"注册账号", nil];
    
    NSArray *GroupList4=[[NSArray alloc]initWithObjects:@"意见反馈",@"给应用评分",@"关于", nil];
    
    NSArray *GroupList5=[[NSArray alloc]initWithObjects:@"退出登陆", nil];
    
    
    
    [_ListArray addObject:GroupList2];
    [_ListArray addObject:GroupList3];
    [_ListArray addObject:GroupList4];
    [_ListArray addObject:GroupList5];
    
    
}

#pragma mark- init tableview
-(void) initContentTableView
{
    _ContentListTable=[[UITableView alloc] initWithFrame:CGRectMake(ZtableviewX,ZtableviewY, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    [_ContentListTable setDelegate:self];
    [_ContentListTable setDataSource:self];
    
    
    _ContentListTable.scrollEnabled=NO;
    
    
    
    
    _ContentListTable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    _ContentListTable.backgroundView=nil;
    [self.view addSubview:_ContentListTable];
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

    NSUInteger row= indexPath.row;
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    cell.textLabel.text=cellArray[row];
    
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
    //RegisterViewController *regCtrol = [[RegisterViewController alloc]init];
    
    switch (indexPath.section)
    {
        case 0:
            web.url= @"http://www.xiren.com/profile.php?action=modify&info_type=safe";
            [self.navigationController pushViewController:web animated:YES];
            break;
        case 1:
            web.url=@"http://www.xiren.com/register.php";
            [self.navigationController pushViewController:web animated:YES];
            break;
        case 2:
            switch (indexPath.row)
        {
            case 0:
                
                break;
            case 1:
                [self getAppID];
                break;
            case 2:
                web.url =@"http://www.xiren.com/fm.php?action=about";
                [self.navigationController pushViewController:web animated:YES];
                break;
            default:
                
                break;
        }

            break;
        case 3:
            [self LoginOut];
            break;
            
        default:
            break;
    }
    NSLog(@"did select index %ld",(long)indexPath.section);
    
    
}
-(void)LoginOut
{
    NSUserDefaults *defaultsMsg = [NSUserDefaults standardUserDefaults];
    [defaultsMsg setObject:nil forKey:@"userdefaultsCookie"];
    [defaultsMsg setObject:nil forKey:@"username"];
    [defaultsMsg setObject:nil forKey:@"userid"];
//          登陆状态退出 可用
    NSHTTPCookieStorage *cookiejar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:@"http://www.xiren.com"]];
    for (id obj in cookieArray)
    {
        [cookiejar deleteCookie:obj];
    }
    web.url = @"http://www.xiren.com/login.php?action=quit";
    [self.navigationController pushViewController:web animated:YES];
    
}

-(void)getAppID
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=895849683&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];//跳转到评论
    //NetGetController *netget = [[NetGetController alloc]init];
    //[netget AFgetOLdata:@"http://itunes.apple.com/search" target:nil selector:nil parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@"qq",@"term",@"software",@"entify", nil]];
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
