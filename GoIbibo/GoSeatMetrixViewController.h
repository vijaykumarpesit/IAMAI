//
//  GoSeatMetrixViewController.h
//  GoIbibo
//
//  Created by Vijay on 24/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoBusDetails.h"

@interface GoSeatMetrixViewController : UIViewController

- (instancetype)initWithBusDetails:(GoBusDetails *)busDetails seatNoReservedByFriend:(NSString *)seatNo;
@end
