//
//  HomeViewController.m
//  LoveStory
//
//  Created by zang qilong on 2017/2/16.
//  Copyright © 2017年 . All rights reserved.
//

#import "HomeViewController.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <AVFoundation/AVFoundation.h>
#import "LSCompositionHelper.h"


@interface HomeViewController ()<CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) AVURLAsset *asset1;
@property (nonatomic, strong) AVURLAsset *asset2;
@property (nonatomic, strong) LSCompositionHelper *helper;
@property (nonatomic, strong) CTAssetsPickerController *picker;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picker = [[CTAssetsPickerController alloc] init];
    self.picker.delegate = self;
    
    self.helper = [[LSCompositionHelper alloc] init];
    // Do any additional setup after loading the view.
}

- (IBAction)loadAsset1:(id)sender {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}

- (IBAction)merge:(id)sender {
    self.helper.firstAsset = self.asset1;
    self.helper.secondAsset = self.asset2;
   

    [self.helper export];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CTAssetPicker Delegate 

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (!self.asset1) {
        PHAsset *phasset = assets.firstObject;
        [[PHImageManager defaultManager] requestAVAssetForVideo:phasset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            self.asset1 = asset;
        }];
        
    }else {
        PHAsset *phasset = assets.firstObject;
        [[PHImageManager defaultManager] requestAVAssetForVideo:phasset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            self.asset2 = asset;
        }];
    }
}

@end
