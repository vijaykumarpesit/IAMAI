//
//  GoUser.m
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoUser.h"

NSString * const kKeyUserId = @"userID";
NSString * const kKeyName = @"name";
NSString * const kKeyPhoneNumber = @"phoneNumber";

@implementation GoUser

- (instancetype)initWithPFUser:(PFUser*)parseUser {
    if (self = [super init]) {
        self.parseUser = parseUser;
    }
    return self;
}


- (void)setUserID:(NSString*)userID {
    [self.parseUser setObject:userID forKey:kKeyUserId];
}

- (NSString*)userID {
    return [self.parseUser objectForKey:kKeyUserId];
}



- (void)setName:(NSString*)Name {
    [self.parseUser setObject:Name forKey:kKeyName];
}

- (NSString*)name {
    return [self.parseUser objectForKey:kKeyName];
}


- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self.parseUser setObject:phoneNumber forKey:kKeyPhoneNumber];
}

- (NSString*)phoneNumber {
    return [self.parseUser objectForKey:kKeyPhoneNumber];
}

- (void)saveUser {
    [self.parseUser saveInBackground];
}

@end
