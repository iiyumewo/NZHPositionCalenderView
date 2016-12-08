//
//  CalendarView.h
//  Ump4Usr
//
//  Created by iiyumewo on 16/7/27.
//  Copyright © 2016年 iiyumewo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    CalendarViewStyleNormal,
    CalendarViewStyleWithInfo,
} CalendarViewStyle;

@interface CalendarView : UIView

@property (nonatomic, assign) NSInteger numberOfFutureDateLines;
@property (nonatomic, assign) NSInteger numberOfPastDateLines;

- (instancetype)initAtDate:(NSDate *)currentDate calendarStyle:(CalendarViewStyle)style futureLineNumber:(NSInteger)lineNumber;

@end
