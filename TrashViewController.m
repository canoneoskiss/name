
#import "TrashViewController.h"
#import "TrashCell.h"

@interface TrashViewController ()
@end



@implementation TrashViewController {
    NSMutableArray *trash ;
}

@synthesize collectionTrash;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}





- (void)viewDidLoad

{
    filenames = [NSMutableArray new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *locationStrings = [[NSArray alloc]initWithObjects:@"Bottoms", @"Dress", @"Coats", @"Others", @"hats", @"Tops",nil ];
    for(NSString* location in locationStrings){
        NSString *fPath = [documentsDirectory stringByAppendingPathComponent:location];
        NSError *error;
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fPath error:&error];
        collectionTrash.delegate =self;
        collectionTrash.dataSource=self;
        for(NSString *str in directoryContent){
            NSString *finalFilePath = [fPath stringByAppendingPathComponent:str];
            [filenames addObject:finalFilePath];
            
        }
        
    }
    
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    
    NSLog(@"j");
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    return [filenames count];
    NSLog(@"b");
}







- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{  static NSString *cellIdentifier = @"ReuseID";
    TrashCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imageInCell = (UIImageView*)[cell viewWithTag:1];
    NSString *cacheKey = filenames[indexPath.item];
    imageInCell.image = [self.imageCache objectForKey:cacheKey];
    if (imageInCell.image == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:filenames[indexPath.item]];
            if (image) {
                [self.imageCache setObject:image forKey:cacheKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    TrashCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    UIImageView *imageInCell = (UIImageView*)[updateCell viewWithTag:1];
                    imageInCell.image = image;
                });
            }
        });
    }
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"s:%d", [filenames count]);
    NSString *trashBin = [filenames objectAtIndex:indexPath.row];
    NSLog(@"k%@l",trashBin);
    [filenames removeObjectAtIndex:indexPath.row];
    [self deleteMyFiles:trashBin];
    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
NSString *myFileName;
-(void) deleteMyFiles:(NSString*)filePath {
    NSError *error;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
}


- (void)didReceiveMemoryWarning

{   [super didReceiveMemoryWarning];
    [self.imageCache removeAllObjects];
    
}



@end









