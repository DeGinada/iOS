//
//  SongTableViewCell.m
//  MediaInfoTest
//
//  Created by Sora Yeo on 2017. 4. 26..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SongTableViewCell.h"

@implementation SongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// [140729] artist 표시할 textview를 세팅한다
- (void) adjustContentPosition {
    
    // 좌우패딩, 상하패딩 없애기
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.detailTextView.textContainer.lineFragmentPadding = 0;
    self.detailTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 폰트 크기가 적용된 text의 사이즈를 가져온다
    CGSize fontSize = [self.textView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    CGSize size = CGSizeMake(self.textView.frame.size.width, fontSize.height);
    
    fontSize = [self.detailTextView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    CGSize detailSize;
    if (fontSize.width > self.detailTextView.frame.size.width) {
        // 크기가 기존 사이즈를 넘어갈 경우, 2줄 처리한다.
        detailSize = CGSizeMake(self.detailTextView.frame.size.width, fontSize.height*2);
    } else {
        detailSize = CGSizeMake(self.detailTextView.frame.size.width, fontSize.height);
    }
    
    // 두 textview를 중앙정렬하기 위해 기준이 되는 y값 계산
    CGFloat textViewY = (self.frame.size.height - (size.height+detailSize.height+3.0))/2;
    
    // 각 textview의 사이즈와 위치를 재설정한다.
    [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, textViewY, size.width, size.height)];
    [self.detailTextView setFrame:CGRectMake(self.detailTextView.frame.origin.x, textViewY+self.textView.frame.size.height+3.0f, detailSize.width, detailSize.height)];
    
}

@end
