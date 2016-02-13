//
//  GoSeatCollectionViewCell.h
//  GoIbibo
//
//  Created by Vijay on 24/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoSeatCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *seatNo;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterXConstrait;
@end
