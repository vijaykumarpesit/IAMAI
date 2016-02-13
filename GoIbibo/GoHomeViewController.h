//
//  ViewController.h
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DigitsKit/DigitsKit.h>
#import <JTCalendar/JTCalendar.h>


@interface GoHomeViewController : UIViewController<DGTCompletionViewController, JTCalendarDelegate>


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@end


