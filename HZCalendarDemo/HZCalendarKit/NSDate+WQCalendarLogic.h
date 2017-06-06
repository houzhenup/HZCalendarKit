

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick    //被点击的日期

};

@interface NSDate (WQCalendarLogic)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

+ (long)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

-(long)getWeekIntValueWithDate;



//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;

//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;

@end
