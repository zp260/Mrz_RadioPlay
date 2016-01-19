//
//  MenuTableViewController.m
//  XiRen
//
//  Created by PIPI on 15/8/21.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController
@synthesize menuArray;
@synthesize table;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initTableView
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled=YES;
    table.separatorColor=[UIColor clearColor];
    
    table.tableHeaderView = [self returnTableViewHeader];
    [self.view addSubview:table];
    [self downLoadData];
    

}
-(UIView *)returnTableViewHeader
{
    int headerHeight = 65;
    
    UIView *HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, headerHeight)];
    UILabel *FM961 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    UILabel *JieMuDan = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 20)];
    
    FM961.textAlignment = NSTextAlignmentCenter;
    JieMuDan.textAlignment = NSTextAlignmentCenter;
    
    [FM961 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [JieMuDan setFont:[UIFont yaheiFontOfSize:11]];
    
    [FM961 setTextColor:[UIColor colorWithWhite:0 alpha:0.40f]];
    [JieMuDan setTextColor:[UIColor colorWithWhite:0 alpha:0.40f]];
    
    FM961.text = @"FM961 喜人乐播";
    JieMuDan.text = @"节目单";
    
    [HeaderView addSubview:FM961];
    [HeaderView addSubview:JieMuDan];
    return HeaderView;
}
#pragma mark - table delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentListIdentifier= @"XirenMenuLIST1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:contentListIdentifier];
    if (cell ==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentListIdentifier];
    }
    else
    {
        //删除cell中的子对象
        while([cell.contentView.subviews lastObject]!=nil)
        {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            
            
        }
    }
    
    NSUInteger row= indexPath.row;
    if (menuArray.count>0)
    {
        NSArray *cellArray =  menuArray[indexPath.section];
        cell.textLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:5.0f];
        [cell setTextColor:[UIColor colorWithWhite:0 alpha:0.40f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@  %@",[cellArray[row] valueForKey:@"start_time"],[cellArray[row] valueForKey:@"end_time"],[cellArray[row] valueForKey:@"name"]];
    }
    
    //去掉背景 和 边框
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 )
    {
        return @"周一至周五";
    }
    else
    {
        return @"周日";
    }
}
//table datasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (menuArray)
    {
        NSLog(@"menu count %lu",(unsigned long)menuArray.count);
        return menuArray.count;
        
    }
    return 1;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (menuArray)
    {
        NSLog(@"numberOfRowsInSection :%ld",(long)section);
        
        NSArray *array = [menuArray objectAtIndex:section];
        
        return array.count;
    }
    return 0;
}

#pragma mark-下载数据
-(void)downLoadData
{
    NetGetController *_netget = [[NetGetController alloc]init];
    [_netget AFgetOLdata:url target:self selector:(@selector(getBackData:)) parameters:nil];
}
-(void)getBackData:(NSArray *)backArray
{
    menuArray = [[NSArray alloc]init];
    menuArray = backArray;
    //    [table reloadData];
    //    [table reloadInputViews];
}
-(void)DataSource
{
    
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
