# HZCalendarKit
######两行代码即可简单集成日历控件，提供单日期，往返日期选择，可根据需求随意变换主题颜色
![单程.gif
](http://upload-images.jianshu.io/upload_images/1909734-21726738a4629d4a.gif?imageMogr2/auto-orient/strip)


<li>便利构造方法1 传入 <b>参数1:</b> 显示日期的天数 <b>参数2:</b> 显示的起始日期 格式为@"yyyy-MM-dd"(可传nil默认当天)<b>参数3:</b> 默认选择的日期@"yyyy-MM-dd"(可传nil默认当天)


    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil];
    vc.calendarblock = ^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
    self.label.text = [goDay toString];
    };

<li>便利构造方法2直接携带block 传入参数与上边一致


    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
     self.label.text = [NSString stringWithFormat:@"%@/%@",[goDay toString],[backDay toString]];
    }];



<li>可以显示单个日期的附加图片（Demo中为12306可预订日期30天）只需提供显示的天数

vc.showImageIndex = 30;

<li>往返日期选择只需isGoBack属性设置为YES


<b>注意!!!此属性为YES 控制器block中的backDay才有值，否则为nil</b>

    
    vc.isGoBack = YES;


![往返.gif
](http://upload-images.jianshu.io/upload_images/1909734-e6987fa055324477.gif?imageMogr2/auto-orient/strip)





<li>pch文件中提供COLOR_THEME可以更改主题颜色


![往返.gif](http://upload-images.jianshu.io/upload_images/1909734-52331d72a8b2ca73.gif?imageMogr2/auto-orient/strip)


有需要Demo的请到 https://github.com/houzhenup/HZCalendarKit 下载 喜欢的话请点个star
