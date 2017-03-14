//
//  FTMAddressBookManager.m
//  forestman
//
//  Created by alfred on 2017/3/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMAddressBookManager.h"

@implementation FTMAddressBookManager

-(NSArray *)readAddressBook{
    NSLog(@"开始读取通讯录");
    
    //定义通讯录
    ABAddressBookRef tmpAddressBook = nil;
    
    //根据系统版本不同，调用不同方法获取通讯录
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        // dispatch_release(sema);
    } else {
        //yes i know, don't mind
        tmpAddressBook =ABAddressBookCreate();__IPHONE_6_0;
    }
    
    //取得通讯录失败
    if (tmpAddressBook==nil) {
        NSLog(@"获取通讯录失败");
        // [self.delegate readAddressBookFailAlert];
        return nil;
    };
    
    //将通讯录中的信息用数组方式读出
    NSArray* tmpPeoples = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    //遍历通讯录中的联系人
    _myFriends = [[NSMutableArray alloc] init];
    
    for(id tmpPerson in tmpPeoples){
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        //NSLog(@"First name:%@", tmpFirstName);
        //tmpFirstName = nil;
        
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        //NSLog(@"Last name:%@", tmpLastName);
        //tmpLastName = nil;
        
        //获取的联系人多属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        //遍历所有手机号
        //      for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        //      {
        //         NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
        //         NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
        //         //[tmpPhoneIndex release];
        //      }
        //只取第一个手机号
        NSString *tmpCellphone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, 0);
        //NSLog(@"Phone:%@", tmpCellphone);
        
        //将通讯录收录到自己的本地数据库
        NSString *tmpName = nil;
        if (!tmpFirstName) {
            tmpName = tmpLastName;
        }
        else if (!tmpLastName) {
            tmpName = tmpFirstName;
        }
        else {
            tmpName = [tmpFirstName stringByAppendingFormat:@"%@%@",@" ", tmpLastName];
        }
        
        NSDictionary *person = [NSDictionary dictionaryWithObjectsAndKeys:tmpName, @"name", tmpCellphone, @"phone",nil];
        // NSLog(@"%@", person);
        
        [_myFriends addObject:person];
    }
    NSLog(@"%@", _myFriends);
    return _myFriends;
}

@end
