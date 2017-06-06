//
//  HZCalendarCell.h
//  HZCalendarKit
//
//  Created by 侯震 on 2017/5/19.
//  Copyright © 2017年 multway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZCalenderDayModel.h"

@interface HZCalendarCell : UICollectionViewCell{

UILabel *day_lab;//今天的日期或者是节日
UILabel *day_title;//显示标签
UIView *imgview;//选中时的图片
UIImageView *imghuoche;//选中时的图片

}

/**展示多少天的预售图标*/
@property (nonatomic , assign)long showImageIndex;
/**模型*/
@property (nonatomic , strong)HZCalenderDayModel *calenderDayModel;
@end
