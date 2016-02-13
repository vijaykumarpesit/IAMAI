//
//  GOLocationPickerViewController.m
//  GoIbibo
//
//  Created by Vijay on 13/02/16.
//  Copyright © 2016 Vijay. All rights reserved.
//

#import "GOLocationPickerViewController.h"

@interface GOLocationPickerViewController ()
@property (nonatomic, copy) NSString *selectedPlace;
@property (nonatomic, strong) NSMutableArray *placeArray;
@property (nonatomic, strong) NSMutableArray *searchPlaceArray;
@property (nonatomic) BOOL isSearching;
@end

@implementation GOLocationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeArray = [NSMutableArray array];
    _searchPlaceArray = [NSMutableArray array];
    [_placeArray addObject:@"Bangalore"];
    [_placeArray addObject:@"Chennai"];
    [_placeArray addObject:@"Hyderabad"];
    [_placeArray addObject:@"Sirsi"];
    [_placeArray addObject:@"Kollam"];
    [_placeArray addObject:@"Mandya"];
    [_placeArray addObject:@"Mumbai"];
    [_placeArray addObject:@"Pondicherry"];
    [_placeArray addObject:@"Mysore"];
    [_placeArray addObject:@"Hubli"];
    

    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPlace"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchPlace"];
    }
    if (self.isSearching) {
        cell.textLabel.text = self.searchPlaceArray[indexPath.row];
    } else {
        cell.textLabel.text = self.placeArray[indexPath.row];
    }
    if ([self.selectedPlace isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

@end
