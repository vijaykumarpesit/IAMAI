//
//  GoUserModelManager.m
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoUserModelManager.h"
#import <Parse/Parse.h>

@implementation GoUserModelManager

+ (GoUserModelManager *)sharedManager {
    static GoUserModelManager* sharedModelManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedModelManager = [[GoUserModelManager alloc] init];
    });
    
    return sharedModelManager;
}

-(instancetype)init {
    if(self = [super init]) {
        PFUser *parseUser = [PFUser currentUser];
        if (!parseUser) {
            parseUser = [PFUser user];
        }
        self.currentUser = [[GoUser alloc] initWithPFUser:parseUser];
    }
    
    return self;
}


@end
