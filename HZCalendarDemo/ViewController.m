//
//  ViewController.m
//  HZCalendarDemo
//
//  Created by 侯震 on 2017/6/5.
//  Copyright © 2017年 multway. All rights reserved.
//

#import "ViewController.h"
#import "HZCalendarViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"迈维旅行";
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

    //往返日期
    [self popCalendarVC];
    //单程日期
   // [self popCalendarVC2];
    
}
-(void)popCalendarVC2{
    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil];
    vc.calendarblock = ^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
        self.label.text = [goDay toString];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)popCalendarVC{
   
    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
       
        self.label.text = [NSString stringWithFormat:@"%@/%@",[goDay toString],[backDay toString]];
       
    }];
    vc.showImageIndex = 30;
    vc.isGoBack = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}

@end
