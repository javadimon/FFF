// ViewController.m
#import "ViewController.h"
#import "DrawingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DrawingView *drawingView = [[DrawingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:drawingView];
}

@end
