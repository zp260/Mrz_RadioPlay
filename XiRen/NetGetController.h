//
//  NetGetController.h
//  XiRen
//
//  Created by PIPI on 15/7/3.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetGetController : UIViewController
@property (nonatomic,strong) NSArray *ContentArray;
@property (nonatomic,strong) UIViewController *Controller;

-(void) AFgetOLdata:(NSString *)ApiUrlString target:(id)target selector:(SEL)selector parameters:(NSDictionary *)parameters;

@end
