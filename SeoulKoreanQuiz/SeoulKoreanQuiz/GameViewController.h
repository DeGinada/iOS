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


//@property (nonatomic, readwrite) BOOL isCheckQuiz; // 퀴즈 정답 확인용인 경우
@property (nonatomic, readwrite) int nType; // 퀴즈, 정답확인(1), 다시풀기(2)
@property (nonatomic, readwrite) NSString* strNowQuizDate;      // 퀴즈 정답 확인용일 경우, 해당 퀴즈 date

@end
