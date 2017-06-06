//
//  HZCalenderDayModel.m
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import "HZCalenderDayModel.h"

@implementation HZCalenderDayModel


+(instancetype)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    HZCalenderDayModel *calendarDay = [[HZCalenderDayModel alloc] init];//初始化自身
    calendarDay.year = year;
    calendarDay.month = month;
    calendarDay.day = day;
    return calendarDay;
}
//返回当前天的NSDate对象
- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

//返回当前天的NSString对象
- (NSString *)toString
{
    NSDate *date = [self date];
    NSString *string = [date stringFromDate:date];
    return string;
}


//返回星期
- (NSString *)getWeek
{
    
    NSDate *date = [self date];
    NSString *week_str = [date compareIfTodayWithDate];
    return week_str;
}
@end
