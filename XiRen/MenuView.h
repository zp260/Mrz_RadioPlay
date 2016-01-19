//
//  MenuView.h
//  XiRen
//
//  Created by PIPI on 15/8/21.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView
{
    CGPoint openPointCenter;
    CGPoint closePointCenter;

}
- (id)initWithView:(UIView *)contentview parentView:(UIView *)parentview parentController:(UIViewController *)parentController;
-(void)showView;

@property (nonatomic, strong) UIView *parentView; //抽屉视图的父视图
@property (nonatomic, strong) UIView *contenView; //抽屉显示内容的视图
@property (nonatomic,strong)    UIViewController *parentViewController;
@end
