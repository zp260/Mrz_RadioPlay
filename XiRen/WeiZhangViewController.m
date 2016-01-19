//
//  WeiZhangViewController.m
//  XiRen
//
//  Created by PIPI on 15/7/23.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "WeiZhangViewController.h"
#import "TFHpple.h"
@interface WeiZhangViewController ()


@end

@implementation WeiZhangViewController

@synthesize ContentDic;
@synthesize Controller;
@synthesize UrlParaDic;
@synthesize WeiZhangNum;
@synthesize NeedPayMoney;
@synthesize NeedPayPoint;
@synthesize ListArray;
@synthesize WeiZhangContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)initCtrol
{
    ContentDic = [[NSDictionary alloc]init];
    Controller = [[UIViewController alloc]init];
    ListArray =[[NSMutableArray alloc]init];
    UrlParaDic = [[NSDictionary alloc]init];
}
-(void)MakeParameters:(NSString *)ChePai FaDongJi:(NSString *)FaDongJi
{
    //@verify is a importent parameter
    UrlParaDic= @{@"province":@"山西",@"pinyin":@"datong",@"car_province":@"晋",@"license_plate_num":ChePai,@"body_num":FaDongJi,@"c":@"baidu_light"};
    
}
-(void) AFgetOLdata:(NSString *)ApiUrlString target:(id)target selector:(SEL)selector
{

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];



    
    [manager POST:ApiUrlString parameters:UrlParaDic
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //传递返回数据
         ContentDic = responseObject;
         [self func_back_data:responseObject];
         if (target && ListArray.count >0)
         {
             [target performSelector:selector withObject:ListArray];
         }
         else
         {
             UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"经查询您的违章为0" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"出错了" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"error:%@",error);
         
     }];
    
}

-(void)func_back_data:(NSMutableArray *)backarray
{
    if (backarray.count>0)
    {
        NSString *Status = [backarray valueForKey:@"vehicle_status"];
        if ([Status isEqualToString:@"ok"])
        {
            
            WeiZhangNum = [backarray valueForKey:@"no"];
            NeedPayPoint = [backarray valueForKey:@"totalpoint"];
            NeedPayMoney = [backarray valueForKey:@"totalfine"];
            ListArray=[backarray valueForKey:@"violations"];
            NSLog(@"违章内容是%@",backarray);
            
//            NSString *HtmlCode = [backarray valueForKey:@"html"];
//            NSData *HtmlData =[HtmlCode dataUsingEncoding:NSUTF8StringEncoding];
//            TFHpple  *xpathParser = [[TFHpple alloc]initWithHTMLData:HtmlData];
//            if ([WeiZhangNum intValue] == 0)
//            {
//                NSArray *elements =[xpathParser searchWithXPathQuery:@"//h2"];
//                
//                for (TFHppleElement *element in elements)
//                {
//                    NSString *CellLable = [[element firstChild]content];
//                }
//            }
//            else
//            {
//                NSArray *elements_Body =[xpathParser searchWithXPathQuery:@"//div/div"]; /**<获取每个违章标签 */
//                
//                for (TFHppleElement *element in elements_Body) //拆分违章信息
//                {
//                    NSMutableArray *ChildArray = [[NSMutableArray alloc]init];
//                    for (TFHppleElement *child in element.children)
//                    {
//                        
//                        [ChildArray addObject:child.content];
//                        
//                    }
//                    //NSLog(@"%@:",element.content);
//                    [self MakeBackData:ChildArray];
//                }
// 
////                [self MakeBackData:ChildArray];
//                //NSLog(@"_ListArray is %@",_ListArray);
//            }
            

        }
        
    }
    
}


-(void)MakeBackData:(NSArray *)array
{
    
    [ListArray addObject:array];
    
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
