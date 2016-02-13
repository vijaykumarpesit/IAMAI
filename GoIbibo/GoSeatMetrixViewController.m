//
//  GoSeatMetrixViewController.m
//  GoIbibo
//
//  Created by Vijay on 24/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSeatMetrixViewController.h"
#import "GoSeatCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "GoBusSeatLayout.h"
#import "GoPaymentConfirmation.h"
#import "GoSeatSeletionHeaderView.h"

@interface GoSeatMetrixViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *seats;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *searchingView;
@property (nonatomic, strong) GoBusDetails *busDetails;
@property (nonatomic, strong) NSString *seatNoReservedByFriend;

@end

@implementation GoSeatMetrixViewController

- (instancetype)initWithBusDetails:(GoBusDetails *)busDetails seatNoReservedByFriend:(NSString *)seatNo {

    self = [super initWithNibName:@"GoSeatMetrixViewController" bundle:nil];
    if (self) {
        self.busDetails = busDetails;
        self.seatNoReservedByFriend = seatNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seats = [[NSMutableArray alloc] init];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoSeatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"busSeatCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoSeatSeletionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self loadBusLayoutMetrix];
    [self.collectionView setHidden:YES];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.seats.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoSeatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"busSeatCell" forIndexPath:indexPath];
    GoBusSeatLayout *layout = [self.seats objectAtIndex:indexPath.row];
    cell.seatNo.text = layout.seatNo;
    cell.userInteractionEnabled = YES;
    cell.backgroundImageView.alpha = 1.0f;
    cell.seatNo.alpha = 1.0f;
    
    if(layout.seatNo && [layout.seatNo isEqualToString:self.seatNoReservedByFriend]){
        cell.seatNo.text = layout.seatNo;
        cell.backgroundImageView.image = [UIImage imageNamed:@"buddySeat.png"];
        cell.labelCenterXConstrait.constant += 10.0f;
    } else if (!layout.isSeatAvailable) {
        cell.backgroundImageView.image = [UIImage imageNamed:@"bookedSeat.png"];
        cell.backgroundImageView.alpha = .5f;
        cell.seatNo.alpha = .9f;
    } else {
        cell.backgroundImageView.image = [UIImage imageNamed:@"availableSeat.png"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake(mainScreenBounds.size.width/3 -2,
                      mainScreenBounds.size.width/2.5) ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 241.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        return reusableview;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GoBusSeatLayout *layout = [self.seats objectAtIndex:indexPath.row];
    if (layout.isSeatAvailable) {
        GoPaymentConfirmation *paymentVC = [[GoPaymentConfirmation alloc] initWithBusDetails:self.busDetails withSeatNo:layout.seatNo];
        [self.navigationController pushViewController:paymentVC animated:YES];
    } else {
        NSString *alertControllerTitle = @"Seat Already Booked";
        NSString *alertControllerMessaage = @"Seats which are in orange and blue color is already booked, please select a seat which is in white and black color";
        if (layout.seatNo && [layout.seatNo isEqualToString:@""]) {
            alertControllerTitle = @"Travel with your friend";
            alertControllerMessaage = @"Contact goibibo to travel with your friend.";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertControllerTitle message:alertControllerMessaage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)loadBusLayoutMetrix {
 
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://developer.goibibo.com/api/bus/seatmap/?app_id=abfac0dc&app_key=5368f504b75224601dccebd153275543&format=json"];
    
    [urlString appendString:[NSString stringWithFormat:@"&skey=%@",self.busDetails.skey]];
    urlString = (NSMutableString *) [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveBusSeatLayoutFromResponseObject:responseObject];
        
        if (self.seats.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"All seats might have already booked, Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.collectionView setHidden:NO];
        [self.searchingView setHidden:YES];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in Fetching seat matrix" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [operation start];
}

- (void)saveBusSeatLayoutFromResponseObject:(id)responseObject {
    
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSMutableArray *busSeats = [[data valueForKey:@"onwardSeats"] mutableCopy];
    [busSeats  sortUsingFunction:sortSeatNumber context:NULL];
    
    for(id busSeat in busSeats) {
        GoBusSeatLayout *busSeatLayout = [[GoBusSeatLayout alloc] init];
        busSeatLayout.seatNo = busSeat[@"SeatName"];
        NSNumber *seatStstusValue = busSeat[@"SeatStatus"];
        busSeatLayout.isSeatAvailable = seatStstusValue.boolValue;
        [self.seats addObject:busSeatLayout];
    }
    
    NSLog(@"SuccessFully Parserd and saved the results in correct format");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

NSComparisonResult sortSeatNumber(id seat1, id seat2, void * context) {
    NSString *seatNo1 = seat1[@"SeatName"];
    NSString *seatNo2 = seat2[@"SeatName"];
    if (seatNo1.length == 2) {
        seatNo1 = [NSString stringWithFormat:@"0%@", seatNo1];
    }
    if (seatNo2.length == 2) {
        seatNo2 = [NSString stringWithFormat:@"0%@", seatNo2];
    }
    return [seatNo1 caseInsensitiveCompare:seatNo2];
}

@end
