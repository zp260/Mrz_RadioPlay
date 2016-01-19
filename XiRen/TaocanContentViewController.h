//
//  TaocanContentViewController.h
//  XirenPhoto
//
//  Created by PIPI on 15/10/27.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaocanContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *TaocanArray;
@property (nonatomic,strong)UITableView *TaocanTable;
@property (strong,nonatomic) UITabBarController *HomeTab;
@property (retain,nonatomic) UIImage *lodingIMG;    //初始化loading动画图片
@end
