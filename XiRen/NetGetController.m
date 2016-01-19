//
//  NetGetController.m
//  XiRen
//
//  Created by PIPI on 15/7/3.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "NetGetController.h"

@interface NetGetController ()

@end

@implementation NetGetController

@synthesize ContentArray;
@synthesize Controller;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initCtrol
{
    ContentArray = [[NSArray alloc]init];
    Controller = [[UIViewController alloc]init];
}
-(void) AFgetOLdata:(NSString *)ApiUrlString target:(id)target selector:(SEL)selector parameters:(NSDictionary *)parameters
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager GET:ApiUrlString parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //传递返回数据
         [self func_back_data:responseObject];
         if(selector && target)
         {
             [target performSelector:selector withObject:ContentArray];
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"出错了" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"json:%@",error);
         
     }];
    
}

-(void)func_back_data:(NSMutableArray *)backarray
{
    ContentArray=nil;
    if (backarray.count>0) {
        ContentArray = backarray;
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
