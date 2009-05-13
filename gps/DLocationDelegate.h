#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSCalendarDate.h>
#import <UIKit/UIKit.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/IOMessage.h>
 
@interface DLocationDelegate : NSObject <CLLocationManagerDelegate>
{
	BOOL trackingGPS, allowSleep, sleeping;
	CLLocationManager *locationManager;
	
	io_connect_t root_port;
	io_object_t notifier;
	IONotificationPortRef notificationPort;
}
 
@property (nonatomic, retain) CLLocationManager *locationManager;
 
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;
 
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;
 
- (void) startIt:(NSTimer *) timer;
- (void) startItAgain:(NSTimer *)timer;
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void)powerMessageReceived:(natural_t)messageType withArguments:(void *)messageArgument;

@end
