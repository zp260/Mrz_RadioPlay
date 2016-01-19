//
//  MenuData.h
//  XiRen
//
//  Created by PIPI on 15/9/13.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetGetController.h"
@interface MenuData : NSArray
{
    NSArray *MenuArray;
}
@property (nonatomic) NSArray *MenuArray;
@property (strong,nonatomic) UIViewController *ParentCtroller;
#define url @"http://www.xiren.com/api.php?action=fm_menu"

-(NSArray *)MenuListArray;
@end
