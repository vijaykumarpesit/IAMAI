//
//  GoContactSync.m
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoContactSync.h"
#import "GoContactSyncEntry.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/CNContact.h>

#define kContactsFilePath @"contacts.filepath"

@implementation GoContactSync


+ (instancetype)sharedInstance {
    
    static GoContactSync *contactSync = nil;
    
    if (!contactSync) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            contactSync = [[GoContactSync alloc] init];
        });
    }
    
    return contactSync;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isAddressBookSynced"]){
            [self syncAddressBookIfNeeded];
        }
    }
    return self;
}

- (NSSet *)getAllAddressBookEntries {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSArray *pplArray = (NSArray *)CFBridgingRelease(people);
    NSInteger i, max;
    
    max = [pplArray count];
    NSMutableSet *addressBookEntries = [NSMutableSet setWithCapacity:max];
    
    for (i=0 ; i<max ; i++)
    {
        ABRecordRef person = CFBridgingRetain([pplArray objectAtIndex:i]);
        
        if (person)
        {
            ABMultiValueRef properties = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSArray *allProperties = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(properties);
            NSEnumerator *propertiesEneumerator = [allProperties objectEnumerator];
            NSString *phoneNumber;
            
            while (phoneNumber = [propertiesEneumerator nextObject])
            {
                ABRecordID recordId = ABRecordGetRecordID(person);
                
                NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                NSString *middleName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
                
                NSString *fullName = nil;
                if (firstName)
                {
                    fullName = [NSString stringWithString:firstName];
                    if(middleName)
                        fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:middleName];
                    if (lastName)
                        fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:lastName];
                }
                else if(middleName)
                {
                    fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:middleName];
                    if (lastName)
                        fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:lastName];
                }
                else if (lastName)
                    fullName = [NSString stringWithString:lastName];
                
                if (phoneNumber.length > 0)
                    {
                        GoContactSyncEntry *entry = [[GoContactSyncEntry alloc] init];
                        entry.addressBookId = recordId;
                        entry.name = fullName;
                        NSString *phoneNo = [NSMutableString stringWithString:[[self class] trimNonDecimalCharactersInNumber:phoneNumber]];
                        if (phoneNo.length>10) {
                            phoneNo = [phoneNo substringFromIndex:phoneNo.length - 10];
                        }
                        entry.phoneNumber = phoneNo;
                        [addressBookEntries addObject:entry];
                    }
                
                
                
                if (firstName)
                    CFRelease((__bridge CFTypeRef)(firstName));
                if (lastName)
                    CFRelease((__bridge CFTypeRef)(lastName));
                if (middleName)
                    CFRelease((__bridge CFTypeRef)(middleName));
            }
            if (allProperties)
                CFRelease((__bridge CFTypeRef)(allProperties));
            if (properties)
                CFRelease(properties);
        }
    }
    
    if (addressBook && addressBook!=NULL)
        CFRelease(addressBook);
    return addressBookEntries;
}

- (void)syncAddressBookIfNeeded {
    
    if (self.isSyncProgress) {
        return;
    }
    self.isSyncProgress = YES;
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRef adressBoook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(adressBoook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSSet *results =  [self getAllAddressBookEntries];
            [self writeEntries:results];
            self.isSyncProgress = NO;
        });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSSet *results =  [self getAllAddressBookEntries];
            [self writeEntries:results];
            self.isSyncProgress = NO;
        });

    }
    
}

- (void)writeEntries:(NSSet *)entries {
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    for(GoContactSyncEntry *entry in entries) {
        resultDict[entry.phoneNumber] = entry;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:resultDict forKey:kContactsFilePath];
    [archiver finishEncoding];
    [data writeToFile:[self contactsFilePath] atomically:YES];

}


- (NSDictionary *)syncedContacts {
    
    if (!_syncedContacts) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self contactsFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _syncedContacts = [unarchiver decodeObjectForKey:kContactsFilePath];
        [unarchiver finishDecoding];
        return _syncedContacts;
    }
    return _syncedContacts;
}

- (NSString *)contactsFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:kContactsFilePath];
    return filePath;
}

+ (NSString *)trimNonDecimalCharactersInNumber:(NSString *)phoneNumber
{
    return [[self class] string:phoneNumber normliseWithCharcterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

+ (NSString *)string:(NSString *)string normliseWithCharcterSet:(NSCharacterSet *)characterSet
{
    NSMutableString *strippedString = [NSMutableString stringWithCapacity:string.length];
    
    if (string)
    {
        NSScanner *scanner = [NSScanner scannerWithString:string];
        
        while ([scanner isAtEnd] == NO)
        {
            NSString *buffer;
            
            if ([scanner scanCharactersFromSet:characterSet intoString:&buffer])
            {
                [strippedString appendString:buffer];
            } else
            {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
        }
    }
    
    return strippedString;
}

@end

