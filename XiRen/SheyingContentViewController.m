//
//  SheyingContentViewController.m
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "SheyingContentViewController.h"
#import "UIView+Extension.h"
#import "PictureContentViewController.h"
#import "HuazhuangContentViewController.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoadingImageview.h"
@interface SheyingContentViewController ()


@end

@implementation SheyingContentViewController

@synthesize ContentSeg;
@synthesize SheyingshiTable;
@synthesize HuazhuangshiCollection;
@synthesize SheyingshiImageArray;
@synthesize HuazhuangshiImageArray;
@synthesize lodingIMG;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //加载动画
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    

    self.view.backgroundColor=[UIColor whiteColor];
    
    

    
    
    
    //摄影化妆segment
    ContentSeg = [[ UISegmentedControl alloc ]initWithFrame:CGRectMake(0,KNavgationBarHeight+49, kDeviceWidth, 30)];
    [ContentSeg insertSegmentWithTitle:@"摄影师" atIndex: 0 animated: NO ];
    [ContentSeg insertSegmentWithTitle:@"化妆师" atIndex: 1 animated: NO ];
    NSDictionary *titleColor = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil];
    [ContentSeg setTitleTextAttributes:titleColor forState:UIControlStateNormal];
    [ContentSeg setBackgroundColor:[UIColor clearColor]];
    [ContentSeg setTintColor:[UIColor colorWithRed:251.0f/255.0f green:87.0f/255.0f blue:49.0f/255.0f alpha:1.0f]];
    [ContentSeg setHighlighted:YES];
    ContentSeg.selectedSegmentIndex = 0;
    
    [ContentSeg addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:ContentSeg];
    
    
    
    //摄影师table
    SheyingshiTable=[[UITableView alloc]initWithFrame:CGRectMake(0,ContentSeg.bottom+5, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-60-ContentSeg.height)];
    SheyingshiTable.backgroundColor=[UIColor whiteColor];
    SheyingshiTable.dataSource=self;
    SheyingshiTable.delegate=self;
    SheyingshiTable.separatorStyle=UITableViewCellSelectionStyleNone;//去掉分割线
    [self.view addSubview:SheyingshiTable];
    
    
//化妆师collection
    // 初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    // UIEdgeInsets top = {15,10,15,5};
    // [flowLayout setSectionInset:top];
    HuazhuangshiCollection =[[UICollectionView alloc] initWithFrame:CGRectMake(0,ContentSeg.bottom+5, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-60-ContentSeg.height)collectionViewLayout:flowLayout];
    HuazhuangshiCollection.backgroundColor=[UIColor whiteColor];
    //注册单元格
    [HuazhuangshiCollection registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"henbiezhiCell"];
    //设置代理
    HuazhuangshiCollection.delegate = self;
    HuazhuangshiCollection.dataSource = self;
    [HuazhuangshiCollection setHidden:YES];
    [self.view addSubview:HuazhuangshiCollection];
    
    
    [self afnetwork];

    
}


//segmentControl方法
- (void)segmentClick:(id)sender
{
    switch (self.ContentSeg.selectedSegmentIndex)
    {
        case 0:
            self.SheyingshiTable.hidden =NO;
            self.HuazhuangshiCollection.hidden= YES;
            //            segmentControl.backgroundColor = [UIColor orangeColor];
            
            
            break;
        case 1:
            self.SheyingshiTable.hidden = YES;
            self.HuazhuangshiCollection.hidden = NO;
            
            break;
        default:
            break;
    }
}

#pragma mark - tableview delegate
//cell数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SheyingshiImageArray.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kDeviceWidth-20)*0.6+10;
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
    

    
    //摄影作品
    UIImageView *cellImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0,kDeviceWidth-20, (kDeviceWidth-20)*0.6)];
    [cellImage sd_setImageWithURL:[[SheyingshiImageArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
    

    [TaocanCell.contentView addSubview:cellImage];


    
    return TaocanCell;
}
//table点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PictureContentViewController *pushContent=[[PictureContentViewController alloc]init];
    //    [self.navigationController showViewController:pushContent sender:TaocanTable];
    pushContent.webaddress=[[SheyingshiImageArray objectAtIndex:indexPath.row]valueForKey:@"url"];
    pushContent.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushContent animated:YES];
}

#pragma mark - collectionView delegate
//设置分区


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,5,0,5};
    return top;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return HuazhuangshiImageArray.count;
}
//设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"henbiezhiCell" forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor =[UIColor whiteColor];
    
    //删除重叠视图
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *Cellimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kDeviceWidth-15)/2, (kDeviceWidth-15)/2*1.13)];
    [Cellimage sd_setImageWithURL:[[HuazhuangshiImageArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
    

    [cell.contentView addSubview:Cellimage];
    
    
    return cell;
}
//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kDeviceWidth-15)/2,(kDeviceWidth-15)/2*1.13);
}
//设置collection点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HuazhuangContentViewController *pushHuazhuang=[[HuazhuangContentViewController alloc]init];
    //    [self.navigationController showViewController:pushContent sender:TaocanTable];
    pushHuazhuang.webaddress=[[HuazhuangshiImageArray objectAtIndex:indexPath.row]valueForKey:@"url"];
    pushHuazhuang.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushHuazhuang animated:YES];
}

#pragma mark - network


-(void)afnetwork
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://www.xiren.com/androidapi.php?action=photoartist" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         SheyingshiImageArray=[responseObject valueForKey:@"photographer"];
         HuazhuangshiImageArray=[responseObject valueForKey:@"artist"];
         [SheyingshiTable reloadData];
         [HuazhuangshiCollection reloadData];
         
//         NSLog(@"JSON: %@", [responseObject class]);
         
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
