//
//  CalendarView.m
//  Ump4Usr
//
//  Created by iiyumewo on 16/7/27.
//  Copyright © 2016年 iiyumewo. All rights reserved.
//

#import "CalendarView.h"
#import "Masonry.h"


#define kColorWithRGB(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:a]
#define kWidth [UIScreen mainScreen].bounds.size.width

typedef enum : NSUInteger {
    CalendarViewDateLineStyleCurrent,
    CalendarViewDateLineStyleFuture,
    CalendarViewDateLineStylePast,
} CalendarViewDateLineStyle;



@interface CalendarView()



@property (nonatomic, assign) CalendarViewStyle calendarViewStyle;

@property (nonatomic, strong) UIView *yearMonthInfoView;
@property (nonatomic, strong) UIView *weekInfoView;

@property (nonatomic, strong) NSMutableArray *dateNumberArray;

@property (nonatomic, strong) NSMutableArray *dateLabelArray;

@property (nonatomic, strong) UIView *dateNumberView;

@end

@implementation CalendarView

- (NSMutableArray *)dateLabelArray {
    if (_dateLabelArray == nil) {
        _dateLabelArray = [NSMutableArray array];
    }
    return _dateLabelArray;
}

- (NSMutableArray *)dateNumberArray {
    if (_dateNumberArray == nil) {
        _dateNumberArray = [NSMutableArray array];
    }
    return _dateNumberArray;
}

- (instancetype)initAtDate:(NSDate *)currentDate calendarStyle:(CalendarViewStyle)style futureLineNumber:(NSInteger)lineNumber {
    CGRect calendarFrame = [self calculateForCalendarViewFrameWithNumberOfDateLineNumber:1+lineNumber calendarStyle:style];
    self = [super initWithFrame:calendarFrame];
    if (self) {
        _numberOfPastDateLines = 0;
        _numberOfFutureDateLines = lineNumber;
        self.calendarViewStyle = style;
        [self generateAndConfigureYearMonthInfoView];
        [self generateAndConfigureWeekInfoView];
        self.dateNumberArray = [self generatingDateNumberArray];
        [self generatingAndConfiguratingDateNumberViews];
    }
    return self;
}

//- (void)setNumberOfFutureDateLines:(NSInteger)numberOfFutureDateLines {
//    _numberOfFutureDateLines = numberOfFutureDateLines;
//    CGRect frame = [self calculateForCalendarViewFrameWithNumberOfDateLineNumber:1+numberOfFutureDateLines];
//    self.frame = frame;
////    NSLog(@"%f %f", frame.size.width, frame.size.height);
//    self.dateNumberArray = [self generatingDateNumberArray];
//    [self generatingAndConfiguratingDateNumberViews];
//}

- (CGRect)calculateForCalendarViewFrameWithNumberOfDateLineNumber:(NSInteger)lineNumber calendarStyle:(CalendarViewStyle)style {
    if (style == CalendarViewStyleNormal) {
        CGRect frame = CGRectMake(0, 0, kWidth, 30+20+30+21.5*lineNumber+(lineNumber-1)*15);
//        NSLog(@"%f %f", frame.size.width, frame.size.height);
        return frame;
    }else if (style == CalendarViewStyleWithInfo) {
        CGRect frame = CGRectMake(0, 0, kWidth, 30+20+61*lineNumber+(lineNumber-1)*1);
        return frame;
    }
    return CGRectZero;
}

- (void)generateAndConfigureYearMonthInfoView {
    _yearMonthInfoView = [[UIView alloc]initWithFrame:CGRectZero];
    _yearMonthInfoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_yearMonthInfoView];
    [_yearMonthInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [_yearMonthInfoView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_yearMonthInfoView);
    }];
    infoLabel.text = @"2016年7月";
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = kColorWithRGB(74, 74, 74, 1);
}

- (void)generateAndConfigureWeekInfoView {
    _weekInfoView = [[UIView alloc]initWithFrame:CGRectZero];
    _weekInfoView.backgroundColor = kColorWithRGB(247, 247, 247, 1);
    [self addSubview:_weekInfoView];
    [_weekInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yearMonthInfoView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    NSArray *weekInfoArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (NSInteger i = 0; i < 7; i++) {
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        infoLabel.text = weekInfoArray[i];
        infoLabel.font = [UIFont systemFontOfSize:10];
        if (i == 0 || i == 6) {
            infoLabel.textColor = kColorWithRGB(162, 162, 162, 1);
        }else {
            infoLabel.textColor = kColorWithRGB(0, 0, 0, 0.8);
        }
        [_weekInfoView addSubview:infoLabel];
        CGFloat pointx = 30+(kWidth-60-10)/6*i;
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_weekInfoView);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(10);
            make.left.equalTo(_weekInfoView).with.mas_offset(pointx);
        }];
    }
}

