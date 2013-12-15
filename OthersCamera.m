
#import "OthersCamera.h"
#define DegreesToRadians(x) ((x) * M_PI / 180.0)


@interface OthersCamera ()

@end

@implementation OthersCamera

@synthesize stillImageOutput, session, inputBack, inputFront, imagePreview, captureImage, cameraSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    FrontCamera = NO;
    cameraSwitch.selectedSegmentIndex = 1;
    captureImage.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializeCamera];
}

- (void)viewDidDisappear:(BOOL)animated {
	
	[session stopRunning];
	
	if (FrontCamera) {
        [session removeInput:inputFront];
    }
    else
    {
		[session removeInput:inputBack];
    }
	
	[session removeOutput:stillImageOutput];
	stillImageOutput = nil;
	inputFront = nil;
	inputBack = nil;
	session = nil;
    captureImage = nil;
    imagePreview=nil;
	
}


//AVCaptureSession to show live video feed in view
- (void) initializeCamera {

	session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.imagePreview.bounds;
	[self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
	
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
	
    NSError *error = nil;
	
	if(inputBack == nil)
	{
		inputBack = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
		if (!inputBack) {
			NSLog(@"ERROR: trying to open camera: %@", error);
		}
	}
	if(inputFront == nil)
	{
		inputFront = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
		if (!inputFront) {
			NSLog(@"ERROR: trying to open camera: %@", error);
		}
	}
	
    if (!FrontCamera) {
        [session addInput:inputBack];
    }else{
        
        [session addInput:inputFront];
    }
	
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
	
	[session startRunning];
	
}


- (void)setCamera {
	
	[session stopRunning];
	
	if (!FrontCamera) {
        [session removeInput:inputFront];
        [session addInput:inputBack];
    }
    else
    {
		[session removeInput:inputBack];
        [session addInput:inputFront];
    }
	
	[session startRunning];
}


- (IBAction)snapImage:(id)sender {
    if (!haveImage) {
        captureImage.image = nil; //remove old image from view
        captureImage.hidden = NO; //show the captured image view
        imagePreview.hidden = YES; //hide the live video feed
        [self capImage];
    }
    else {
        captureImage.hidden = YES;
        imagePreview.hidden = NO;
        haveImage = NO;
    }
}


- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}


- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    haveImage = YES;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) { //Device is ipad
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(768, 1022));
        [image drawInRect: CGRectMake(0, 0, 768, 1022)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 130, 768, 768);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        //or use the UIImage wherever you like
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
        
        
        
    }else{ //Device is iphone
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(320, 426));
        [image drawInRect: CGRectMake(0, 0, 320, 426)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 55, 320, 320);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
        
        NSArray *directoryNames = [NSArray arrayWithObjects:@"Others",nil];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        
        for (int i = 0; i < [directoryNames count] ; i++) {
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[directoryNames objectAtIndex:i]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
            
            NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"Others"];            NSData *imageData = UIImagePNGRepresentation(captureImage.image);
            time_t unixtime = (time_t)[[NSDate date]timeIntervalSince1970];
            NSString *timestamp = [NSString stringWithFormat:@"%ldOthersImage.PNG",unixtime];
            NSString *filePath = [folderPath stringByAppendingPathComponent:timestamp];
            [imageData writeToFile:filePath atomically:YES];
        }
    }
    
    //adjust image orientation based on device orientation
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"landscape left image");
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90));
        [UIView commitAnimations];
        
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        NSLog(@"landscape right");
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
        [UIView commitAnimations];
        
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"upside down");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
        [UIView commitAnimations];
        
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        NSLog(@"upside upright");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
        [UIView commitAnimations];
  
    }
}

-(void)dealloc
{
    AVCaptureInput* input = [session.inputs objectAtIndex:0];
    [session removeInput:input];
    AVCaptureVideoDataOutput* output = [session.outputs objectAtIndex:0];
    [session removeOutput:output];
    [session stopRunning];
    captureImage = nil;
    imagePreview=nil;
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)switchCamera:(id)sender { //switch cameras front and rear cameras
    if (cameraSwitch.selectedSegmentIndex == 0) {
        FrontCamera = YES;
        //[self initializeCamera];
		[self setCamera];
    }
    else {
        FrontCamera = NO;
        //[self initializeCamera];
		[self setCamera];
    }
}

@end
