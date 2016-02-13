//
//  GoContactSyncEntry.h
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface GoContactSyncEntry : NSObject
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, assign) ABRecordID addressBookId;
@property (nonatomic, retain) NSString *name;
@end
