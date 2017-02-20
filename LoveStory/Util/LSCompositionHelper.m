
//
//  LSCompositionHelper.m
//  LoveStory
//
//  Created by zang qilong on 2017/2/15.
//  Copyright © 2017年 Zangqilong. All rights reserved.
//

#import "LSCompositionHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "LSUpAndDownMode.h"

@interface LSCompositionHelper ()

@property (nonatomic, strong) AVMutableComposition *mixComposition;

@property (nonatomic, strong) AVMutableCompositionTrack *firstTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *secondTrack;

@property (nonatomic, strong) NSMutableArray *videoAssetArray;
@property (nonatomic, strong) NSMutableArray *audioAssetArray;

@property (nonatomic, strong) AVMutableVideoComposition * videoComsitionInstruction;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) CMTimeRange transitionTimeRange;

@end

@implementation LSCompositionHelper

- (id)init {
    if (self = [super init]) {

        self.mixComposition =  [[AVMutableComposition alloc] init];
        
        self.firstTrack = [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        self.secondTrack = [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    
    return self;
}

- (void)addVideoAsset:(AVAsset *)asset atTime:(CMTime)atTime withTimeRange:(CMTimeRange)timeRange
{
    NSError *error = nil;
    [self.firstTrack insertTimeRange:timeRange ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo].firstObject atTime:atTime error:&error];
    [self.videoAssetArray addObject:asset];
}

- (void)addAudioAsset:(AVAsset *)asset atTime:(CMTime)atTime withTimeRange:(CMTimeRange)timeRange
{
    NSError *error = nil;
    [self.secondTrack insertTimeRange:timeRange ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:atTime error:&error];
    [self.audioAssetArray addObject:asset];
}

- (void)loadVideoCompositionIns:(AVMutableVideoComposition *)videoComposition {
    self.videoComsitionInstruction = videoComposition;
}

- (void)export {
    
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    CMTime finalTime = CMTimeCompare(self.firstAsset.duration, self.secondAsset.duration) == -1 ? self.firstAsset.duration: self.secondAsset.duration;
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, finalTime) ofTrack:[[self.firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Now we repeat the same process for the 2nd track as we did above for the first track.
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, finalTime) ofTrack:[[self.secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //See how we are creating AVMutableVideoCompositionInstruction object.This object will contain the array of our AVMutableVideoCompositionLayerInstruction objects.You set the duration of the layer.You should add the lenght equal to the lingth of the longer asset in terms of duration.
    
    
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, finalTime);
    
    self.videoComsitionInstruction = [LSUpAndDownMode createAnimationVideoInstructionWithFirstTrack:firstTrack andSecondTrack:secondTrack andDuration:finalTime];
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"overlapVideo.mov"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    [exporter setVideoComposition:self.videoComsitionInstruction];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:exporter];
         });
     }];
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    [self.activityView startAnimating];
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    
    
    [self.activityView stopAnimating];
}

@end
