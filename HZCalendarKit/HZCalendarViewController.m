//
//  HZCalendarViewController.m
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import "HZCalendarViewController.h"
#import "HZCalendarCell.h"
#import "NSDate+WQCalendarLogic.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarMonthCollectionViewLayout.h"
#import "HZCalenderGobackView.h"

static NSString *MonthHeader = @"MonthHeaderView";

@interface HZCalendarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSTimer* timer;//定时器

}

@property (nonatomic , strong)UICollectionView *collectionView;
/**月份数组 */
@property (nonatomic , strong)NSMutableArray *calendarMonth;
/**操作日期逻辑*/
@property (nonatomic , strong)HZCalendarLogic *calendarLogic;
/**往返的头部视图*/
@property (nonatomic , strong)HZCalenderGobackView *calenderGobackView;

@end

@implementation HZCalendarViewController

+(instancetype)getVcWithDayNumber:(int)day_num FromDateforString:(NSString *)fromdate Selectdate:(NSString *)selectdate{
    HZCalendarViewController *vc = [[HZCalendarViewController alloc]init];
    vc.title = @"选择日期";
    vc.calendarMonth = [vc getMonthArrayOfDayNumber:day_num FromDateforString:fromdate Selectdate:selectdate];
    [vc.collectionView reloadData];//刷新
    return vc;
}

+(instancetype)getVcWithDayNumber:(int)day_num FromDateforString:(NSString *)fromdate Selectdate:(NSString *)selectdate selectBlock:(CalendarBlock)sb{
    
    HZCalendarViewController *vc = [[HZCalendarViewController alloc]init];
    vc.title = @"选择日期";
    vc.calendarMonth = [vc getMonthArrayOfDayNumber:day_num FromDateforString:fromdate Selectdate:selectdate];
    [vc.collectionView reloadData];//刷新
    vc.calendarblock = ^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay){
        sb(goDay,backDay);
    };
    return vc;
}

-(void)setShowImageIndex:(long)showImageIndex{
    _showImageIndex = showImageIndex;
    [self.collectionView reloadData];//刷新
}

-(void)setIsGoBack:(BOOL)isGoBack{
    _isGoBack = isGoBack;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.titleEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, -30);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectLeftAction)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = backButton;
    _calenderGobackView = [[HZCalenderGobackView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 50)];
    _collectionView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height);
    [_calenderGobackView.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_calenderGobackView.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_calenderGobackView];
}

