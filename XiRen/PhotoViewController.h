//
//  PhotoViewController.h
//  XiRen
//
//  Created by pipi on 15/9/22.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XirenCoustNav.h"
#import "TaocanViewController.h"
#import "SheyingViewController.h"
#import "FuzhuangViewController.h"
#import "WomenViewController.h"
#import "UIView+Extension.h"
#import "WHScrollAndPageView.h"

#define _Scrool_height 200
@interface PhotoViewController : UIViewController <UIScrollViewDelegate>


{
    UIScrollView *_scrollView;
    
    NSMutableArray *slideImages;
    
    UIPageControl *_page;
    
    
}
@property (nonatomic,strong)UIScrollView *HomeScrollView;
@property(nonatomic,strong)UIImageView *HomeGuanggao;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *ClothesImageArray;
@end
