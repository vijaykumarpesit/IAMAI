//
//  GoBusInfoCell.h
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoBusInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *travellerName;
@property (weak, nonatomic) IBOutlet UILabel *busTypeName;
@property (weak, nonatomic) IBOutlet UILabel *minimumFare;
@property (weak, nonatomic) IBOutlet UILabel *availableSeats;
@property (weak, nonatomic) IBOutlet UILabel *departureToArrivalTime;

@end
