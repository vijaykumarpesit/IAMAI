//
//  GoMapCell.m
//  GoIbibo
//
//  Created by Vijay on 13/02/16.
//  Copyright © 2016 Vijay. All rights reserved.
//

#import "GoMapCell.h"

@implementation GoMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mapView setDelegate:self];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
    }
    else {
    }
    return pinView;
}

@end
