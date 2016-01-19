//
//  TaocanContentViewController.m
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "TaocanContentViewController.h"
#import "UIView+Extension.h"
#import "ContentViewController.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "FuzhuangContentViewController.h"
#import "SheyingContentViewController.h"
#import "WomenContentViewController.h"
#import "LoadingImageview.h"
#import "XirenCoustNav.h"
@interface TaocanContentViewController ()


@end

@implementation TaocanContentViewController

@synthesize TaocanTable;
@synthesize TaocanArray;
@synthesize HomeTab;
@synthesize lodingIMG;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载动画
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    
        
    self.view.backgroundColor=[UIColor whiteColor];

   

    //自定义table
    TaocanTable=[[UITableView alloc]initWithFrame:CGRectMake(0,KNavgationBarHeight+49, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-60)];
    TaocanTable.backgroundColor=[UIColor whiteColor];
    TaocanTable.dataSource=self;
    TaocanTable.delegate=self;
    TaocanTable.separatorStyle=UITableViewCellSelectionStyleNone;//去掉分割线
    
    
    
    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
    
    [self.view addSubview:TaocanTable];
    [self afnetwork];

}




-(void)afnetwork
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://www.xiren.com/androidapi.php?action=newpackage" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         TaocanArray=[responseObject valueForKey:@"newpackage"];

         [TaocanTable reloadData];

         
//         NSLog(@"JSON: %@", [responseObject class]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"Error: %@", error);
         
     }];
}
#pragma mark - tableview delegate
//cell数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TaocanArray.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDeviceWidth*0.54;
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
    
    UIImageView *cellImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, (kDeviceWidth-20)*0.56)];
    
    [cellImage sd_setImageWithURL:[[TaocanArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
    
    
    
    
    
    [TaocanCell.contentView addSubview:cellImage];

    
    return TaocanCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentViewController *pushContent=[[ContentViewController alloc]init];
    //    [self.navigationController showViewController:pushContent sender:TaocanTable];
    pushContent.webaddress=[[TaocanArray objectAtIndex:indexPath.row]valueForKey:@"url"];
    NSLog(@"%@",self.navigationController);
    pushContent.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushContent animated:YES];
    
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
