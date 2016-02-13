//
//  GoSettingsOption.h
//  GoIbibo
//
//  Created by Sachin Vas on 9/22/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoSettingsOption : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *optiontext;
@property (nonatomic, getter=shouldShowDisclosureIndicator) BOOL showDisclosureIndicator;
@property (nonatomic) NSInteger indentationLevel;
@property (nonatomic, getter=isExpanded) BOOL expanded;

@end
