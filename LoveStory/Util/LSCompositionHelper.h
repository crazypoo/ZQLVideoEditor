//
//  LSCompositionHelper.h
//  LoveStory
//
//  Created by zang qilong on 2017/2/15.
//  Copyright © 2017年 Zangqilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LSCompositionHelper : NSObject

@property (nonatomic, strong) AVURLAsset *firstAsset;
@property (nonatomic, strong) AVURLAsset *secondAsset;

- (void)addVideoAsset:(AVAsset *)asset atTime:(CMTime)atTime withTimeRange:(CMTimeRange)timeRange;

- (void)addAudioAsset:(AVAsset *)asset atTime:(CMTime)atTime withTimeRange:(CMTimeRange)timeRange;

- (void)loadVideoCompositionIns:(AVMutableVideoComposition *)videoComposition;

- (void)export;

@end
