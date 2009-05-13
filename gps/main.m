#import "DLocationDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"Pausing 1min");
	sleep(6);
	DLocationDelegate *obj = [[DLocationDelegate alloc] init];
	
	
	NSDate *now = [[NSDate alloc] init];
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:now
	interval:.01
	target:obj
	selector:@selector(startIt:)
	userInfo:nil
	repeats:YES];
 
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
	[runLoop run];
 
	[pool release];
	NSLog(@"Finished Everything, now closing");
return 0;

}
