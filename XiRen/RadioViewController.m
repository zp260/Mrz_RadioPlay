//
//  RadioViewController.m
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "RadioViewController.h"
#import "ChatTableViewCell.h"
#import "ChatViewController.h"
#import "XirenCoustNav.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "NetGetController.h"


@interface RadioViewController ()

@property (strong,nonatomic) UIButton *PlayControlBT;
@property (strong,nonatomic) NSString *trackViewUrl;
@property (strong,nonatomic) UIImageView *ArrowsImageView;


@end

@implementation RadioViewController

@synthesize PlayControlBT;
@synthesize callcenter = _callcenter;
@synthesize ArrowsImageView;
@synthesize drawState;
@synthesize meunContentView;
@synthesize muneview;
@synthesize NowPlayMenu;


- (void)viewDidLoad {
    NSLog(@"titleview %@",self.navigationController.navigationItem.titleView);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _listening = 0;

    [self initUI];
    [self initAudio];
    [self initMenuData];
    [self initMenuViewCtroller];
    //[self onCheckVersion]; //验证版本更新并提示
    NSTimer *timer= [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(FreshTimer) userInfo:nil repeats:YES];
    
    _callcenter = [[CTCallCenter alloc]init];
    __strong typeof(self) StrongSelf = self;
    _callcenter.callEventHandler = ^(CTCall *call)
    {
        
        if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"Call has been Connected");
        }
        else if([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"Call has been disconnected");
            if (StrongSelf->_listening)
            {
                [StrongSelf play];
            }
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            if([StrongSelf->_mediaplayer isPlaying])
            {
                StrongSelf->_listening = 1;
                [StrongSelf pause];
            }
            NSLog(@"Call is incoming");
        }
        else if([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"call is dialing");  
        }
        else
        {
            
        }
    };
}
/**
 *  刷新核对时间与节目列表的定时器，每一分钟核对一次时间
 */

-(void)FreshTimer
{
    if (self.MenuDLArray.count>0)
    {
        [self checkTime_FreshLable];
    }
}
-(void)initUI
{
    // 自定义nav TITLE view
    UIView *MidView = [[UIView alloc]init];
    MidView.frame = CGRectMake(0, 0, 150, KNavgationBarHeight);
    
    UILabel *title = [[UILabel alloc] init];
    title.frame=CGRectMake(0, 15, 150, 25);
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont yaheiFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"喜人乐播FM961";
    
    ArrowsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75-4, 54-10, 8, 8)];
    ArrowsImageView.image = [UIImage imageNamed:@"DownArrows"];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, KNavgationBarHeight)];
    [bt addTarget:self action:@selector(NavTouchDown) forControlEvents:UIControlEventTouchUpInside];
    
    [MidView addSubview:title];
    [MidView addSubview:ArrowsImageView];
    [MidView addSubview:bt];
    
    //设置起始状态
    drawState = DrawerViewStateDown;
    
    //自定义NAV BAR 部分
    XirenCoustNav *selfNav = [[XirenCoustNav alloc]init];

    [selfNav initXirenNav:self TitleView:MidView WithTitle:nil];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_video"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonPressed:)];
