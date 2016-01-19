//
//  WeiZhangCustomTableViewCell.m
//  XiRen
//
//  Created by PIPI on 15/7/24.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "WeiZhangCustomTableViewCell.h"

@implementation WeiZhangCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _LableDate = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth, 15)];
        _LableDate.font =[UIFont systemFontOfSize:10];
        _LableDate.textColor = [UIColor grayColor];
        
        _LableAdrres = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, kDeviceWidth, 20)];
        _LableAdrres.font =[UIFont systemFontOfSize:13];
        _LableAdrres.textColor = [UIColor colorWithRed:0/255.0f green:144.0f/255.0f blue:187.0f/255.0f alpha:1];
        
        _LableReason = [[UILabel alloc]initWithFrame:CGRectMake(5, 50, kDeviceWidth, 15)];
        _LableReason.font =[UIFont systemFontOfSize:10];
        _LableReason.textColor = [UIColor grayColor];
        
        _LableCoin = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, kDeviceWidth, 20)];
        _LableCoin.font =[UIFont systemFontOfSize:13];
        _LableCoin.textColor = [UIColor colorWithRed:0/255.0f green:144.0f/255.0f blue:187.0f/255.0f alpha:1];
        
        [self addSubview:_LableDate];
        [self addSubview:_LableAdrres];
        [self addSubview:_LableReason];
        [self addSubview:_LableCoin];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
