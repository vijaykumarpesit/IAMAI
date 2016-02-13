//
//  GoSearchPlaceViewController.h
//  GoIbibo
//
//  Created by Sachin Vas on 9/24/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateSelectedPlace)(NSString *);
@interface GoSearchPlaceViewController : UITableViewController

@property (nonatomic) BOOL isSourcePlace;
@property (nonatomic, copy) UpdateSelectedPlace updateSelectedPlace;

@end
