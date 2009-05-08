#import "PlayerDelegate.h"

@implementation PlayerDelegate
@synthesize audioPlayer;

-(id) init
{
	if(self = [super init])
	{
		NSLog(@"Starting Music Player Daemon");
		
		AudioSessionInitialize(NULL, NULL, interruptionListener, self);
		UInt32 category = kAudioSessionCategory_MediaPlayback;
		if(!AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category))
			NSLog(@"Error setting AudioSessionSetProperty");
	
		AudioSessionSetActive(true);
		
		NSString *pathToMusicFile = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
	
		NSLog(@"Opening file: %@\n", pathToMusicFile);
		NSError *err;
		AVAudioPlayer* audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathToMusicFile] error:&err];

		[audioPlayer setDelegate:self];
		
		[audioPlayer prepareToPlay];
		if(![audioPlayer play]) {
			NSLog(@"Error playing audio %@", [err localizedDescription]);
		} else {
			NSLog(@"Playing %@", pathToMusicFile);
		}
	}
	return self;
}

static void interruptionListener(void *inUserData, UInt32 interruptionState)
{
	// Do nothing
}

- (void) startIt:(NSTimer *)timer
{
	if(timer != nil) [timer invalidate];
}

- (void) startItAgain:(NSTimer *)timer
{
	
}


- (void)audioPlayerDidFinishPlaying: (AVAudioPlayer *)audioPlayer successfully: (BOOL)flag
{
	NSLog(@"Finished");
}

- (void)audioPlayerBeginInterruption: (AVAudioPlayer *)audioPlayer
{
	[audioPlayer pause];
}
- (void)audioPlayerEndInterruption: (AVAudioPlayer *)audioPlayer
{
	[audioPlayer play];
}
