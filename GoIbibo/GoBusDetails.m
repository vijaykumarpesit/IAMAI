//
//  GoBusDetails.m
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoBusDetails.h"

@implementation GoBusDetails

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
         GoBusDetails *busDetails = (GoBusDetails *)object;
        return [busDetails.skey isEqualToString:self.skey];
    }
    return NO;
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    NSUInteger prime = 31;
    
    result = prime * result + [self.skey hash];
    return result;
}
@end
