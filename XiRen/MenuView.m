//
//  MenuView.m
//  XiRen
//
//  Created by PIPI on 15/8/21.
//  Copyright (c) 2015年 zhuping. All rights reserved.
//

#import "MenuView.h"
#define OPENCENTERX 220.0
#define DIVIDWIDTH 70.0 //OPENCENTERX 对应确认是否打开或关闭的分界线。
#define DIVHeight 70.0
@implementation MenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (id)initWithView:(UIView *)contentview parentView:(UIView *)parentview parentController:(UIViewController *)parentController
{
    self = [super initWithFrame:CGRectMake(0,0,contentview.frame.size.width, contentview.frame.size.height)];
    
    
    if (self)
    {
        self.contenView = contentview;
        self.parentView = parentview;
        self.parentViewController = parentController;
        
        [self addSubview:contentview];
//        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
//                                                        initWithTarget:self
//                                                        action:@selector(handlePan:)];
//        [self addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handleTap:)];
        
        [self addGestureRecognizer:tapGestureRecognizer];
        openPointCenter = CGPointMake(self.parentView.center.x,
                                      self.parentView.center.y);
        
        NSLog(@"openPointCenter x:%f, openPointCenter y:%f",
              openPointCenter.x,
              openPointCenter.y);
        
        
    }
    
    
    
    return self;
}

-(void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.parentView];
    
    float y = self.center.y + translation.y;
    NSLog(@"translation y:%f", translation.y);
    
    if (y > self.parentView.center.y)
    {
        y = self.parentView.center.y;
    }
    self.center = CGPointMake(openPointCenter.x, y);
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.75
                              delay:0.01
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void)
         {
             if (y > openPointCenter.y -  DIVIDWIDTH)
             {
                 self.center = CGPointMake(openPointCenter.x,y);
             }
             else
             {
                 self.center = CGPointMake(openPointCenter.x,
                                           openPointCenter.y- kDeviceHeight-KNavgationBarHeight);
                 if(self.parentViewController)
                 {
                     [self.parentViewController performSelector:@selector(transformArrow:) withObject:Nil];
                 }

                 
             }
             
         }completion:^(BOOL isFinish){
             
         }];
    }
    
    [recognizer setTranslation:CGPointZero inView:self.parentView];
}

-(void) handleTap:(UITapGestureRecognizer*) recognizer
{
    [UIView animateWithDuration:0.75
                          delay:0.01
                        options:UIViewAnimationTransitionCurlUp animations:^(void)
    {
                            self.center = CGPointMake(openPointCenter.x,openPointCenter.y- kDeviceHeight-KNavgationBarHeight);
        
    }
                     completion:nil];
    if(self.parentViewController)
    {
        [self.parentViewController performSelector:@selector(transformArrow:) withObject:Nil];
    }

    
}
-(void)showView
{
    if(self.center.y==openPointCenter.y)
    {
        NSLog(@"IM in show");
    }
    [UIView animateWithDuration:0.75
                          delay:0.01
                        options:UIViewAnimationTransitionCurlUp animations:^(void)
     {
         self.center = CGPointMake(openPointCenter.x,openPointCenter.y);
         
     }
                     completion:nil];
    }
@end
