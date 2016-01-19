//
//  WeiZhangViewController.h
//  XiRen
//
//  Created by PIPI on 15/7/23.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiZhangViewController : UIViewController
{
    NSString *WeiZhangNum;
    NSString *NeedPayPoint;
    NSString *NeedPayMoney;
    
}
@property (nonatomic,readwrite,strong) NSDictionary *ContentDic;
@property (nonatomic,strong) UIViewController *Controller;
@property (nonatomic,strong) NSDictionary *UrlParaDic;
@property (strong,nonatomic) NSMutableArray *ListArray;

@property (nonatomic) NSString *WeiZhangNum;
@property (nonatomic) NSString *NeedPayPoint;
@property (nonatomic) NSString *NeedPayMoney;
@property (nonatomic,strong)NSMutableArray *WeiZhangContent;
-(void) AFgetOLdata:(NSString *)ApiUrlString target:(id)target selector:(SEL)selector;
-(void)initCtrol;
-(void)MakeParameters:(NSString *)ChePai FaDongJi:(NSString *)FaDongJi;

@end