-(void)selectLeftAction{
    
    if(!self.CalendarGo){
        [self testAlert:@"请选择出发日期！"];
        return;
    }else if (!self.CalendarBack){
        [self testAlert:@"请选择返程日期！"];
        return;
    }
    if (self.calendarblock) {
        self.calendarblock(_CalendarGo,_CalendarBack);//传递数组给上级
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}
-(void)testAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    [self.navigationController presentViewController:alert animated:YES completion:^{
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

-(void)rightBtnAction:(UIButton *)button{
    button.hidden = YES;
    [self.calendarLogic canelLogic:self.CalendarBack];
    [self.calendarLogic canelLogic:_calendarLogic.selectcalendarDay2];
    _calendarLogic.selectcalendarDay2 = nil;
    self.CalendarBack= nil;
    _calenderGobackView.rightLabel.text = @"   请选择返回日期";
    
    [self.collectionView reloadData];
}
-(void)leftBtnAction:(UIButton *)button{
    button.hidden = YES;
    _calenderGobackView.rightBtn.hidden = YES;
    [self.calendarLogic canelLogic:self.CalendarGo];
    [self.calendarLogic canelLogic:self.CalendarBack];
    if (_calendarLogic.selectcalendarDay2.week == 1 || _calendarLogic.selectcalendarDay2.week == 7){
        _calendarLogic.selectcalendarDay2.style = CellDayTypeWeek;
    }else{
        _calendarLogic.selectcalendarDay2.style = CellDayTypeFutur;
    }
    if (_calendarLogic.selectcalendarDay.week == 1 || _calendarLogic.selectcalendarDay.week == 7){
        _calendarLogic.selectcalendarDay.style = CellDayTypeWeek;
    }else{
        _calendarLogic.selectcalendarDay.style = CellDayTypeFutur;
    }
    self.CalendarGo = nil;
    self.CalendarBack= nil;
    _calenderGobackView.leftLabel.text = @"   请选择出发日期";
    _calenderGobackView.rightLabel.text = @"   请选择返回日期";
    [self.collectionView reloadData];
}


-(NSMutableArray *)calendarMonth{
    if (!_calendarMonth) {
        _calendarMonth = [[NSMutableArray alloc]init];
    }
    return _calendarMonth;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor purpleColor];
    [self.collectionView registerClass:[HZCalendarCell class] forCellWithReuseIdentifier:@"HZCalendarCell"];
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
    self.collectionView.bounces = YES;//将网格视图的下拉效果关闭
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.collectionView];
    
}

#pragma mark - CollectionView代理方法
//月份的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.calendarMonth.count;
}
//每月的天数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    NSMutableArray *monthArray =  _calendarMonth[section];
    return   monthArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    HZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HZCalendarCell"forIndexPath:indexPath];
    cell.showImageIndex = self.showImageIndex;
    NSMutableArray *monthArray =  self.calendarMonth[indexPath.section];
    HZCalenderDayModel *model = monthArray[indexPath.row];
    cell.calenderDayModel = model;
    return cell;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    HZCalenderDayModel *model = [month_Array objectAtIndex:indexPath.row];
    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek || model.style == CellDayTypeClick) {
        
        if (self.isGoBack) {
            
            [self didSelectItemGoback:model];
            
        }else{
            
            [self.calendarLogic selectLogic:model];
            if (self.calendarblock) {
                self.calendarblock(model,nil);//传递数组给上级
                timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            }
        }
    }

    [self.collectionView reloadData];
    
}
-(void)didSelectItemGoback:(HZCalenderDayModel *)model{
    if (self.CalendarGo&&self.CalendarBack) {
        if ([[self.CalendarGo toString] isEqualToString:[self.CalendarBack toString]]&&[[model toString] isEqualToString:[self.CalendarGo toString]]) {
            return ;
        }
        self.calenderGobackView.rightBtn.hidden = YES;
        [self.calendarLogic canelLogic:self.CalendarBack];
        [_calendarLogic canelLogic:_calendarLogic.selectcalendarDay2];
        self.CalendarBack = nil;
        self.calendarLogic.selectcalendarDay2 = nil;
        self.calenderGobackView.rightLabel.text = @"   请选择返回日期";
        self.CalendarGo = model;
        [self.calendarLogic selectLogic:model];
        self.calenderGobackView.leftBtn.hidden = NO;
        self.calenderGobackView.leftLabel.text = [NSString stringWithFormat:@"   出发%@",[self.CalendarGo toString]];
        
    }else if(self.CalendarGo){
        self.CalendarBack = model;
        [self.calendarLogic selectLogic2:model];
        self.calenderGobackView.rightBtn.hidden = NO;
        
        NSComparisonResult result = [[self.CalendarGo date] compare:[self.CalendarBack date]];
        if (result == NSOrderedDescending) {
            HZCalenderDayModel *temp = [[HZCalenderDayModel alloc]init];
            temp =  self.CalendarGo;
            self.CalendarGo  = self.CalendarBack;
            self.CalendarBack = temp;
            _calendarLogic.selectcalendarDay = self.CalendarGo;
            _calendarLogic.selectcalendarDay2 = self.CalendarBack;
            
        }
        _calenderGobackView.leftLabel.text = [NSString stringWithFormat:@"   出发%@",[self.CalendarGo toString]];
        _calenderGobackView.rightLabel.text = [NSString stringWithFormat:@"   返回%@",[self.CalendarBack toString]];
        
    }else{
        
        self.CalendarGo = model;
        [self.calendarLogic selectLogic:model];
        self.calenderGobackView.leftBtn.hidden = NO;
        _calenderGobackView.leftLabel.text = [NSString stringWithFormat:@"   出发%@",[self.CalendarGo toString]];
        
    }
}
//定时器方法
- (void)onTimer{
    
    [timer invalidate];//定时器无效
    timer = nil;
    [self.navigationController  popViewControllerAnimated:YES];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        HZCalenderDayModel *model = [month_Array objectAtIndex:15];
        
        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
        
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
#pragma mark - 逻辑代码初始化
//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day FromDateforString:(NSString *)fromdate Selectdate:(NSString *)selectdate
{
    NSDate *fdate = [NSDate date];
    NSDate *sdate  = [NSDate date];
    if (fromdate) {
        fdate = [fdate dateFromString:fromdate];
    }
    if (selectdate) {
        sdate = [sdate dateFromString:selectdate];

    }
    self.calendarLogic = [[HZCalendarLogic alloc]init];
    return [self.calendarLogic reloadCalendarView:fdate selectDate:sdate  needDays:day];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
