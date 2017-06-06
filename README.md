# HZCalendarKit
两行代码即可简单集成日历控件，提供单日期，往返日期选择，可根据需求随意变换主题颜色

<li>便利构造方法

    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil];
    vc.calendarblock = ^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
    self.label.text = [goDay toString];
    };
<li>可以显示单个日期的附加图片并只需提供个数

    vc.showImageIndex = 30;

<li>往返日期选择只需isGoBack属性设置为YES
 
    vc.isGoBack = YES
