//
//  RadioViewController.h
//  XiRen
//
//  Created by zhuping on 15/3/31.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import <XMPP.h>
#import <XMPPRoom.h>
#import <XMPPRoster.h>
#import <XMPPRoomMemoryStorage.h>
#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "MenuView.h"
#import "MenuTableViewController.h"
#import "MenuData.h"
#import <MTDates/NSDate+MTDates.h>
#define url @"http://www.xiren.com/api.php?action=fm_menu" //节目列表数据URL

typedef enum
{
    DrawerViewStateUp = 0,
    DrawerViewStateDown = 1
}DrawerViewState;

@interface RadioViewController : UIViewController<VLCMediaPlayerDelegate,UIAlertViewDelegate>
{
    VLCMediaPlayer *_mediaplayer;
    CTCallCenter   *_callcenter;
    int _listening;
}
@property (retain,nonatomic) CTCallCenter *callcenter;
@property (nonatomic) DrawerViewState drawState;
@property (nonatomic,strong)     UIView *meunContentView;
@property (nonatomic,strong) MenuView *muneview;
@property (nonatomic,strong) MenuTableViewController *_menuTableCtrol;
@property (nonatomic,strong) UILabel *NowPlayMenu;
@property (nonatomic) NSArray *MenuDLArray;
-(void)PlayOrStopCtrol;
@end