//    rightItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_chat"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoChatRoom)];
//    leftitem.tintColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    
    //收听控制播放按钮
    PlayControlBT = [[UIButton alloc]init];
    PlayControlBT=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    PlayControlBT.frame=CGRectMake(kDeviceWidth/2-32, kDeviceHeight-KTabarHeight-128, 64, 64);
    [PlayControlBT addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [PlayControlBT setBackgroundImage:[UIImage imageNamed:@"home_btn_play"] forState:UIControlStateNormal];
    UIImageView *HomePic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceWidth*0.43)];
    HomePic.image=[UIImage imageNamed:@"home_bg"];
    [self.view addSubview:HomePic];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]]];
    [self.view addSubview:PlayControlBT];
    
    NowPlayMenu = [[UILabel alloc]initWithFrame:CGRectMake(0, PlayControlBT.top-60, kDeviceWidth, 30)];
    NowPlayMenu.textAlignment = NSTextAlignmentCenter;
    NowPlayMenu.textColor = [UIColor xrBlackColor];
    
    [self.view addSubview:NowPlayMenu];

}
-(void)initMenuData
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"i get data %@",responseObject);

         
         if (responseObject)
         {
             self.MenuDLArray = responseObject;
             [self checkTime_FreshLable];
             [self configNowPlayingInfoCenter];
         }
         

     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"出错了" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"json:%@",error);
         
     }];

}
-(void)checkTime_FreshLable
{
    NSDate *now= [[NSDate alloc]init];
    NSDate *nowTime = [self string2Date:[self dateToString:now]];
    NSInteger week =  [now mt_weekdayOfWeek];//星期几
    if (self.MenuDLArray.count>0)
    {
        if ( week == 1)
        {
            for (id object in [self.MenuDLArray objectAtIndex:1])
            {
                NSString *startTime =[object valueForKey:@"start_time"];
                NSString *endTime = [object valueForKey:@"end_time"];
                //            NSString *start_time_str = [NSString stringWithFormat:@"%lu-%lu-%lu %@",(unsigned long)[now mt_year],(unsigned long)[now mt_monthOfYear],(unsigned long)[now mt_dayOfMonth],[object valueForKey:@"start_time"]];
                //
                if ([nowTime mt_isAfter:[self string2Date:startTime]] && [nowTime mt_isBefore:[self string2Date:endTime]])
                {
                    if ([object valueForKey:@"name"])
                    {
                        NSLog(@"节目名称 %@",[object valueForKey:@"name"]);
                        self.NowPlayMenu.text= [NSString stringWithFormat:@"您现在收听的节目是:%@",[object valueForKey:@"name"]];
                    }
                    else
                    {
                        self.NowPlayMenu.text=@"目前没有直播节目";
                    }
                }
                else
                {
                    
                }
                
            }

        }
        else if(week ==7)
        {
            self.NowPlayMenu.text=@"目前没有直播节目";
        }
        else
        {
            for (id object in [self.MenuDLArray objectAtIndex:0])
            {
                NSString *startTime =[object valueForKey:@"start_time"];
                NSString *endTime = [object valueForKey:@"end_time"];
                //            NSString *start_time_str = [NSString stringWithFormat:@"%lu-%lu-%lu %@",(unsigned long)[now mt_year],(unsigned long)[now mt_monthOfYear],(unsigned long)[now mt_dayOfMonth],[object valueForKey:@"start_time"]];
                //
                if ([nowTime mt_isAfter:[self string2Date:startTime]] && [nowTime mt_isBefore:[self string2Date:endTime]])
                {
                    if ([object valueForKey:@"name"])
                    {
                        NSLog(@"节目名称 %@",[object valueForKey:@"name"]);
                        self.NowPlayMenu.text= [NSString stringWithFormat:@"您现在收听的节目是:%@",[object valueForKey:@"name"]];
                    }
                    else
                    {
                        self.NowPlayMenu.text=@"目前没有直播节目";
                    }
                }
//                else
//                {
//                    self.NowPlayMenu.text=@"目前没有直播节目";
//                }
                
            }
            
            

        }
    }
}
/**
 *  滚动节目列表
 */
-(void)startScroolLable
{
    CGRect frame = NowPlayMenu.frame;
    frame.origin.x = -180;
    NowPlayMenu.frame = frame;
    
    
    [UIView beginAnimations:@"testAnimation" context:nil];
    [UIView setAnimationDuration:14.0f];
    [UIView setAnimationCurve:  UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];

    frame = NowPlayMenu.frame;
    frame.origin.x = 350;
    NowPlayMenu.frame = frame;
    
    [UIView commitAnimations];
    

}
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"日期字符是：%@",dateString);
    return dateString;
}
-(NSDate *)string2Date:(NSString *)string
{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateStyle = kCFDateFormatterFullStyle;
    formater.dateFormat = @"HH:mm:ss";
    NSDate *date = [formater dateFromString:string];
    NSLog(@"格式转换的字符是%@，转换完成后的时间是%@",string,date);
    [self dateToString:date];
    return date;
    
}

-(void)initMenuViewCtroller
{
    self._menuTableCtrol = [[MenuTableViewController alloc]init];
    
    [self._menuTableCtrol initTableView];
}
#pragma mark-system delegate
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self updatePlayButton];

}
-(void)gotoChatRoom
{
    ChatViewController *chatRoomCtrl=[[ChatViewController alloc]init];
    [self.navigationController pushViewController:chatRoomCtrl animated:YES];
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo]objectForKey:UIKeyboardBoundsUserInfoKey]CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect frame = self.view.frame;
    frame.size.height+= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [UIView commitAnimations];
}

