//
//  HZCalendarCell.m
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import "HZCalendarCell.h"



@implementation HZCalendarCell

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
    
        [self setView];
    
    }
    return self;
}
-(void)setView{
    
    //选中时显示的图片
    imgview = [[UIView alloc]initWithFrame:CGRectMake(5, 15, self.bounds.size.width-10, self.bounds.size.width-10)];
    imgview.layer.masksToBounds = YES;
    imgview.layer.cornerRadius = (self.bounds.size.width-10)/2;
    imgview.backgroundColor = COLOR_THEME;
    [self addSubview:imgview];
    
    imghuoche = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-10, self.bounds.size.width-10, 10, 10)];
    imghuoche.image = [UIImage imageNamed:@"12306.png"];
    
    [self addSubview:imghuoche];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-10)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:day_lab];
    
    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
    day_title.textColor = [UIColor lightGrayColor];
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    
}


-(void)setCalenderDayModel:(HZCalenderDayModel *)calenderDayModel{
    imghuoche.hidden = YES;
    imgview.hidden = YES;

    [self setDay:calenderDayModel];

    switch (calenderDayModel.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;
        case CellDayTypePast://过去的日期
            imghuoche.hidden = YES;

            [self hidden_NO];
            if (calenderDayModel.holiday) {
                day_lab.text = calenderDayModel.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)calenderDayModel.day];
            }
            day_lab.textColor = [UIColor lightGrayColor];
            day_title.text = calenderDayModel.Chinese_calendar;
            
            break;
            
        case CellDayTypeFutur:
            //将来的日期
        {
            [self hidden_NO];
            if (calenderDayModel.holiday) {
                day_lab.text = calenderDayModel.holiday;
                day_lab.textColor = [UIColor blackColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)calenderDayModel.day];
                day_lab.textColor = COLOR_THEME;
            }
            day_title.text = calenderDayModel.Chinese_calendar;
            
        }
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (calenderDayModel.holiday) {
                day_lab.text = calenderDayModel.holiday;
                day_lab.textColor = [UIColor blackColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)calenderDayModel.day];
                day_lab.textColor = COLOR_THEME1;
            }
            
            day_title.text = calenderDayModel.Chinese_calendar;
            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)calenderDayModel.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = calenderDayModel.Chinese_calendar;
            imgview.hidden = NO;
            
            break;
            
        default:
            
            break;
    }
}
-(void)setDay:(HZCalenderDayModel *)model{
  
    //两个日期相差多少天
    long days =  [NSDate getDayNumbertoDay:[NSDate date] beforDay:[model date]];
    
    if ( self.showImageIndex > days+1 ) {
        
        imghuoche.hidden = NO;
    }
  
}
- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    imghuoche.hidden= YES;
    
}

- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
}

@end
