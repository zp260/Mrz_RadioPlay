//
//  MenuTableViewController.h
//  XiRen
//
//  Created by PIPI on 15/8/21.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetGetController.h"
#define url @"http://www.xiren.com/api.php?action=fm_menu"
@interface MenuTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     UITableView *table;
}
@property (strong,nonatomic) NSArray *menuArray;
@property (strong,nonatomic) UITableView *table;
-(void)downLoadData;
-(void)initTableView;
@end
