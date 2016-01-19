//
//  PictureContentViewController.h
//  XirenPhoto
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 PIPI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureContentViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString *webaddress;
@property(nonatomic,strong)UIWebView *web;

@end