- (NSMutableArray *)generatingDateNumberArray {
    NSMutableArray *dateNumberArray = [NSMutableArray array];
    NSUInteger currentMonthMaxDayNumber = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
    /**
     *  get current week day range
     */
    NSRange currentWeekRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
    for (NSInteger i = currentWeekRange.location; i < currentWeekRange.location+currentWeekRange.length; i++) {
        [dateNumberArray addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    if (currentWeekRange.length != 7) {
        for (NSInteger i = 1; i <= 7-currentWeekRange.length; i++) {
            [dateNumberArray addObject:[NSString stringWithFormat:@"%ld", i]];
        }
    }
    /**
     *  get future week day range
     */
    /**
     *  future several week
     */
    for (NSInteger i = 1; i <= self.numberOfFutureDateLines; i++) {
        NSInteger secondsInSevenDays = 3600*24*7;
        NSRange currentWeekRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSWeekCalendarUnit forDate:[NSDate dateWithTimeIntervalSinceNow:secondsInSevenDays*i]];
        /**
         *
         */
        if (currentWeekRange.length != 7) {
            for (NSInteger i = currentMonthMaxDayNumber-(7-currentWeekRange.length)+1; i <= currentMonthMaxDayNumber; i++) {
                [dateNumberArray addObject:[NSString stringWithFormat:@"%ld", i]];
            }
        }
        for (NSInteger i = currentWeekRange.location; i < currentWeekRange.location+currentWeekRange.length; i++) {
            [dateNumberArray addObject:[NSString stringWithFormat:@"%ld", i]];
        }
    }
    return dateNumberArray;
}

- (void)generatingAndConfiguratingDateNumberViews {
    [self resetDateNumberView];
    
    if (self.calendarViewStyle == CalendarViewStyleNormal) {
        for (UILabel *label in self.dateLabelArray) {
            [label removeFromSuperview];
        }
        self.dateLabelArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < self.dateNumberArray.count; i++) {
            NSInteger lineNumber = i/7;
            NSInteger relativeX = i%7;
            
            CGFloat pointx = 30+(kWidth-60-10)/6*relativeX;
            UILabel *dateNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            dateNumberLabel.font = [UIFont systemFontOfSize:18];
            dateNumberLabel.text = self.dateNumberArray[i];
            dateNumberLabel.textAlignment = NSTextAlignmentCenter;
            dateNumberLabel.textColor = kColorWithRGB(0, 0, 0, 0.8);
            if (i%7 == 0 || i%7 == 6) {
                dateNumberLabel.textColor = kColorWithRGB(51, 51, 51, 0.8);
            }
            [self addSubview:dateNumberLabel];
            [dateNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(21.5);
                make.width.mas_equalTo(30);
                make.centerY.equalTo(self.weekInfoView.mas_bottom).with.mas_offset(15*(lineNumber+1)+lineNumber*21.5+10.5);
                make.centerX.equalTo(self.mas_left).with.mas_offset(pointx+5);
            }];
            [self.dateLabelArray addObject:dateNumberLabel];
        }
    }else if (self.calendarViewStyle == CalendarViewStyleWithInfo) {
        self.dateNumberView.backgroundColor = kColorWithRGB(229, 229, 229, 229);
        for (NSInteger lineNumber = 0; lineNumber < self.numberOfFutureDateLines+1; lineNumber++) {
            UIView *containerView = [[UIView alloc]initWithFrame:CGRectZero];
            containerView.backgroundColor = [UIColor whiteColor];
            [self.dateNumberView addSubview:containerView];
            NSMutableArray<UIView *> *containerViewArray = [NSMutableArray array];
            [containerViewArray addObject:containerView];
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.dateNumberView);
                make.height.mas_equalTo(61);
                if (lineNumber==0) {
                    make.top.equalTo(self.dateNumberView);
                }else {
                    make.top.equalTo(self.dateNumberView).with.mas_offset(61.5*lineNumber);
                }
            }];
        }
        for (NSInteger i = 0; i < self.dateNumberArray.count; i++) {
            NSInteger lineNumber = i/7;
            NSInteger relativeX = i%7;
            
            CGFloat pointx = 30+(kWidth-60-10)/6*relativeX;
            UILabel *dateNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            dateNumberLabel.font = [UIFont systemFontOfSize:18];
            dateNumberLabel.text = self.dateNumberArray[i];
            dateNumberLabel.textAlignment = NSTextAlignmentCenter;
            dateNumberLabel.textColor = kColorWithRGB(74, 74, 74, 0.8);
            [self addSubview:dateNumberLabel];
            [dateNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(21.5);
                make.width.mas_equalTo(30);
                make.top.equalTo(self.dateNumberView).with.mas_offset(61.5*lineNumber+23/2.f);
                make.centerX.equalTo(self.mas_left).with.mas_offset(pointx+5);
            }];
            [self.dateLabelArray addObject:dateNumberLabel];
        }
    }
}

- (void)resetDateNumberView {
    self.dateNumberView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.dateNumberView];
    [self.dateNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.weekInfoView.mas_bottom);
    }];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
