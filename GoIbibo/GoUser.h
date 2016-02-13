//
//  GoUser.h
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GoUser : NSObject

- (instancetype)initWithPFUser:(PFUser*)parseUser;

@property (nonatomic, strong)PFUser *parseUser;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;

- (void)saveUser;

@end
