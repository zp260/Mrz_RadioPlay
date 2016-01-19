//
//  PostSubjectViewController.m
//  XiRen
//
//  Created by PIPI on 15-5-12.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "PostSubjectViewController.h"
#import "UserAgent.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
@interface PostSubjectViewController ()

@property (nonatomic) NSString *BrowerUserAgent;
@property (nonatomic,strong) UITextView *ContentTextFiled;
@property (strong,nonatomic) MBProgressHUD *hud;

@end

@implementation PostSubjectViewController

@synthesize BrowerUserAgent;
@synthesize FID;
@synthesize TID;
@synthesize VerifyCode;
@synthesize ContentTextFiled;


#define PostOK @"回复帖子，奖励积分"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)initUI
{
    
    UserAgent *Agent = [[UserAgent alloc]init];
    BrowerUserAgent = [Agent GetUserAgent];
    
    ContentTextFiled = [[UITextView alloc]initWithFrame:CGRectMake(20, KNavgationBarHeight+40, kDeviceWidth-40, 100)];
    ContentTextFiled.layer.cornerRadius =6;
    ContentTextFiled.layer.masksToBounds =YES;
    ContentTextFiled.layer.borderWidth=1.0;
    ContentTextFiled.delegate = self;

    
    UIBarButtonItem *rightLoginItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleBordered target:self action:@selector(postSubmit)];
    self.navigationItem.rightBarButtonItem = rightLoginItem;
    self.navigationItem.title = @"回帖";
    
    
    [self.view addSubview:ContentTextFiled];
    
}

//生成发帖参数
-(id)GiveUSomeParameters
{
    //@verify is a importent parameter
    NSDictionary *pwdic= @{@"action":@"reply",@"atc_autourl":@"1",@"atc_usesign":@"1",@"iscontinue":@"0",@"isformchecked":@"1",@"fid":FID,@"step":@"2",@"tid":TID,@"ajax":@"1",@"atc_content":ContentTextFiled.text,@"atc_convert":@"1",@"verify":VerifyCode,@"type":@"ajax_addfloor"};
    return pwdic;
}

-(void)Dopost:(NSDictionary *)paraDic url:(NSString *)url
{
    NSLog(@"paraDic%@",paraDic);
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.stringEncoding =gbkEncoding; //编码为GBK
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [manager.requestSerializer setValue:BrowerUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    [manager POST:url parameters:paraDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSString *pageSource = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
         [self CheckRquestState:pageSource];
         
         NSLog(@"operation is  %@,  HTML Body is %@",operation.response.allHeaderFields,pageSource);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"fail data is %@",error);
         
     }];
}

-(void)postSubmit
{

    NSLog(@"%@,%i",ContentTextFiled.text,ContentTextFiled.text.length);
    if (ContentTextFiled.text.length>5 && FID && TID && VerifyCode)
    {
        [self Dopost:[self GiveUSomeParameters] url:@"http://www.xiren.com/post.php"];
    }
    else if(ContentTextFiled.text.length<=5)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"回复内容长度请大于5个字符";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:2];
    }
}
-(void)CheckRquestState:(NSString *)RequestStr
{
    NSRange rangePostOK = [RequestStr rangeOfString:PostOK];
    if (rangePostOK.length>0)
    {
        
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"回帖成功";
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:2];

        NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index -1] animated:YES];
        return;

    }
    else
    {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = RequestStr;
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:2];
    }
}
-(void)textViewDidChangeSelection:(UITextView *)textView
{

    
}

#pragma mark - 判断是否登陆
-(BOOL)DoULogined
{
    NSData *userCookieData =[[NSUserDefaults standardUserDefaults] objectForKey:@"userdefaultsCookie"];
    if ([userCookieData length])
    {
        NSArray *cookies =[NSKeyedUnarchiver unarchiveObjectWithData:userCookieData];
        
        for (NSHTTPCookie *cookie in  cookies)
        {
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
        }
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

//在载入VIEW的时候判断是否登陆，没有登陆跳转到登陆界面
-(void)viewDidAppear:(BOOL)animated
{
 

    
    if ([self DoULogined])
    {
        [self initUI];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.opacity = 0.5f;
        hud.labelText = @"您尚未登陆，即将跳转到登陆界面。";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        
        //延迟两秒跳转
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(GOtoLoginCtroller) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
       
    }

}
//跳转到登陆界面
-(void)GOtoLoginCtroller
{
    LoginViewController *loginCtrol=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginCtrol animated:YES];
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
