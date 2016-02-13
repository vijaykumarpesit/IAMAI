//
//  GoBusListViewController.m
//  
//
//  Created by Vijay on 23/09/15.
//
//

#import "GoBusListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "GoBusDetails.h"
#import "GoBusInfoCell.h"
#import "GoSeatMetrixViewController.h"
#import <parse/parse.h>
#import "GoContactSync.h"
#import "GoUserModelManager.h"
#import "GoContactSyncEntry.h"

@interface GoBusListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchingView;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *arrivalDate;
@property (nonatomic, strong) NSMutableArray *busResults;
@property (nonatomic, strong) NSMutableArray *friendsList;
@end

@implementation GoBusListViewController

- (instancetype)initWithSource:(NSString *)source
                   destination:(NSString *)destination
                 departureDate:(NSDate *)departureDate
                   arrivalDate:(NSDate *)arrivalDate {
    self = [super initWithNibName:@"GoBusListViewController" bundle:nil];
    if (self) {
        self.source = source;
        self.destination = destination;
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        NSInteger seconds = [timeZone secondsFromGMTForDate:departureDate];
        self.departureDate = [NSDate dateWithTimeInterval:seconds sinceDate:departureDate];
        self.arrivalDate = arrivalDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ to %@", [self.source capitalizedString], [self.destination capitalizedString]];
    self.busResults = [[NSMutableArray alloc] init];
    self.friendsList = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoBusInfoCell" bundle:nil] forCellReuseIdentifier:@"busInfoCell"];
    [self loadDataFromGoIBibo];
    [self.tableView setHidden:YES];
    [self checkAndConfigureFriends];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.busResults.count > 0) {
        if (self.friendsList.count > 0) {
            return 2;
        }
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friendsList.count > 0) {
        if (section == 0) {
           return self.friendsList.count;
        } else {
            return self.busResults.count;
        }
    } else {
        return self.busResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoBusInfoCell *busInfoCell = [tableView dequeueReusableCellWithIdentifier:@"busInfoCell"];
    if (self.friendsList.count > 0 && indexPath.section == 0) {
        NSDictionary *bookedTicketInfo = [self.friendsList objectAtIndex:indexPath.row];
        busInfoCell.travellerName.text = bookedTicketInfo[@"passengerName"];
        busInfoCell.busTypeName.text = bookedTicketInfo[@"bookedUserPhoneNo"];
        
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ -->%@", bookedTicketInfo[@"source"], bookedTicketInfo[@"destination"]] attributes:nil];
        [mutableAttributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:(75.0f/255.0f) green:(150.0f/255.0f) blue:(10.0f/255.0f) alpha:1.0f]} range:NSMakeRange(0, [bookedTicketInfo[@"soruce"] length] + 3)];
        [mutableAttributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:(245.0f/255.0f) green:(50.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f]} range:NSMakeRange([bookedTicketInfo[@"soruce"] length] + 1, [bookedTicketInfo[@"destination"] length])];
        
        busInfoCell.availableSeats.text = [NSString stringWithFormat:@"%@ -->%@", bookedTicketInfo[@"source"], bookedTicketInfo[@"destination"]];
        busInfoCell.minimumFare.text = bookedTicketInfo[@"bookedSeatNo"];
        busInfoCell.departureToArrivalTime.text = bookedTicketInfo[@"travelsName"];
    } else {

        GoBusDetails *busDetails = [self.busResults objectAtIndex:indexPath.row];
        
        busInfoCell.travellerName.text = busDetails.travelsName;
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ -->%@",busDetails.departureTime,busDetails.arrivalTime] attributes:nil];
        [mutableAttributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]} range:NSMakeRange(0, busDetails.departureTime.length + 4)];
        busInfoCell.departureToArrivalTime.attributedText = mutableAttributedString;
        busInfoCell.minimumFare.text = [NSString stringWithFormat:@"\u20B9%@",busDetails.minimumFare];
        busInfoCell.availableSeats.text = [NSString stringWithFormat:@"%@ seats", busDetails.noOfSeatsAvailable];
        busInfoCell.busTypeName.text= busDetails.busType;
    }
    return busInfoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    GoBusDetails *busDetails = nil;
    NSString *seatNoToExlude = nil;
    
    if (self.tableView.numberOfSections ==1) {
        busDetails = [self.busResults objectAtIndex:indexPath.row];
    } else if(self.tableView.numberOfSections >1) {
        if (indexPath.section == 0) {
            NSDictionary *bookedBusDict = [self.friendsList objectAtIndex:indexPath.row];
            busDetails = [self buDetailObjectFromDictionary:bookedBusDict];
            seatNoToExlude = bookedBusDict[@"bookedSeatNo"];
        } else if(indexPath.section ==1) {
            busDetails = [self.busResults objectAtIndex:indexPath.row];
        }
    }
    
    GoSeatMetrixViewController *metrixVC = [[GoSeatMetrixViewController alloc] initWithBusDetails:busDetails
                                                                           seatNoReservedByFriend:seatNoToExlude];
    [self.navigationController pushViewController:metrixVC animated:YES];
}

