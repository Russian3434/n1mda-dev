#import "DLocationDelegate.h"

@implementation DLocationDelegate
@synthesize locationManager;

#define NSURLRequestReloadIgnoringLocalCachedata 1

void powerCallback(void *refCon, io_service_t service, natural_t messageType, void *messageArgument)
{
	[(DLocationDelegate *)refCon powerMessageReceived: messageType withArgument: messageArgument];
}

-(id) init
{
	if (self = [super init])
	{
		allowSleep = true;
		trackingGPS = false;
 
		NSLog(@"starting the location Manager");
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		
		NSLog(@"IORegisterForSystemPower()");
		root_port = IORegisterForSystemPower(self, &notificationPort, powerCallback, &notifier);
		
		// add the notification port to the application runloop
		CFRunLoopAddSource(CFRunLoopGetCurrent(),
										IONotificationPortGetRunLoopSource(notificationPort),
										kCFRunLoopCommonModes);
	}
	return self;
}

- (void)startIt:(NSTimer *)timer
{
	if(timer != nil) [timer invalidate];
	trackingGPS = true;
	[self.locationManager startUpdatingLocation];
}

- (void)startItAgain:(NSTimer *)timer
{
	if(!trackingGPS)
	{
 		
		NSLog(@"startItAgain: CFRunLoopAddSource()");
		
		trackingGPS = true;
		[self.locationManager startUpdatingLocation];
	}
}
 
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation
{
	srandom(time(0)); //do this to make sure that it does not use a cached page
	NSLog(@"Location found");

	if([newLocation horizontalAccuracy] < 600 && [newLocation horizontalAccuracy] > 0)
	{
		[self.locationManager stopUpdatingLocation];
		
		NSLog(@"Latitude %lf  Longitude %lf", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
 		
 		NSMutableString *update = [[NSMutableString alloc] initWithString:@"http://home.axeldoesstockholm.se/iPhoneLocationService.php?time="];
		
		NSNumber *latitude = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
		NSNumber *longitude = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
		NSNumber *altitude = [[NSNumber alloc] initWithDouble:newLocation.altitude];
		
		[update appendString:@"&latitude="];
		[update appendString:[latitude stringValue]];
		[update appendString:@"&longitude="];
		[update appendString:[longitude stringValue]];
 
		[update appendString:@"&ALTITUDE="];
		[update appendString:[altitude stringValue]];
		[update appendString:@"&distance="];
		
		if(oldLocation != nil)
		{
			NSLog(@"Calculating distance from old location");
			CLLocationDistance distanceMoved = [newLocation getDistanceFrom:oldLocation];
			NSTimeInterval timeElapsed = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
			
			NSNumber *distance  = [[NSNumber alloc] initWithDouble:distanceMoved];
			NSLog(@"Distance moved: %lf", distance);
			[update appendString:[distance stringValue]];
		}
 
		NSURL *theURL = [[NSURL alloc] initWithString:update];
 
		NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL
													cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
												timeoutInterval:120];
 
 
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest 
																	  delegate:self 
															  startImmediately:YES];
		if(connection == nil)
		{
			trackingGPS = NO;
		}		
 
		NSLog(@"setting timer for 30 minutes");
		NSTimer *timer =  [[NSTimer
							timerWithTimeInterval:1800.0
							//timerWithTimeInterval:3.0
							target:self
							selector:@selector(startItAgain:)
							userInfo:nil
							repeats:NO
							] retain];
							
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
 		
		[timer release];
		[latitude release];
		[longitude release];
		[altitude release];
		[theURL release];
		
	} else {
		NSLog(@"Accuracy not good enough: %lf", [newLocation horizontalAccuracy]);
 		}
}
 
- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
	trackingGPS = false;
 
	NSLog(@"trackingGPS failed %@", [error localizedDescription]);
}
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"GPS information Sent");
	trackingGPS = false;
	
	NSLog(@"Removing Sleep notification");
	// remove the sleep notification
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
										IONotificationPortGetRunLoopSource(notificationPort),
										kCFRunLoopCommonModes);
}
 
 
-(void) dealloc
{
	[locationManager release];
	[super dealloc];
}

- (void)powerMessageReceived:(natural_t)messageType withArgument:(void *)messageArgument
{
	switch(messageType)
	{
		case kIOMessageSystemWillSleep:
			// system WILL go to sleep. No stopping it. Just allow.
			
			NSLog(@"powerMessageReceived kIOMessageSystemWillSleep");
			IOAllowPowerChange(root_port, (long)messageArgument);
			break;
		
		case kIOMessageCanSystemSleep:
			// Idle sleep is about to kick in.
			
			NSLog(@"powerMessageReceived kIOMessageCanSystem Sleep");
			if(!allowSleep)
			{
				sleeping = false;
				IOCancelPowerChange(root_port, (long)messageArgument);
			} else {
				sleeping = true;
				IOAllowPowerChange(root_port, (long)messageArgument);
			}
			break;
		
		case kIOMessageSystemHasPoweredOn:
			NSLog(@"powerMessageReceived kIOMessageSystemHasPoweredOn");
			sleeping = false;
			break;
		
	}
}

@end
