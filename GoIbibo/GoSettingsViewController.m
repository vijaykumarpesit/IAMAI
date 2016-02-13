//
//  GoSettingsViewController.m
//  GoIbibo
//
//  Created by Sachin Vas on 9/22/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSettingsViewController.h"
#import "GoSettingsOption.h"
#import <DigitsKit/DigitsKit.h>
#import "GoLayoutHandler.h"

@interface GoSettingsViewController ()

@property (nonatomic, strong) NSMutableArray *settingOptions;

@end

@implementation GoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.contentInset = UIEdgeInsetsMake(65, 0, 10, 0);
    
    self.settingOptions = [NSMutableArray array];
    [self configureDataSource];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)configureDataSource {
    [self.settingOptions removeAllObjects];
    
    GoSettingsOption *logoutOption = [[GoSettingsOption alloc] init];
    logoutOption.imageName = @"";
    logoutOption.optiontext = @"Logout";
    logoutOption.indentationLevel = 0;
    [self.settingOptions addObject:logoutOption];
    
    GoSettingsOption *settingsOption = [[GoSettingsOption alloc] init];
    settingsOption.imageName = @"IconSettings";
    settingsOption.optiontext = @"Settings";
    settingsOption.showDisclosureIndicator = YES;
    settingsOption.indentationLevel = 0;
    [self.settingOptions addObject:settingsOption];
    
    GoSettingsOption *privacyOption = [[GoSettingsOption alloc] init];
    privacyOption.imageName = @"";
    privacyOption.optiontext = @"Privacy";
    privacyOption.indentationLevel = 0;
    [self.settingOptions addObject:privacyOption];
    
    GoSettingsOption *profileOption = [[GoSettingsOption alloc] init];
    profileOption.imageName = @"IconProfile";
    profileOption.optiontext = @"Profile";
    profileOption.indentationLevel = 0;
    [self.settingOptions addObject:profileOption];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoSettingsOption *settingOption = [self.settingOptions objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Setting"];
    }
    cell.backgroundColor = [UIColor clearColor];
//    if (settingOption.imageName) {
//        cell.imageView.image = [self highlightedImage:[UIImage imageNamed:settingOption.imageName] highligthedColor:[UIColor blackColor]];
//        cell.imageView.highlightedImage = [self highlightedImage:[UIImage imageNamed:settingOption.imageName] highligthedColor:[UIColor blackColor]];
//    }
    cell.textLabel.text = settingOption.optiontext;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [[Digits sharedInstance] logOut];
        [GoLayoutHandler sharedInstance].sideMenu = nil;
        [[[UIApplication sharedApplication] delegate] window].rootViewController = [[GoLayoutHandler sharedInstance] sideMenu];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)highlightedImage:(UIImage *)image highligthedColor:(UIColor *)highlightedColor {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [highlightedColor setFill];
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
