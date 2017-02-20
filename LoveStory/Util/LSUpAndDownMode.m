//
//  LSUpAndDownMode.m
//  LoveStory
//
//  Created by zang qilong on 2017/2/20.
//  Copyright © 2017年 Zangqilong. All rights reserved.
//

#import "LSUpAndDownMode.h"


@implementation LSUpAndDownMode

+ (AVMutableVideoComposition *)createVideoInstructionWithFirstTrack:(AVAssetTrack *)firstTrack
                                                          andSecondTrack:(AVAssetTrack *)secondTrack
                                                             andDuration:(CMTime)duration {

    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
    //[firstlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
    [firstlayerInstruction setCropRectangle:CGRectMake(0, 0, 720, 360) atTime:kCMTimeZero];

    AVMutableVideoCompositionLayerInstruction *secondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    [secondlayerInstruction setCropRectangle:CGRectMake(0, 360, 720, 360) atTime:kCMTimeZero];
   // [secondlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:secondlayerInstruction,firstlayerInstruction,nil];
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(720, 720);

    return MainCompositionInst;
}

+ (AVMutableVideoComposition *)createAnimationVideoInstructionWithFirstTrack:(AVAssetTrack *)firstTrack
                                                     andSecondTrack:(AVAssetTrack *)secondTrack
                                                        andDuration:(CMTime)duration {
    
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
    [firstlayerInstruction setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-720, 0) toEndTransform:CGAffineTransformIdentity timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(2, duration.timescale))];
    [firstlayerInstruction setCropRectangle:CGRectMake(0, 0, 720, 360) atTime:kCMTimeZero];
    
    AVMutableVideoCompositionLayerInstruction *secondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    [secondlayerInstruction setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(720, 0) toEndTransform:CGAffineTransformIdentity timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(2, duration.timescale))];
    [secondlayerInstruction setCropRectangle:CGRectMake(0, 360, 720, 360) atTime:kCMTimeZero];
    
    // [secondlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:secondlayerInstruction,firstlayerInstruction,nil];
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(720, 720);
    
    return MainCompositionInst;
}

@end
