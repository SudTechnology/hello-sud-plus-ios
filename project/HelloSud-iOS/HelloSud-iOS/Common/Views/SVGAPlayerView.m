//
//  SVGAPlayerView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "SVGAPlayerView.h"
#import <SVGAPlayer/SVGAPlayer.h>
#import <SVGAPlayer/SVGAParser.h>
@interface SVGAPlayerView()<SVGAPlayerDelegate>
@property(nonatomic, strong)SVGAPlayer *svgaPlayer;
@property(nonatomic, strong)SVGAParser *svgaParser;
@property(nonatomic, strong)NSError *parserError;
@property(nonatomic, strong)SVGAVideoEntity *playItem;
@property(nonatomic, strong)EmptyBlock didFinishedBlock;
@property(nonatomic, assign)BOOL isNeedToPlay;
@end

@implementation SVGAPlayerView
- (void)setContentMode:(UIViewContentMode)contentMode {
    self.svgaPlayer.contentMode = contentMode;
}

/// 设置播放地址
/// @param url 播放URL
- (void)setURL:(NSURL *)url {
    [self prepare:url];
}

/// 开始播放
/// @param loops 循环次数
/// @param didFinished 播放结束
- (void)play:(NSInteger)loops didFinished:(EmptyBlock)didFinished {
    self.didFinishedBlock = didFinished;
    if (self.svgaPlayer != nil) {
        [self.svgaPlayer removeFromSuperview];
    }
    self.isNeedToPlay = YES;
    self.svgaPlayer = SVGAPlayer.new;
    self.svgaPlayer.delegate = self;
    self.svgaPlayer.loops = (int)loops;
    self.svgaPlayer.userInteractionEnabled = NO;
    self.svgaPlayer.contentMode = self.contentMode;
    [self addSubview: self.svgaPlayer];
    [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self layoutIfNeeded];
    [self checkIfNeedToPlay];
}

- (void)checkIfNeedToPlay {
    if (self.isNeedToPlay && self.playItem) {
        self.svgaPlayer.videoItem = self.playItem;
        [self.svgaPlayer startAnimation];
        self.playState = HSSVGAPlayerStateTypePlaying;
    }
}

- (void)prepare:(NSURL *)url {
    @autoreleasepool {
        WeakSelf
        self.parserError = nil;
        self.playState = HSSVGAPlayerStateTypePrepare;
        [self.svgaParser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            weakSelf.playState = HSSVGAPlayerStateTypeWaitPlay;
            weakSelf.playItem = videoItem;
            [weakSelf checkIfNeedToPlay];
        } failureBlock:^(NSError * _Nullable error) {
            weakSelf.playState = HSSVGAPlayerStateTypeFailed;
            weakSelf.parserError = error;
        }];
    }
}

#pragma mark SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    [self.svgaPlayer removeFromSuperview];
    self.svgaPlayer = nil;
    self.playState = HSSVGAPlayerStateTypeFinished;
    self.playItem = nil;
    self.isNeedToPlay = NO;
    if (self.didFinishedBlock) {
        self.didFinishedBlock();
    }
}

#pragma mark lazy
- (SVGAParser *)svgaParser {
    if (_svgaParser == nil) {
        _svgaParser = SVGAParser.new;
    }
    return _svgaParser;
}

@end
