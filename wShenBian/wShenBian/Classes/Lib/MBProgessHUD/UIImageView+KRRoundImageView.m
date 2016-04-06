//
//  UIImageView+KRRoundImageView.m
//  酷跑
//
//  Created by guoaj on 15/10/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "UIImageView+KRRoundImageView.h"

@implementation UIImageView (KRRoundImageView)
- (void) setRoundLayer
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width*0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}
@end
