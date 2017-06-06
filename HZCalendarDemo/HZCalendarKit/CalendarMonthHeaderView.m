
//
//  CalendarMonthHeaderView.m
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//


#import "CalendarMonthHeaderView.h"


@interface CalendarMonthHeaderView ()

@end


#define CATDayLabelWidth  40.0f
#define CATDayLabelHeight 20.0f

@implementation CalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.0f, bounds.size.width - 20.f, 30.f)];
    [masterLabel setBackgroundColor:[UIColor clearColor]];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = COLOR_THEME;
    [self addSubview:self.masterLabel];
    
    CGFloat xOffset = 5.0f;
    CGFloat yOffset = 45.0f;

    CGFloat Width = (bounds.size.width -10) /7.0;
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0 ; i<weekArray.count; i++) {
        //一，二，三，四，五，六，日
        UILabel *dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset + Width*i,yOffset,Width , CATDayLabelHeight)];
        [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
        [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
        dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
        dayOfTheWeekLabel.textColor = COLOR_THEME1;
        dayOfTheWeekLabel.text = weekArray[i];
        [self addSubview:dayOfTheWeekLabel];
    }
    
    
}


@end
