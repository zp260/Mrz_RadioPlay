//
//  FuzhuangContentViewController.m
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import "FuzhuangContentViewController.h"
#import "UIView+Extension.h"
#import "FuzhuangCellViewController.h"
#import "ClothesCellViewController.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "TaocanContentViewController.h"
#import "WomenContentViewController.h"
#import "SheyingContentViewController.h"
#import "LoadingImageview.h"

@interface FuzhuangContentViewController ()

@end

@implementation FuzhuangContentViewController
@synthesize ChangjingTable;
@synthesize ContentSeg;
@synthesize ClothesCollection;
@synthesize ChangjingImageArray;
@synthesize ClothesImageArray;
@synthesize HomeTab;
@synthesize lodingIMG;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //加载动画
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    

    self.view.backgroundColor=[UIColor whiteColor];
    
    //摄影化妆segment
    ContentSeg = [[ UISegmentedControl alloc ]initWithFrame:CGRectMake(0,KNavgationBarHeight+49, kDeviceWidth, 30)];
    [ContentSeg insertSegmentWithTitle:@"服装" atIndex: 0 animated: NO ];
    [ContentSeg insertSegmentWithTitle:@"场景" atIndex: 1 animated: NO ];
    NSDictionary *titleColor = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil];
    [ContentSeg setTitleTextAttributes:titleColor forState:UIControlStateNormal];
    [ContentSeg setBackgroundColor:[UIColor whiteColor]];
    [ContentSeg setTintColor:[UIColor colorWithRed:251.0f/255.0f green:87.0f/255.0f blue:49.0f/255.0f alpha:1.0f]];
    [ContentSeg setHighlighted:YES];
    ContentSeg.selectedSegmentIndex = 0;
    
    [ContentSeg addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:ContentSeg];
    
    
    
    //场景table
    ChangjingTable=[[UITableView alloc]initWithFrame:CGRectMake(0,ContentSeg.bottom+5, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-60-ContentSeg.height)];
    ChangjingTable.backgroundColor=[UIColor whiteColor];
    ChangjingTable.dataSource=self;
    ChangjingTable.delegate=self;
    ChangjingTable.separatorStyle=UITableViewCellSelectionStyleNone;//去掉分割线
    [ChangjingTable setHidden:YES];
    [self.view addSubview:ChangjingTable];
    
    
    //服装collection
    // 初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    // UIEdgeInsets top = {15,10,15,5};
    // [flowLayout setSectionInset:top];
    ClothesCollection =[[UICollectionView alloc] initWithFrame:CGRectMake(0,ContentSeg.bottom+5, kDeviceWidth, kDeviceHeight-KNavgationBarHeight-KTabarHeight-60-ContentSeg.height)collectionViewLayout:flowLayout];
    ClothesCollection.backgroundColor=[UIColor whiteColor];
    //注册单元格
    [ClothesCollection registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"henbiezhiCell"];
    //设置代理
    ClothesCollection.delegate = self;
    ClothesCollection.dataSource = self;

    [self.view addSubview:ClothesCollection];
    [self afnetwork];

    
    //设置图片与Lable数组
//    ClothesImageArray=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"camera_one"],[UIImage imageNamed:@"camera_two"],[UIImage imageNamed:@"camera_three"],[UIImage imageNamed:@"camera_four"], nil];
//    ClothesLableArray=[[NSMutableArray alloc]initWithObjects:@"henbiezhi",@"henchaozhi",@"hentiexin",@"henzhuanye", nil];
}

//segmentControl方法
- (void)segmentClick:(id)sender
{
    switch (self.ContentSeg.selectedSegmentIndex)
    {
        case 0:
            self.ClothesCollection.hidden =NO;
            self.ChangjingTable.hidden= YES;
            //            segmentControl.backgroundColor = [UIColor orangeColor];
            
            
            break;
        case 1:
            self.ClothesCollection.hidden = YES;
            self.ChangjingTable.hidden = NO;
            
            break;
        default:
            break;
    }
}


#pragma mark - tableview delegate
//cell数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ChangjingImageArray.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDeviceWidth*0.51;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentListIdentifier= @"WildContentLIST";
    UITableViewCell *ChangjingCell=[tableView dequeueReusableCellWithIdentifier:contentListIdentifier];
    if (ChangjingCell ==nil)
    {
        ChangjingCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentListIdentifier];
    }
    else
    {
        //删除cell中的子对象
        while([ChangjingCell.contentView.subviews lastObject]!=nil)
        {
            [(UIView *)[ChangjingCell.contentView.subviews lastObject] removeFromSuperview];
            
            
        }
        
    }
    ChangjingCell.accessoryType=UITableViewCellAccessoryNone;//cell无色
    ChangjingCell.backgroundColor=[UIColor clearColor];
    ChangjingCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
    //外景图片
    UIImageView *cellChangjingImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*0.51)];
    [cellChangjingImage sd_setImageWithURL:[[ChangjingImageArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
    

    
    [ChangjingCell.contentView addSubview:cellChangjingImage];


    
    return ChangjingCell;
}
//table点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FuzhuangCellViewController *pushContent=[[FuzhuangCellViewController alloc]init];
    //    [self.navigationController showViewController:pushContent sender:TaocanTable];
    pushContent.webaddress=[[ChangjingImageArray objectAtIndex:indexPath.row]valueForKey:@"url"];
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
    return ClothesImageArray.count;
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
    [Cellimage sd_setImageWithURL:[[ClothesImageArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:lodingIMG];
    

    [cell.contentView addSubview:Cellimage];
    
    
    return cell;
}
//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kDeviceWidth-15)/2,(kDeviceWidth-15)/2*1.13);
}
//设置collection点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClothesCellViewController *pushclothes=[[ClothesCellViewController alloc]init];
    //    [self.navigationController showViewController:pushContent sender:TaocanTable];
    pushclothes.webaddress=[[ClothesImageArray objectAtIndex:indexPath.row]valueForKey:@"url"];
    pushclothes.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushclothes animated:YES];
}

#pragma mark - network
-(void)afnetwork
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://www.xiren.com/androidapi.php?action=clothingsight" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         ClothesImageArray=[responseObject valueForKey:@"clothing"];
         ChangjingImageArray=[responseObject valueForKey:@"sight"];
         [self.ChangjingTable reloadData];
         [self.ClothesCollection reloadData];
         
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
