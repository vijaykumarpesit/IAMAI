//
//  GoContactSyncEntry.m
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoContactSyncEntry.h"

@implementation GoContactSyncEntry

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self){
        _phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        _addressBookId = (ABRecordID)[aDecoder decodeInt32ForKey:@"addressBookId"];
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeInt32:self.addressBookId forKey:@"addressBookId"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
