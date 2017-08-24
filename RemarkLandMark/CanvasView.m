//
//  CanvasView.m
//  Created by sluin on 15/7/1.
//  Copyright (c) 2015年 SunLin. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

- (void)drawRect:(CGRect)rect {
    [self drawPointWithPoints:self.arrPersons];
}

-(void)drawPointWithPoints:(NSArray *)arrPersons
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    [[UIColor greenColor] set];
    CGContextSetLineWidth(context, 2);
    
    for (NSDictionary *dicPerson in self.arrPersons) {
        if ([dicPerson objectForKey:POINTS_KEY]) {
            for (NSValue *pointValue in [dicPerson objectForKey:POINTS_KEY]) {
                CGPoint p = [pointValue CGPointValue] ;
                CGContextFillRect(context, CGRectMake(p.x - 1.0 , p.y - 1.0 , 2.0 , 2.0));
            }
            
//            [self drawOutLineWithArray:[dicPerson objectForKey:POINTS_KEY]];
        }
        if ([dicPerson objectForKey:RECT_KEY]) {
            CGContextSetLineWidth(context, 2);
            CGContextStrokeRect(context, [[dicPerson objectForKey:RECT_KEY] CGRectValue]);
        }
    }
}

- (void) drawOutLineWithArray:(NSArray *) pointsArray {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    //face 0-32
    for (int i=0; i <= 32; i++) {
        [tempArray addObject:pointsArray[i]];
    }
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    //right eyebrow
    for (int i = 33; i <= 37; i++) {// right up eyebrow
        [tempArray addObject:pointsArray[i]];
    }
    for (int i = 67; i >= 64; i--) {// right down eyebrow
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray addObject:pointsArray[33]];
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    //left eyebrow
    for (int i = 38; i <= 42; i++) {// left up eyebrow
        [tempArray addObject:pointsArray[i]];
    }
    for (int i = 71; i >= 68; i--) {// left down eyebrow
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray addObject:pointsArray[38]];
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    //right eye up
    for (int i = 52; i <= 55; i++) {
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray insertObject:pointsArray[72] atIndex:2];
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    // left eye up
    for (int i = 58; i <= 61; i++) {
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray insertObject:pointsArray[75] atIndex:2];
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    //right eye bottom
    [tempArray addObject:pointsArray[52]];
    for (int i = 57; i >= 55; i--) {
        [tempArray addObject:pointsArray[i]];
    }
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    [tempArray addObject:pointsArray[58]];
    
    //left eye bottom
    for (int i = 63; i >= 61; i--) {
        [tempArray addObject:pointsArray[i]];
    }
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    for (int i = 43; i <= 46; i++) {//鼻中线
        [tempArray addObject:pointsArray[i]];
    }
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    [tempArray addObject:pointsArray[78]];//鼻右上
    [tempArray addObject:pointsArray[80]];//鼻右中
    [tempArray addObject:pointsArray[82]];//鼻右下
    for (int i = 47; i <= 51; i++) {//鼻下线
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray addObject:pointsArray[83]];//鼻左下
    [tempArray addObject:pointsArray[81]];//鼻左中
    [tempArray addObject:pointsArray[79]];//鼻左上
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    //上嘴唇
    for (int i = 84; i <= 90; i++) {
        [tempArray addObject:pointsArray[i]];
    }
    for (int i = 100; i >= 96; i--) {
        [tempArray addObject:pointsArray[i]];
    }
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
    
    //下嘴唇
    for (int i = 90; i <= 95; i++) {
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray addObject:pointsArray[84]];//右嘴角
    [tempArray addObject:pointsArray[96]];//右唇角
    for (int i = 103; i >= 101; i--) {
        [tempArray addObject:pointsArray[i]];
    }
    [tempArray addObject:pointsArray[100]];//左唇角
    [self drawLineWithPointArray: tempArray];
    [tempArray removeAllObjects];
}

- (void)drawLineWithPointArray:(NSArray *) pointsArray {
    
    if (pointsArray == nil || pointsArray.count <= 1) {
        return;
    }
    
    [self smoothedPathWithPoints:pointsArray andGranularity:4];
}

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
- (void)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity {
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 0.6);
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    CGContextAddPath(context, smoothedPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
