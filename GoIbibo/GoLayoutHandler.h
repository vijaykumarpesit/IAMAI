//
//  GoLayoutHandler.h
//  GoIbibo
//
//  Created by Sachin Vas on 9/22/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESideMenu.h"

@interface GoLayoutHandler : NSObject

@property (nonatomic, strong) RESideMenu *sideMenu;

+ (GoLayoutHandler *)sharedInstance;

@end
