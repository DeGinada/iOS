//
//  WordTableViewController.h
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 5..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSDictionary* m_dicWord;

@end
