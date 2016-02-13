//
//  GoSearchPlaceViewController.m
//  GoIbibo
//
//  Created by Sachin Vas on 9/24/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSearchPlaceViewController.h"

@interface GoSearchPlaceViewController () <UISearchBarDelegate>

@property (nonatomic, copy) NSString *selectedPlace;
@property (nonatomic, strong) NSMutableArray *placeArray;
@property (nonatomic, strong) NSMutableArray *searchPlaceArray;
@property (nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;

@end

@implementation GoSearchPlaceViewController

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

    self.seachBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonItemPressed:)];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = self.isSourcePlace ? @"Seach Source Places" : @"Search Destination Places";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemPressed:(id)sender {
    self.updateSelectedPlace(self.selectedPlace);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return self.searchPlaceArray.count;
    }
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearching) {
        self.selectedPlace = self.searchPlaceArray[indexPath.row];
    } else {
        self.selectedPlace = self.placeArray[indexPath.row];
    }
    [self rightBarButtonItemPressed:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchPlaceArray = [[self.placeArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText]] mutableCopy];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _isSearching = NO;
}

@end
