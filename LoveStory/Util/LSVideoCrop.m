//
//  LSVideoCrop.m
//  LoveStory
//
//  Created by zang qilong on 2017/2/20.
//  Copyright © 2017年 Zangqilong. All rights reserved.
//

#import "LSVideoCrop.h"

@interface LSVideoCrop ()

@property (nonatomic, strong) AVAsset *cropAsset;

@end

@implementation LSVideoCrop

- (id)initWithCropAsset:(AVAsset *)asset {
    if (self = [super init]) {
        self.cropAsset = asset;
    }
    
    return self;
}

- (void)cropWithVideoSize:(CGSize)size {
    
   
}

@end
