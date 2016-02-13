//
//  GoUserModelManager.h
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoUser.h"

@interface GoUserModelManager : NSObject

+ (GoUserModelManager *)sharedManager;

@property (nonatomic, strong)  GoUser *currentUser;

@end
