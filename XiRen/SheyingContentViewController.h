//
//  SheyingContentViewController.h
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheyingContentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UISegmentedControl *ContentSeg;
@property (nonatomic,strong)UITableView *SheyingshiTable;
@property (nonatomic,strong)UICollectionView *HuazhuangshiCollection;
@property (nonatomic,strong)NSMutableArray *SheyingshiImageArray;
@property (nonatomic,strong)NSMutableArray *HuazhuangshiImageArray;
@property (retain,nonatomic) UIImage *lodingIMG;    //初始化loading动画图片
@end
