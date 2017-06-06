# HZCalendarKit
两行代码即可简单集成日历控件，提供单日期，往返日期选择，可根据需求随意变换主题颜色

<li>便利构造方法1 传入 <b>参数1:</b>显示日期的天数 <b>参数2:</b>显示的起始日期 格式为@"yyyy-MM-dd"(可传nil默认当天)<b>参数3:</b>默认选择的日期@"yyyy-MM-dd"(可传nil默认当天)

    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil];
    vc.calendarblock = ^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
     
      self.label.text = [goDay toString];
   
    };

<li>便利构造方法2直接携带block 传入 参数1：显示日期的天数 参数2：显示的起始日期 格式为@"yyyy-MM-dd" 可传nil默认当天 参数2：默认选择的日期@"yyyy-MM-dd" 可传nil默认当天

   
    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {

     self.label.text = [NSString stringWithFormat:@"%@/%@",[goDay toString],[backDay toString]];
 
    }];



<li>可以显示单个日期的附加图片（Demo中为12306可预订日期30天）只需提供显示的天数

    vc.showImageIndex = 30;

<li>往返日期选择只需isGoBack属性设置为YES

<b color = "red" >注意!!! vc.isGoBack = YES block中的backDay才有值，否则backDay为nil</b>
 
    vc.isGoBack = YES;
