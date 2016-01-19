//
//  PostViewController.m
//  XiRen
//
//  Created by mac on 15/12/22.
//  Copyright © 2015年 zhuping. All rights reserved.
//

#import "PostViewController.h"
#import "ImagePickViewController.h"
#import "MLSelectPhotoPickerViewController.h"
@interface PostViewController ()

@end

@implementation PostViewController
@synthesize NewFrame;
@synthesize bbsImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
-(void)initUI
{
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightbutton)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    UITextField *bbsTitle=[[UITextField alloc]initWithFrame:CGRectMake(0, KNavgationBarHeight, kDeviceWidth, 40)];
//    bbstitle.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bbsTitle];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, bbsTitle.bottom, kDeviceWidth, 1)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UITextView *bbsContent=[[UITextView alloc]initWithFrame:CGRectMake(0, line.bottom, kDeviceWidth, kDeviceHeight/2)];
    bbsContent.font=[UIFont systemFontOfSize:15];
//    bbsContent.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bbsContent];
    
    
//活动Tabbar
    NewFrame=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-KTabarHeight-50, kDeviceWidth, 50)];
    NewFrame.backgroundColor=[UIColor lightGrayColor];
//发帖添加图片

    bbsImage=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
    [bbsImage addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
    bbsImage.backgroundColor=[UIColor blueColor];
    [NewFrame addSubview:bbsImage];
    
    [self.view addSubview:NewFrame];
    

}

#pragma mark-buttonView移动方法
- (void)keyboardWillShow:(NSNotification *)aNotification


{
    
    if (!NewFrameHasMoved)
    {
        NSDictionary *userInfo = [aNotification userInfo];
        
        CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                               
                               CGRectValue];
        NSTimeInterval animationDuration = [[userInfo
                                             
                                             objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGRect newFrame = NewFrame.frame;
        newFrame.size.height -= keyboardRect.size.height;
        
        [UIView beginAnimations:@"ResizeTextView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        NewFrame.frame = newFrame;
        NewFrameHasMoved=true;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification


{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect newFrame = NewFrame.frame;
    newFrame.size.height += keyboardRect.size.height;
    
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    NewFrame.frame = newFrame;
    
    [UIView commitAnimations];
}
//添加图片点击事件

-(void)clickImage
{

//    ImagePickViewController *ImagePickCtrol =[[ImagePickViewController alloc]init];
//    [self.navigationController pushViewController:ImagePickCtrol animated:YES];
    // Do any additional setup after loading the view.
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentModalViewController:pickerImage animated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
                                   CGRectMake(50, 120, 40, 40)];
        
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
        
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    NewFrameHasMoved=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
