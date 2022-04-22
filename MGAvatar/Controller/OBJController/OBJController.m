//
//  OBJController.m
//  MGAvatar
//
//  Created by Gaomingyang on 2022/4/21.
//

#import "OBJController.h"
#import <SceneKit/SceneKit.h>
#import <AssimpKit/PostProcessingFlags.h>
#import <AssimpKit/SCNAssimpAnimSettings.h>
#import <AssimpKit/SCNNode+AssimpImport.h>
#import <AssimpKit/SCNScene+AssimpImport.h>

@interface OBJController ()

@end

@implementation OBJController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OBJ";
    [self loadOBJ];
}
-(void)loadOBJ{
   
    NSURL *spiderObjUrl = [[NSBundle mainBundle] URLForResource:@"spider" withExtension:@".obj"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:spiderObjUrl.path]){
        // load mesh
        NSError *error = nil;
        SCNAssimpScene *scene = [SCNScene assimpSceneWithURL:spiderObjUrl postProcessFlags:AssimpKit_JoinIdenticalVertices |
                                 AssimpKit_Process_FlipUVs |
                                 AssimpKit_Process_Triangulate error:&error];
        [self showErrorIfNeeded:error];
        
        // retrieve the SCNView
        SCNView *scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-84)];
        [self.view addSubview:scnView];
        // set the scene to the view
        scnView.scene = scene.modelScene;
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = YES;
        // show statistics such as fps and timing information
        scnView.showsStatistics = YES;
        // config the view
        scnView.backgroundColor = [UIColor blackColor];
        // play
        scnView.playing = YES;
        
    }else{
        NSLog(@"[ERROR]: Add bob assets via iTunes file sharing");
    }
    
}

- (void)showErrorIfNeeded:(NSError *)error
{
    if (!error.localizedDescription.length)
    {
        return;
    }
    
    UIAlertController *vc = [UIAlertController
                             alertControllerWithTitle:@"Error"
                             message:error.localizedDescription
                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {}];
    [vc addAction:action];
    
    [UIApplication.sharedApplication.keyWindow.rootViewController
     presentViewController:vc
     animated:true
     completion:nil];
}

@end
