//
//  GoMapCell.h
//  GoIbibo
//
//  Created by Vijay on 13/02/16.
//  Copyright © 2016 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GoMapCell : UITableViewCell <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@property (weak, nonatomic) IBOutlet UILabel *optionValueLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocation *location;
@end
