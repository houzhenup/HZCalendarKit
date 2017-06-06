//
//  HZCalendarLogic.m
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import "HZCalendarLogic.h"
#import "HZCalenderDayModel.h"

@interface HZCalendarLogic ()
{
    NSDateComponents *calendarToday;//今天
    NSDateComponents *calendarFirstDay;//起始天
    NSDateComponents *calendarLastDay;//最后一天
    NSDateComponents *calendarSelectDay;//默认选择的那一天
}

@end

@implementation HZCalendarLogic

//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)fristdate  selectDate:(NSDate *)selectdate needDays:(int)days_number
{
    //如果为空就从当天的日期开始
    if(fristdate == nil){
        fristdate = [NSDate date];
    }
    //默认选择中的时间
    if (selectdate == nil) {
        selectdate = fristdate;
    }
    calendarFirstDay  = [fristdate YMDComponents];//起始天
    calendarLastDay = [[fristdate dayInTheFollowingDay:days_number] YMDComponents];//最后一天
    calendarSelectDay = [selectdate YMDComponents];//默认选择的那一天
    calendarToday =  [[NSDate date] YMDComponents];//今天

    
    NSInteger todayYear = calendarFirstDay.year;
    NSInteger todayMonth = calendarFirstDay.month;
    NSInteger beforeYear = calendarLastDay.year;
    NSInteger beforeMonth = calendarLastDay.month;

    
    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    for (int i = 0; i <= months; i++) {
        
        NSDate *month = [fristdate dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
    
}



#pragma mark - 日历上+当前+下月份的天数

//计算上月份的天数

- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    //计算这个的第一天是礼拜几,并转为int型
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];
    //上一个月的NSDate对象
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];
    //计算上个月有多少天
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];
    //获取上月在这个月的日历上显示的天数
    NSUInteger partialDaysCount = weeklyOrdinality - 1;
    //获取年月日对象
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];
    
    for (long i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        HZCalenderDayModel *calendarDay = [HZCalenderDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [array addObject:calendarDay];
    }
    
    return NULL;
}



//计算下月份的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        HZCalenderDayModel *calendarDay = [HZCalenderDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;
        [array addObject:calendarDay];
    }
}


//计算当月的天数

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        HZCalenderDayModel *calendarDay = [HZCalenderDayModel calendarDayWithYear:components.year month:components.month day:i];
        
        // calendarDay.Chinese_calendar = [self LunarForSolarYear:components.year Month:components.month Day:i];
        
        calendarDay.week = [[calendarDay date]getWeekIntValueWithDate];
        [self LunarForSolarYear:calendarDay];
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}


- (void)changStyle:(HZCalenderDayModel *)calendarDay{

    //被点击选中
    if(calendarSelectDay.year == calendarDay.year &
       calendarSelectDay.month == calendarDay.month &
       calendarSelectDay.day == calendarDay.day){
       calendarDay.style = CellDayTypeClick;
       _selectcalendarDay = calendarDay;
    
    }else{
        //昨天乃至过去的时间设置一个灰度
        if (calendarFirstDay.year >= calendarDay.year &
            calendarFirstDay.month >= calendarDay.month &
            calendarFirstDay.day > calendarDay.day) {
            calendarDay.style = CellDayTypePast;
            
        //之后的时间时间段
        }else if (calendarLastDay.year <= calendarDay.year &
                  calendarLastDay.month <= calendarDay.month &
                  calendarLastDay.day <= calendarDay.day) {
            calendarDay.style = CellDayTypePast;
            
        //需要正常显示的时间段
        }else{
            //周末
            if (calendarDay.week == 1 || calendarDay.week == 7){
                calendarDay.style = CellDayTypeWeek;
                //工作日
            }else{
                calendarDay.style = CellDayTypeFutur;
            }
        }
    }
    
    if (calendarFirstDay.year == calendarToday.year &&
        calendarFirstDay.month== calendarToday.month&&
        calendarFirstDay.year == calendarDay.year &&
        calendarFirstDay.month == calendarDay.month &&
        calendarFirstDay.day == calendarDay.day) {
        calendarDay.holiday = @"今天";
        
        //1.1元旦
    }else if (calendarDay.month == 1 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"元旦";
        
        //2.14情人节
    }else if (calendarDay.month == 2 &&
              calendarDay.day == 14){
        calendarDay.holiday = @"情人节";
        
        //3.8妇女节
    }else if (calendarDay.month == 3 &&
              calendarDay.day == 8){
        calendarDay.holiday = @"妇女节";
        
        //5.1劳动节
    }else if (calendarDay.month == 5 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"劳动节";
        
        //6.1儿童节
    }else if (calendarDay.month == 6 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"儿童节";
        
        //8.1建军节
    }else if (calendarDay.month == 8 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"建军节";
        
        //9.10教师节
    }else if (calendarDay.month == 9 &&
              calendarDay.day == 10){
        calendarDay.holiday = @"教师节";
        
        //10.1国庆节
    }else if (calendarDay.month == 10 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"国庆节";
        
        
    }else if (calendarDay.month == 11 &&
              calendarDay.day == 11){
        calendarDay.holiday = @"光棍节";
        
    }else{
        
        
        //这里写其它的节日
        
    }
    
}

