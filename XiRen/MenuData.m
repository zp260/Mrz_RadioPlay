//
//  MenuData.m
//  XiRen
//
//  Created by PIPI on 15/9/13.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "MenuData.h"
@implementation MenuData
@synthesize MenuArray=_MenuArray;
@synthesize ParentCtroller;
#pragma mark-初始化下载节目列表数据

-(void)InitData
{
    NetGetController *_netget = [[NetGetController alloc]init];
    [_netget AFgetOLdata:url target:self selector:(@selector(getBackData:)) parameters:nil];
}
-(void)getBackData:(NSArray *)backArray
{

    MenuArray = [[NSArray alloc]init];
    MenuArray = backArray;
}

-(NSArray *)MenuListArray
{

    if (self)
    {
        return MenuArray;
    }
    else
    {
            return nil;
    }
    
}
@end
