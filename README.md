# NZHPositionCalenderView

## Install
1. Download all the files in the NZHPositionCalenderView.
2. Add the source files folder to your Xcode project.
3. Include wherever you need it with #import "CalendarView.h".

## Usage
NZHPositionCalenderView is specially designed for a rare case. Let's see an example:
```Objective-C
    CalendarView *calenderView = [[CalendarView alloc]initAtDate:[NSDate date]
                                                   calendarStyle:CalendarViewStyleNormal
                                                futureLineNumber:1];
```
And it'll get the view like this:

![CalenderNormal]
(https://github.com/iiyumewo/NZHPositionCalenderView/blob/master/ReadME/CalenderNormal.png?raw=true)

The function need a NSDate instance which will be the starting line in the calender view.
The parameter 'futureLineNumber' will affect the line numbers behind in the calender view. Some examples:
```Objective-C
    CalendarView *calenderView = [[CalendarView alloc]initAtDate:[NSDate date]
                                                   calendarStyle:CalendarViewStyleNormal
                                                futureLineNumber:0];
```
```Objective-C
    CalendarView *calenderView = [[CalendarView alloc]initAtDate:[NSDate date]
                                                   calendarStyle:CalendarViewStyleNormal
                                                futureLineNumber:4];
```
![CalenderZero]
(https://github.com/iiyumewo/NZHPositionCalenderView/blob/master/ReadME/CalenderZero.png?raw=true)
![CalenderFour]
(https://github.com/iiyumewo/NZHPositionCalenderView/blob/master/ReadME/CalenderFour.png?raw=true)

It also provides a special mode. You can use `CalendarViewStyleWithInfo` to reserve some space for your custom text description.
```Objective-C
    CalendarView *calenderView = [[CalendarView alloc]initAtDate:[NSDate date]
                                                   calendarStyle:CalendarViewStyleWithInfo
                                                futureLineNumber:3];
```
![CalenderInfo]
(https://github.com/iiyumewo/NZHPositionCalenderView/blob/master/ReadME/CalenderInfo.png?raw=true)
