//
//  MatchViewController.h
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 2..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchViewController : UIViewController

@property (nonatomic, retain) NSMutableDictionary* m_dicWord;

@property IBOutlet UILabel* lbMeaning;
@property IBOutlet UILabel* lbCount;
@property IBOutlet UIButton* btnAnswer1;
@property IBOutlet UIButton* btnAnswer2;
@property IBOutlet UIButton* btnAnswer3;
@property IBOutlet UIButton* btnAnswer4;
@property IBOutlet UIImageView* imgO;
@property IBOutlet UIImageView* imgX;



@end
