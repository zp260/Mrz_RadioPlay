//
//  PostViewController.h
//  XiRen
//
//  Created by mac on 15/12/22.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    BOOL NewFrameHasMoved;
    
    //输入框
    UITextView *_textEditor;
        
    //下拉菜单
    UIActionSheet *myActionSheet;
        
    //图片2进制路径
    NSString* filePath;
    

}
@property(nonatomic,strong)UIView *NewFrame;
//发帖添加图片
@property(nonatomic,strong)UIButton* bbsImage;
@end
