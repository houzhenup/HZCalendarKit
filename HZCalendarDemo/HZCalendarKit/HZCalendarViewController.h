//
//  HZCalendarViewController.h
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZCalenderDayModel.h"
#import "HZCalendarLogic.h"


typedef void (^CalendarBlock)(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay);

@interface HZCalendarViewController : UIViewController

//点击选择的日期回调
@property (nonatomic, copy) CalendarBlock calendarblock;
/**展示多少天的预售图标*/
@property (nonatomic , assign)long showImageIndex;
/**是否往返 */
@property (nonatomic , assign)BOOL isGoBack;

/**去程DayModel*/
@property (nonatomic , strong)HZCalenderDayModel *CalendarGo;
/**返程DayModel*/
@property (nonatomic , strong)HZCalenderDayModel *CalendarBack;

//便利构造器1
+(instancetype)getVcWithDayNumber:(int)day_num FromDateforString:(NSString *)fromdate Selectdate:(NSString *)selectdate;
//便利构造器2
+(instancetype)getVcWithDayNumber:(int)day_num FromDateforString:(NSString *)fromdate Selectdate:(NSString *)selectdate selectBlock:(CalendarBlock)sb;


@end