#pragma mark-Audio Control
-(void)PlayOrStopCtrol
{
    if ([_mediaplayer isPlaying])
    {
        [self pause];
    }
    else
    {
        [self play];
    }
    NSLog(@"audio state is %hhd",[_mediaplayer isPlaying]);
}


- (void)initAudio
{
    _mediaplayer = [[VLCMediaPlayer alloc] initWithOptions:nil];
    _mediaplayer.delegate = self;
    //    _mediaplayer.drawable = self.movieView;
    
    
    /* create a media object and give it to the player */
    _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:MmsUrl]];
    //[_mediaplayer play];

}

- (void)play
{
    if ([_mediaplayer isPlaying])
    {
        return;
    }
    
    [_mediaplayer play];
}

- (void) pause
{
    if (![_mediaplayer isPlaying])
    {
        return;
    }
    
    [_mediaplayer pause];
}

- (void)buttonPressed:(id)sender
{
    if ([_mediaplayer isPlaying])
    {
        [self pause];
    }
    else
    {
        [self play];
    }
    NSLog(@"audio state is %hhd",[_mediaplayer isPlaying]);
}

- (void)updatePlayButton
{
    if ([_mediaplayer isPlaying])
    {
        [PlayControlBT setBackgroundImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    }
    else
    {
        
        [PlayControlBT setBackgroundImage:[UIImage imageNamed:@"home_btn_play"] forState:UIControlStateNormal];
    }

}


#pragma mark - VLC

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    
    [self updatePlayButton];
    NSLog(@"mediaPlayerStateChanged :the state is: %hhd",[_mediaplayer isPlaying]);
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    
}

#pragma mark-锁屏设置相关代码
-(void)configNowPlayingInfoCenter
{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"喜人乐播" forKey:MPMediaItemPropertyTitle];
//        [dict setObject:@"singer" forKey:MPMediaItemPropertyArtist];
        if (NowPlayMenu.text)
        {
            [dict setObject:NowPlayMenu.text forKey:MPMediaItemPropertyAlbumTitle];

        }
        
        UIImage *image = [UIImage imageNamed:@"home_bg"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}
#pragma mark-检查更新

-(void)onCheckVersion
{
    NetGetController *CheckUPdate = [[NetGetController alloc]init];
    [CheckUPdate AFgetOLdata:APPInfoUrl target:self selector:@selector(CheckVersionStep1:) parameters:nil];
    
}

-(void)CheckVersionStep1:(NSArray *)BackArray
{
    if(BackArray.count>0)
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NSArray *infoArray = [BackArray valueForKey:@"results"];
        if ([infoArray count])
        {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            
            if (![lastVersion isEqualToString:currentVersion])
            {
                _trackViewUrl  = [releaseInfo objectForKey:@"trackViewUrl"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                [alert show];
                
            }
        }

    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:_trackViewUrl]];
    }
    
}

#pragma mark-抽屉事件

/*
 *  transformArrow 改变箭头方向
 *  state  DrawerViewState 抽屉当前状态
 */
-(void)transformArrow:(DrawerViewState) state
{
    //NSLog(@"DRAWERSTATE :%d  STATE:%d",drawState,state);
    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (state == DrawerViewStateUp)
        {
            ArrowsImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            ArrowsImageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
                     completion:^(BOOL finish)
    {
        drawState = state;
    }];
    
    
}
//三角点击事件
-(void)NavTouchDown
{
    
    
    if (drawState == DrawerViewStateDown)
    {

        [self transformArrow:DrawerViewStateUp];
        [self MakeMenuListView];
        NSLog(@"touch down");
    }
    else
    {

        [self transformArrow:DrawerViewStateDown];
        [muneview showView];
    }
    
    
    
}
-(void)MakeMenuListView
{
    
    if (!meunContentView)
    {
        meunContentView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavgationBarHeight, kDeviceWidth, kDeviceHeight)];
        

        [meunContentView addSubview:self._menuTableCtrol.view];
         muneview = [[MenuView alloc]initWithView:meunContentView parentView:self.view parentController:self];
         [self.view addSubview:muneview];

    }
    else
    {

        

    }
    

    
    
}
#pragma mark - system
-(void)viewDidAppear:(BOOL)animated
{
    [self startScroolLable];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}
@end
