//
//  CarClubViewController.h
//  XiRen
//
//  Created by mac on 15/12/10.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHScrollAndPageView.h"

#define _Scrool_height 200
@interface CarClubViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UIScrollView *_scrollView;
    
    NSMutableArray *slideImages;
    
    UIPageControl *_page;
    
    NSArray *WeizhangArray;
    
    
}
@property (nonatomic,strong)UIView *carView1;
@property (nonatomic,strong)UIView *carView2;
@property (nonatomic,strong)UIView *carView3;
@property (nonatomic,strong)UIView *carView4;
@property (nonatomic,strong)UITableView *carTable;
@property (nonatomic,strong)UITableView *shopTable;
@property (nonatomic,strong)UITableView *weizhangTable;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *LunboImageArray;
@property(nonatomic,strong)NSMutableArray *HuodongImageArray;
@property(nonatomic,strong)NSMutableArray *ShangjiaArray;
@property (retain,nonatomic) UIImage *lodingIMG;    //初始化loading动画图片
@property (nonatomic,strong)UIScrollView *HomeScrollView;
@end
