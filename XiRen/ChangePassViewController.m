//
//  ChangePassViewController.m
//  XiRen
//
//  Created by PIPI on 15/8/4.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "ChangePassViewController.h"
#import "MBProgressHUD.h"
#import "RegisterViewController.h"
#import "UserAgent.h"
@interface ChangePassViewController ()

@property (strong,nonatomic) MBProgressHUD *hud;

@end

@implementation ChangePassViewController

@synthesize name;
@synthesize password;
@synthesize postUrl;
@synthesize postUrlstr;
@synthesize userInput;
@synthesize PasswordInput;
@synthesize LoginRequestState;
@synthesize BrowerUserAgent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initUI
{
    UIBarButtonItem *rightLoginItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(GoToRegsiter)];
    self.navigationItem.rightBarButtonItem = rightLoginItem;
    
    UserAgent *UserAgentCtroller= [[UserAgent alloc]init];
    BrowerUserAgent =[UserAgentCtroller GetUserAgent];
    
    
    postUrlstr = @"http://www.xiren.com/login.php";
    userInput =[[UITextField alloc]initWithFrame:CGRectMake((kDeviceWidth-200)/2, 100, 200, 50)];
    userInput.placeholder = @"请输入用户名";
    [userInput setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [userInput setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    userInput.borderStyle = UITextBorderStyleRoundedRect;
    userInput.clearButtonMode= UITextFieldViewModeAlways;
    
    
    
    PasswordInput = [[UITextField alloc]initWithFrame:CGRectMake((kDeviceWidth-200)/2, 200, 200, 50)];
    PasswordInput.placeholder =@"请输入密码";
    PasswordInput.secureTextEntry = YES;
    [PasswordInput setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [PasswordInput setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    PasswordInput.borderStyle= UITextBorderStyleRoundedRect;
    
    UIButton *submitBT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBT.frame=CGRectMake((kDeviceWidth-200)/2, 300, 200, 50);
    [submitBT setTitle:@"提交" forState:UIControlStateNormal];
    [submitBT addTarget:self action:@selector(DoPost) forControlEvents:UIControlEventTouchUpInside];
    [submitBT setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:userInput];
    [self.view addSubview:PasswordInput];
    [self.view addSubview:submitBT];
    
    NSString *LoginOK = @"您已经顺利登录";
    NSString *UserNotExist = @"不存在";
    NSString *PasswordWrong = @"用户名或密码错误";
    LoginRequestState = [[NSArray alloc]initWithObjects:LoginOK,UserNotExist,PasswordWrong, nil];
    
}

/**
 *  oldpwd 原密码
 *  propwd 新密码
 *  check_pwd 确认密码
 *  proemail 电子信箱
 *  verify 验证机制码
 *
 *  @return 返回POST所用的参数
 */

-(id)getPostParameters
{
    NSDictionary *pwdic= @{@"info_type":@"safe",@"step":@2,@"check_pwd":name,@"oldpwd":@31536000,@"propwd":@"",@"proemail":@"",@"verify":@""};
    return pwdic;
}
-(void)CheckRequestState:(NSString *)RequestStr
{
    
    NSRange rangeLogin = [RequestStr rangeOfString:[LoginRequestState objectAtIndex:0]];
    if (rangeLogin.length>0)
    {
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.xiren.com"]];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        NSUserDefaults *defaultsMsg = [NSUserDefaults standardUserDefaults];
        [defaultsMsg setObject:data forKey:@"userdefaultsCookie"];
        [defaultsMsg setObject:name forKey:@"username"];
        
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"登陆成功";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:2];
        NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index -1] animated:YES];
        return;
        
    }
    
    NSRange rangeUserNotExist = [RequestStr rangeOfString:[LoginRequestState objectAtIndex:1]];
    if (rangeUserNotExist.length>0)
    {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"用户不存在";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:2];
        [userInput becomeFirstResponder];
        return;
    }
    
    NSRange rangePasswordWrong = [RequestStr rangeOfString:[LoginRequestState objectAtIndex:2]];
    if (rangePasswordWrong.length>0)
    {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"用户密码错误";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:2];
        [PasswordInput becomeFirstResponder];
        return;
    }
}
-(void)Checkpassword:(NSDictionary *)paraDic url:(NSString *)url
{
    
    
    
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSURL *xirenUrl = [[NSURL alloc]initWithString:url];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = gbkEncoding;
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    
    
    [manager.requestSerializer setValue:BrowerUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    [manager POST:url parameters:paraDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSString *pageSource = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
         [self CheckRequestState:pageSource];
         
         NSLog(@"operation is  %@, sucsess data is %@, HTML Body is %@",operation.response.allHeaderFields,[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies],pageSource);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail data is %@",error);
         
     }];
}
-(void)DoPost
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发送中...";
    _hud.opacity = 0.5f;
    name=userInput.text;
    password = PasswordInput.text;
    if (name.length ==0)
    {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入账号";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1];
        
    }
    else if (password.length == 0 )
    {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入密码";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1];
    }
    else
    {
        [self Checkpassword:[self getPostParameters] url:postUrlstr];
    }
    
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
