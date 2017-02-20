//
//  LSUpAndDownMode.h
//  LoveStory
//
//  Created by zang qilong on 2017/2/20.
//  Copyright © 2017年 Zangqilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LSUpAndDownMode : NSObject

+ (AVMutableVideoComposition *)createVideoInstructionWithFirstTrack:(AVAssetTrack *)firstTrack
                                                     andSecondTrack:(AVAssetTrack *)secondTrack
                                                        andDuration:(CMTime)duration;

+ (AVMutableVideoComposition *)createAnimationVideoInstructionWithFirstTrack:(AVAssetTrack *)firstTrack
                                                              andSecondTrack:(AVAssetTrack *)secondTrack
                                                                 andDuration:(CMTime)duration;

@end
