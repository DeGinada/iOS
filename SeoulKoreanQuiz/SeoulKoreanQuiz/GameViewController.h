//
//  GameViewController.h
//  SeoulKoreanQuiz
//
//  Created by DeGi on 2017. 6. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <NSXMLParserDelegate> {
    
    NSString *nowTagStr;
    NSString *txtBuffer;
    
    NSMutableDictionary* dicQuizInfo;
    NSMutableDictionary* dicRowData;
    NSMutableArray* arQuiz;
}

@end
