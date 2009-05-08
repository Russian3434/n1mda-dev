#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface PlayerDelegate : NSObject <AVAudioPlayerDelegate>
{
	BOOL playing;
	AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

-(void) startIt:(NSTimer *)timer;
-(void) startItAgain:(NSTimer *)timer;
-(void) audioPlayerBeginInterruption: (AVAudioPlayer *)audioPlayer;
static void interruptionListener(void *inUserData, UInt32 interruptionState);

@end