- (GoBusDetails *)buDetailObjectFromDictionary:(NSDictionary *)dict {
    
    GoBusDetails *busDetails = [[GoBusDetails alloc] init];
    busDetails.skey = dict[@"skey"];
    busDetails.departureDate = dict[@"departureDate"];
    busDetails.departureTime = dict[@"departureTime"];
    busDetails.source = dict[@"source"];
    busDetails.destination = dict[@"destination"];
    busDetails.travelsName = dict[@"travelsName"];
    return busDetails;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.friendsList.count == 0) {
            return [NSString stringWithFormat:@"None of your friends are travelling on this date"];
        } else {
            return @"Hey!!! Find your friends travelling to the same destination on this Date";
        }
        
    } else if(section ==1) {
        return @"Select a Bus";
    }
    return nil;
}

- (void)loadDataFromGoIBibo {
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://developer.goibibo.com/api/bus/search/?app_id=abfac0dc&app_key=5368f504b75224601dccebd153275543&format=json"];
    
    [urlString appendString:[NSString stringWithFormat:@"&source=%@",self.source]];
    [urlString appendString:[NSString stringWithFormat:@"&destination=%@",self.destination]];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyyMMdd"];
    NSString *departureDateString = [dateformate stringFromDate:self.departureDate];
    [urlString appendString:[NSString stringWithFormat:@"&dateofdeparture=%@",departureDateString]];
    
    if (self.arrivalDate) {
        NSDateFormatter *dateformate=[[NSDateFormatter alloc] init];
        [dateformate setDateFormat:@"yyyyMMdd"];
        NSString *arrivalDateString = [dateformate stringFromDate:self.arrivalDate];
        [urlString appendString:[NSString stringWithFormat:@"&dateofarrival=%@",arrivalDateString]];
    }
    
    urlString = (NSMutableString *) [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [self saveBusInfoFromResponseObject:responseObject];
        [self.tableView setHidden:NO];
        [[[self.searchingView subviews] objectAtIndex:0] stopAnimating];
        [self.searchingView setHidden:YES];
        
        if (self.busResults.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No buses available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bus fetch failed " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [operation start];
}

- (void)saveBusInfoFromResponseObject:(id)responseObject {
    
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSArray *onwardBuses = [data valueForKey:@"onwardflights"];
    
    for(id bus in onwardBuses) {
        GoBusDetails  *busDetails = [[GoBusDetails alloc] init];
        busDetails.travelsName = bus[@"TravelsName"];
        busDetails.busType = bus[@"BusType"];
        busDetails.departureTime = bus[@"DepartureTime"];
        busDetails.arrivalTime = bus[@"ArrivalTime"];
        busDetails.rowID = bus[@"rowid"];
        busDetails.skey = bus[@"skey"];
        busDetails.source = bus[@"origin"];
        busDetails.destination = bus[@"destination"];
        NSString *dateString = bus[@"depdate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        NSDate*date = [dateFormatter dateFromString:dateString];
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        NSInteger seconds = [timeZone secondsFromGMTForDate:date];
        date = [NSDate dateWithTimeInterval:seconds sinceDate:date];
        busDetails.departureDate = date;
        
        NSDictionary *routeSeatTypeDetail = bus[@"RouteSeatTypeDetail"];
        NSArray *list = routeSeatTypeDetail[@"list"];
        NSDictionary *seatDict = [list firstObject];
        busDetails.noOfSeatsAvailable = seatDict[@"SeatsAvailable"];
        
        NSDictionary *fare = bus[@"fare"];
        NSNumber *fareValue = fare[@"totalfare"];
        busDetails.minimumFare = [NSString stringWithFormat:@"%@", fareValue];
        
        NSDictionary *feedback = bus[@"feedback"];
        NSNumber *ratingsValue = feedback[@"rating"];
        busDetails.ratings = [NSString stringWithFormat:@"%@", ratingsValue];
        [self.busResults addObject:busDetails];
    }
    
    NSLog(@"SuccessFully Parserd and saved the results in correct format");
}

- (void)checkAndConfigureFriends {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"BusBookingDetails"];
        [query whereKey:@"source" equalTo:self.source];
        [query whereKey:@"destination" equalTo:self.destination];
        [query whereKey:@"departureDate" greaterThanOrEqualTo:self.departureDate];
        NSDate *oneDayAddedToDeparture = [self.departureDate dateByAddingTimeInterval:24*60*60];
        [query whereKey:@"departureDate" lessThanOrEqualTo:oneDayAddedToDeparture];
        
        NSString *myNumber = [[[GoUserModelManager sharedManager] currentUser] phoneNumber];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            [objects enumerateObjectsUsingBlock:^(PFObject *  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *phoneNo = object[@"bookedUserPhoneNo"];
                
                GoContactSyncEntry *entry =[[[GoContactSync sharedInstance] syncedContacts] valueForKey:phoneNo];
                
                if (entry && ![phoneNo isEqualToString:myNumber]) {
                    
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                    for(id key in [object allKeys]) {
                        [mutableDict setValue:object[key] forKey:key];
                    }
                    [mutableDict setValue:entry.name forKey:@"passengerName"];
                    [self.friendsList addObject:mutableDict];
                }
            }];
            
            NSLog(@"Friends count %lu",(unsigned long)self.friendsList.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
    });
}

@end
