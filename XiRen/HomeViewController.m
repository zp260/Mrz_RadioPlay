//
//  CarViewController.m
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()


@end

@implementation HomeViewController



@synthesize ContentCollectionView;
@synthesize segmentedCtrol;
@synthesize netGetController;
@synthesize TuShuoImageArray;
@synthesize ShiPingImageArray;
@synthesize TushuoArray;
@synthesize ShipingArray;
@synthesize ContentListArray;
@synthesize web;
@synthesize hud=_hud;
@synthesize lodingIMG;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initColletion];
    [self initUI];
    //初始化loading动画图片
    LoadingImageview *loading = [[LoadingImageview alloc]init];
    lodingIMG = [loading initloadingImg];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"获取内容中。。。";
    _hud.opacity = 0.5f;
    [self initData];
    [self getOlData];
    
    
    
    // Do any additional setup after loading the view.
    _hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES afterDelay:2];

    
}

-(void)initUI
{
    
    XirenCoustNav *CousterNav = [[XirenCoustNav alloc]init];
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem=backbutton;
    
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"发帖" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightbutton)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //栏目导航
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"图说",@"视频", nil];
    segmentedCtrol= [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedCtrol.frame = CGRectMake(0, KNavgationBarHeight, kDeviceWidth, 25);
    segmentedCtrol.backgroundColor=[UIColor whiteColor];
    segmentedCtrol.tintColor = [UIColor whiteColor];
    
    segmentedCtrol.selectedSegmentIndex=0;
    segmentedCtrol.layer.cornerRadius=1;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName, nil];
    [segmentedCtrol setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [CousterNav getNavTintColor]};
    [segmentedCtrol setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
            //设置分段控件点击相应事件
    [segmentedCtrol addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    
    
    [CousterNav initXirenNav:self TitleView:nil WithTitle:@"喜人网"];
    
    [self.view addSubview:segmentedCtrol];

    web =[[WebViewController alloc]init];
    
    
}

-(void)initData
{
    TuShuoImageArray = [[NSMutableArray alloc]init];
    ShiPingImageArray = [[NSMutableArray alloc]init];
    TushuoArray =[[NSArray alloc]init];
    ShipingArray = [[NSArray alloc]init];
    ContentListArray = [[NSArray alloc]init];
    _Pic_BigPicImageArray =[[NSMutableArray alloc]init];
    _Video_BigPicImageArray = [[NSMutableArray alloc]init];
}

-(void)initColletion
{
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(kDeviceWidth, AD_height);
    ContentCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 25, kDeviceWidth, kDeviceHeight-25) collectionViewLayout:flowLayout];
    ContentCollectionView.dataSource=self;
    ContentCollectionView.delegate=self;
    ContentCollectionView.backgroundColor = [UIColor whiteColor];
    
    //注册CELL
    
    [ContentCollectionView registerClass:[CustomPicTalkCollectionViewCell class] forCellWithReuseIdentifier:@"cell3"];
    [ContentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [self.view addSubview:ContentCollectionView];
    
}
#pragma mark-data part

-(void)getOlData
{

    netGetController = [[NetGetController alloc]init];
    [netGetController AFgetOLdata:API_Url target:self selector:@selector(DoLoadData:) parameters:nil];
    

}

-(void)DoLoadData:(NSArray *)backdata
{
    if (backdata.count>0)
    {
        TushuoArray =[backdata valueForKey:@"pic"];
        ShipingArray = [backdata valueForKey:@"video"];
        _Pic_BigPicArray= [backdata valueForKey:@"pic-bigpic"];
        _Video_BigPicArray = [backdata valueForKey:@"video-bigpic"];
        ContentListArray = TushuoArray;
       
    }
    [ContentCollectionView reloadData];
}

#pragma mark-Collection delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ContentListArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row= indexPath.row;
    NSString *identify=[[NSString alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[ContentListArray objectAtIndex:row]];
    if (segmentedCtrol.selectedSegmentIndex==0)
    {
        identify = @"cell3";


    }
    else
    {
        identify = @"cell";
    }
    
    

    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if(!cell)
    {
        NSLog(@"无法创建ColletionCell");
    }
    [cell.ImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] placeholderImage:lodingIMG];
    cell.Title.text = [dic objectForKey:@"title"];
    cell.HitCount.text = @"0000";
    cell.ReadNum.text = @"0000";
    return cell;
    
}
//头部AD区域
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    
    NSString *url =[[NSString alloc]init];
    
    UIButton *TopBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, AD_height)];
    
    
    if (_Pic_BigPicArray.count > 0 && _Video_BigPicArray.count >0)
    {
        switch (segmentedCtrol.selectedSegmentIndex)
        {
            case 0:
                [TopBt sd_setImageWithURL:[NSURL URLWithString:[[_Pic_BigPicArray objectAtIndex:indexPath.row]valueForKey:@"image"]] forState:UIControlStateNormal];
                
                break;
            case 1:
                [TopBt sd_setImageWithURL:[NSURL URLWithString:[[_Video_BigPicArray objectAtIndex:indexPath.row]valueForKey:@"image"]] forState:UIControlStateNormal];

                break;
            default:
               [TopBt sd_setImageWithURL:[NSURL URLWithString:[[_Pic_BigPicArray objectAtIndex:indexPath.row]valueForKey:@"image"]] forState:UIControlStateNormal];
                url =[[_Pic_BigPicArray objectAtIndex:indexPath.row]valueForKey:@"url"];
                break;
        }

    }

    
    
    

    [TopBt addTarget:self action:@selector(TopImgClick:) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:TopBt];//这里添加头部自定义广告View
    return headerView;
}

-(void)TopImgClick:(NSString *)url
{
    switch (segmentedCtrol.selectedSegmentIndex)
    {
        case 0:
            url =[[_Pic_BigPicArray objectAtIndex:0]valueForKey:@"url"];
            break;
        case 1:
            url =[[_Video_BigPicArray objectAtIndex:0]valueForKey:@"url"];
            break;
        default:
            url =[[_Pic_BigPicArray objectAtIndex:0]valueForKey:@"url"];
            break;
    }
    
    web.url = url;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark-UicollectionViewDelegateFlowLayout
//定义每个UIcolletionview大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentedCtrol.selectedSegmentIndex == 0)
    {
        return CGSizeMake((kDeviceWidth-20)/3, (kDeviceWidth-20)/3+50);
    }
    else
    {
        return CGSizeMake((kDeviceWidth-20)/2, (kDeviceWidth-20)/2+50);
    }
    
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark-Collection Select delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row= indexPath.row;
    
    web.url = [[ContentListArray objectAtIndex:row]valueForKey:@"url"];
    
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark-segement
-(void)selected:(id)sender
{
    switch (segmentedCtrol.selectedSegmentIndex) {
        case 0:
            [ContentCollectionView registerClass:[CustomPicTalkCollectionViewCell class] forCellWithReuseIdentifier:@"cell3"];
            ContentListArray = TushuoArray;
            break;
        case 1:
            [ContentCollectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            ContentListArray = ShipingArray;
            break;
        default:
            [ContentCollectionView registerClass:[CustomPicTalkCollectionViewCell class] forCellWithReuseIdentifier:@"cell3"];
            ContentListArray = TushuoArray;
            break;
    }
    [ContentCollectionView reloadInputViews];
    [ContentCollectionView reloadData];

}
                                  
-(void)clickRightbutton
{
    PostViewController *postCtrol =[[PostViewController alloc]init];
    [self.navigationController pushViewController:postCtrol animated:YES];
}

#pragma mark-system delegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) backHome
{
    NSLog(@"imgood");
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
