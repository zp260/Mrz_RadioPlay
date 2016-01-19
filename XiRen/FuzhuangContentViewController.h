//
//  FuzhuangContentViewController.h
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuzhuangContentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UITableView* ChangjingTable;
@property (nonatomic,strong)UISegmentedControl *ContentSeg;
@property (nonatomic,strong)UICollectionView *ClothesCollection;
@property (nonatomic,strong)NSMutableArray *ChangjingImageArray;
@property (nonatomic,strong)NSMutableArray *ClothesImageArray;
@property (strong,nonatomic) UITabBarController *HomeTab;
@property (retain,nonatomic) UIImage *lodingIMG;    //初始化loading动画图片
@end
