//
//  HZCalendarLogic.h
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZCalenderDayModel.h"
#import "NSDate+WQCalendarLogic.h"

@interface HZCalendarLogic : NSObject
/**选中的日期*/
@property (nonatomic , strong) HZCalenderDayModel *selectcalendarDay;
@property (nonatomic , strong) HZCalenderDayModel *selectcalendarDay2;

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;
- (void)selectLogic:(HZCalenderDayModel *)day;
- (void)selectLogic2:(HZCalenderDayModel *)day;
- (void)canelLogic:(HZCalenderDayModel *)day;


@end
