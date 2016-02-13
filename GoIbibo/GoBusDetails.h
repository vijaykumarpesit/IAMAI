//
//  GoBusDetails.h
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoBusDetails : NSObject


//Only taking these parameters from the info.whenever its needed add some more paramets to this.
@property (nonatomic, strong) NSString *travelsName;
@property (nonatomic, strong) NSString *busType;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *minimumFare;
@property (nonatomic, strong) NSString *jorneyDuration;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) NSString *noOfSeatsAvailable;
@property (nonatomic, strong) NSString *ratings;
@property (nonatomic, strong) NSString *rowID;
@property (nonatomic, strong) NSString *skey;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSDate *departureDate;
@end
