// DrawingView.m
#import "DrawingView.h"

@interface DrawingView ()

@property (nonatomic, strong) UIBezierPath *currentPath;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *paths;

@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) NSMutableArray<UIColor *> *pathColors; // Добавляем массив для хранения цветов линий

@property (nonatomic, assign) CGFloat currentLineWidth; // Добавляем переменную для хранения текущей толщины линии
@property (nonatomic, strong) UIButton *thicknessButton;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *pathWidths; // Добавляем массив для хранения толщин линий

@end

@implementation DrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    self.currentColor = [UIColor blackColor];
    self.currentPath = [UIBezierPath bezierPath];
    self.paths = [NSMutableArray array];
    self.pathColors = [NSMutableArray array]; // Инициализируем массив цветов
    self.currentLineWidth = 2.0; // Устанавливаем начальную толщину линии

    // Добавление кнопки выбора толщины линии
    self.thicknessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.thicknessButton setTitle:@"Выбрать толщину" forState:UIControlStateNormal];
    [self.thicknessButton addTarget:self action:@selector(selectThickness) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.thicknessButton];
    
    // Добавление кнопки выбора цвета
    self.colorButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.colorButton setTitle:@"Выбрать цвет" forState:UIControlStateNormal];
    [self.colorButton addTarget:self action:@selector(selectColor) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.colorButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Размещение кнопки в удобном для вас месте
    self.colorButton.frame = CGRectMake(5, 20, 120, 40);
    
    // Размещение кнопки в удобном для вас месте
    self.thicknessButton.frame = CGRectMake(160, 20, 160, 40);
}

- (void)selectThickness {
    // Здесь вы можете использовать UIAlertController для выбора толщины
    // или открыть отдельный экран с выбором толщины
    // Для примера, мы использовать UIAlertController

    UIAlertController *thicknessAlert = [UIAlertController alertControllerWithTitle:@"Выберите толщину" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *thinAction = [UIAlertAction actionWithTitle:@"Тонкая" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentLineWidth:1.0];
    }];

    UIAlertAction *mediumAction = [UIAlertAction actionWithTitle:@"Средняя" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentLineWidth:2.0];
    }];

    UIAlertAction *thickAction = [UIAlertAction actionWithTitle:@"Толстая" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentLineWidth:5.0];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];

    [thicknessAlert addAction:thinAction];
    [thicknessAlert addAction:mediumAction];
    [thicknessAlert addAction:thickAction];
    [thicknessAlert addAction:cancelAction];

    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [rootViewController presentViewController:thicknessAlert animated:YES completion:nil];
}

- (void)setCurrentLineWidth:(CGFloat)width {
    _currentLineWidth = width;
    [self.currentPath setLineWidth:width];
    [self.pathWidths addObject:@(width)]; // Сохраняем толщину текущей линии
    [self setNeedsDisplay];
}

- (void)selectColor {
    UIAlertController *colorAlert = [UIAlertController alertControllerWithTitle:@"Выберите цвет" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *redAction = [UIAlertAction actionWithTitle:@"Красный" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentLineColor:[UIColor redColor]];
    }];

    UIAlertAction *blueAction = [UIAlertAction actionWithTitle:@"Синий" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentLineColor:[UIColor blueColor]];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];

    [colorAlert addAction:redAction];
    [colorAlert addAction:blueAction];
    [colorAlert addAction:cancelAction];

    // Используем rootViewController для отображения UIAlertController
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [rootViewController presentViewController:colorAlert animated:YES completion:nil];
}

- (void)setCurrentLineColor:(UIColor *)color {
    _currentColor = color;
    [self.currentPath setLineWidth:2.0];
    [self.currentPath setLineJoinStyle:kCGLineJoinRound];
    [self.currentPath setLineCapStyle:kCGLineCapRound];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.currentPath moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.currentPath addLineToPoint:point];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.paths addObject:self.currentPath];
    [self.pathColors addObject:_currentColor]; // Сохраняем цвет текущей линии
    [self.pathWidths addObject:@(_currentLineWidth)];
    self.currentPath = [UIBezierPath bezierPath];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (context != NULL) {
        for (NSInteger i = 0; i < self.paths.count; i++) {
            [self.pathColors[i] setStroke]; // Устанавливаем цвет для каждой линии
            [self.paths[i] stroke];
        }

        [_currentColor setStroke];
        [self.currentPath setLineWidth: _currentLineWidth];
        [self.currentPath stroke];
    }
}

@end
