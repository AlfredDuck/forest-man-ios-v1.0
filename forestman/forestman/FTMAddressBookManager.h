//
//  FTMAddressBookManager.h
//  forestman
//
//  Created by alfred on 2017/3/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface FTMAddressBookManager : UIViewController
@property(nonatomic, strong) NSMutableArray *myFriends;
-(void)readAddressBook;
@end
