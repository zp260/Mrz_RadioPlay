//
//  ImagePickViewController.h
//  XiRen
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    //输入框
    UITextView *_textEditor;
    
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
}
@end
