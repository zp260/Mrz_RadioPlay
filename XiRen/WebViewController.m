//
//  WebViewController.m
//  XiRen
//
//  Created by zhuping on 15/4/7.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "WebViewController.h"
#import "LoginViewController.h"
#import "CustNavigationBarViewController.h"
#import "PostSubjectViewController.h"

#define PostBtHight 25

@interface WebViewController ()

@property (nonatomic) NSDictionary *webHeaderCookieHeader;
@property (nonatomic) NSString *FID;
@property (nonatomic) NSString *Verify;
@property (nonatomic) NSString *TID;
@property (strong,nonatomic) NSMutableURLRequest *request;
@end

@implementation WebViewController

@synthesize url;
@synthesize UserAgent;
@synthesize XirenWebView;
@synthesize FID;
@synthesize TID;
@synthesize Verify;
@synthesize request;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];


}
-(void)loadUserCookie
{
    NSData *userCookieData =[[NSUserDefaults standardUserDefaults] objectForKey:@"userdefaultsCookie"];
    if ([userCookieData length]) {
        NSArray *cookies =[NSKeyedUnarchiver unarchiveObjectWithData:userCookieData];
        _webHeaderCookieHeader= [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        for (NSHTTPCookie *cookie in  cookies)
        {
           
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            if ([cookie.name isEqualToString:@"0d63c_winduser"])
            {
                NSLog(@"%@",cookie);
            }
            
        }
    }   
    
}
-(void)initUI
{

    self.navigationController.title = @"喜人网";
    

    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem=backbutton;

    XirenWebView =[[UIWebView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    XirenWebView.delegate =self;
    XirenWebView.scalesPageToFit=YES;
    request =[[NSMutableURLRequest alloc]init];

    [self.view addSubview:XirenWebView];
    
    
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(0, kDeviceHeight-KTabarHeight-150 , 200, 40)];
    [bt addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"输出cookie" forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor grayColor]];
    
    //[self.view addSubview:bt];
    //获取浏览器头

    NSLog(@"webview url  is %@",url);
}

-(void)test
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies])
    {
        if ([cookie.name  isEqual: @"0d63c_winduser"])
        {
            NSLog(@"**************************************************%@", cookie);
        }
        
    }
}
-(void)LoadWeb
{
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPShouldHandleCookies:YES];
    
    [XirenWebView loadRequest:request];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidDisappear:(BOOL)animated
{
    //[_webView removeFromSuperview];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self LoadWeb];
}

-(void)postSubmit
{
    LoginViewController *loginviewcontrol=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginviewcontrol animated:YES];
}

-(void)SubjectPost
{
    PostSubjectViewController  *postCtrol=[[PostSubjectViewController alloc]init];
    postCtrol.TID=TID;
    postCtrol.FID=FID;
    postCtrol.VerifyCode= Verify;
    [self.navigationController pushViewController:postCtrol animated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading)
    {
        return;
    }
    else
    {
        
        //页面加载绝对完成有点慢。。。 貌似是BAIDU的 SCRIPT造成的。。。
        FID= [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fid').item(0).getAttribute('value')"];
        Verify= [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('verify').item(0).getAttribute('value')"];
        TID= [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('tid').item(0).getAttribute('value')"];
//        NSLog(@"fid %@,%@",FID,TID);
//        NSLog(@"Verify %@",Verify);
        
        if(FID && Verify && TID)
        {
            UIBarButtonItem *rightLoginItem = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStyleBordered target:self action:@selector(SubjectPost)];
            self.navigationItem.rightBarButtonItem = rightLoginItem;
        }
        
        
        //看看源代码
//        NSString *jsGetHTMl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
//        NSLog(@"webview.html is %@",jsGetHTMl);
    }

}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self loadUserCookie];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView didFailLoadWithError %@", error);
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
