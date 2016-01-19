//
//  CarViewController.h
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "LoadingImageview.h"
#include "XirenCoustNav.h"
#include "CustomCollectionViewCell.h"
#include "CustomPicTalkCollectionViewCell.h"
#include "NetGetController.h"
#include "MBProgressHUD.h"
#include "WebViewController.h"
#import "PostViewController.h"
@interface HomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *TuShuoClickArr;
}

@property (strong,nonatomic) UICollectionView *ContentCollectionView;
@property (retain,nonatomic) UIImage *lodingIMG;    //初始化loading动画图片
@property (strong,nonatomic) UISegmentedControl *segmentedCtrol;
@property (strong,nonatomic) NetGetController *netGetController;
@property (strong,nonatomic) NSMutableArray *TuShuoImageArray;
@property (strong,nonatomic) NSMutableArray *ShiPingImageArray;
@property (strong,nonatomic) NSArray *TushuoArray;
@property (strong,nonatomic) NSArray *ShipingArray;
@property (strong,nonatomic) NSArray *ContentListArray;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) NSMutableArray *Pic_BigPicImageArray;
@property (strong,nonatomic) NSMutableArray *Video_BigPicImageArray;
@property (strong,nonatomic) NSArray *Pic_BigPicArray;
@property (strong,nonatomic) NSArray *Video_BigPicArray;
@property (retain,nonatomic) WebViewController *web;

#define ZtableviewX 0
#define ZtableviewY 0 //与navigationbar hight 一样
#define ZscroolviewX 0
#define ZscroolviewY 0
#define ScroolViewHeight 180
#define cellheight 50
#define AD_height 150
#define API_Url @"http://www.xiren.com/androidapi.php?action=picture_video_activity"

@end