#pragma mark - 农历转换函数

-(void)LunarForSolarYear:(HZCalenderDayModel *)calendarDay{
    
    NSString *solarYear = [self LunarForSolarYear:calendarDay.year Month:calendarDay.month Day:calendarDay.day];
    
    NSArray *solarYear_arr= [solarYear componentsSeparatedByString:@"-"];
    
    if([solarYear_arr[0]isEqualToString:@"正"] &&
       [solarYear_arr[1]isEqualToString:@"初一"]){
        
        //正月初一：春节
        calendarDay.holiday = @"春节";
        
    }else if([solarYear_arr[0]isEqualToString:@"正"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){        
        //正月十五：元宵节
        calendarDay.holiday = @"元宵";
        
    }else if([solarYear_arr[0]isEqualToString:@"二"] &&
             [solarYear_arr[1]isEqualToString:@"初二"]){
        
        //二月初二：春龙节(龙抬头)
        calendarDay.holiday = @"龙抬头";
        
    }else if([solarYear_arr[0]isEqualToString:@"五"] &&
             [solarYear_arr[1]isEqualToString:@"初五"]){
        
        //五月初五：端午节
        calendarDay.holiday = @"端午";
        
    }else if([solarYear_arr[0]isEqualToString:@"七"] &&
             [solarYear_arr[1]isEqualToString:@"初七"]){
        
        //七月初七：七夕情人节
        calendarDay.holiday = @"七夕";
        
    }else if([solarYear_arr[0]isEqualToString:@"八"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        
        //八月十五：中秋节
        calendarDay.holiday = @"中秋";
        
    }else if([solarYear_arr[0]isEqualToString:@"九"] &&
             [solarYear_arr[1]isEqualToString:@"初九"]){
        
        //九月初九：重阳节、中国老年节（义务助老活动日）
        calendarDay.holiday = @"重阳";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"初八"]){
        
        //腊月初八：腊八节
        calendarDay.holiday = @"腊八";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"二十四"]){
        
        
        //腊月二十四 小年
        calendarDay.holiday = @"小年";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"三十"]){
        
        //腊月三十（小月二十九）：除夕
        calendarDay.holiday = @"除夕";
        
    }
    
    
    calendarDay.Chinese_calendar = solarYear_arr[1];
    
    
    
}

-(NSString *)LunarForSolarYear:(long)wCurYear Month:(long)wCurMonth Day:(long)wCurDay{
    
    
    
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十", @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static long nTheDate,nIsEnd,m,k,n,i,nBit;
    
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    
    //生成农历月
    NSString *szNongliMonth;
    if (wCurMonth < 1){
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    
    return lunarDate;
}




- (void)selectLogic:(HZCalenderDayModel *)day
{
    if (day.style == CellDayTypeClick) {
        return;
    }
    day.style = CellDayTypeClick;
    //周末
    if (_selectcalendarDay.week == 1 || _selectcalendarDay.week == 7){
        _selectcalendarDay.style = CellDayTypeWeek;

    }else{
        _selectcalendarDay.style = CellDayTypeFutur;
    }
    _selectcalendarDay = day;
}

- (void)selectLogic2:(HZCalenderDayModel *)day
{
    if (day.style == CellDayTypeClick) {
        return;
    }
    day.style = CellDayTypeClick;
    //周末
    if (_selectcalendarDay2.week == 1 || _selectcalendarDay2.week == 7){
        _selectcalendarDay2.style = CellDayTypeWeek;
        //工作日
    }else{
        _selectcalendarDay2.style = CellDayTypeFutur;
    }
    
    _selectcalendarDay2 = day;
}
- (void)canelLogic:(HZCalenderDayModel *)day
{
    //周末
    if (day.week == 1 || day.week == 7){
        day.style = CellDayTypeWeek;
        //工作日
    }else{
        day.style = CellDayTypeFutur;
    }
    
}
@end
