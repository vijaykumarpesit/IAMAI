//
//  GoBusListViewController.h
//  
//
//  Created by Vijay on 23/09/15.
//
//

#import <UIKit/UIKit.h>

@interface GoBusListViewController : UIViewController

- (instancetype)initWithSource:(NSString *)source
                   destination:(NSString *)destination
                 departureDate:(NSDate *)departureDate
                   arrivalDate:(NSDate *)arrivalDate;


@end
