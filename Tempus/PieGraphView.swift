//
//  PieGraphView.swift
//  Tempus
//
//  Created by 神原良継 on 2019/05/21.
//  Copyright © 2019 YoshitsuguKambara. All rights reserved.
//

import UIKit

class PieGraphView: UIView {

    var _params:[Dictionary<String,AnyObject>]!
    var _end_angle:CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,params:[Dictionary<String,AnyObject>]) {
        super.init(frame: frame)
        _params = params;
        self.backgroundColor = UIColor.clear;
        _end_angle = -CGFloat(M_PI / 2.0);
    }
    
    
    @objc func update(link:AnyObject){
        let angle = CGFloat(M_PI*2.0 / 100.0);
        _end_angle = _end_angle +  angle
        if(_end_angle > CGFloat(M_PI*2)) {
            //終了
            link.invalidate()
        } else {
            self.setNeedsDisplay()
        }
        
    }
    
    func startAnimating(){
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2;
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/2;
        var max:CGFloat = 0;
        for dic : Dictionary<String,AnyObject> in _params {
            let value = CGFloat(dic["value"] as! Float)
            max += value;
        }
        
        
        var start_angle:CGFloat = -CGFloat(M_PI / 2);
        var end_angle:CGFloat    = 0;
        let radius:CGFloat  = x - 10.0;
        for dic : Dictionary<String,AnyObject> in _params {
            let value = CGFloat(dic["value"] as! Float)
            end_angle = start_angle + CGFloat(M_PI*2) * (value/max);
            if(end_angle > _end_angle) {
                end_angle = _end_angle;
            }
            var color: UIColor = dic["color"] as! UIColor
            //var _:UIColor = dic["color"] as! UIColor
            
            context.move(to: CGPoint(x: x, y: y))
            
            
            context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: start_angle, endAngle: end_angle, clockwise: false)
            
            //ここのコメントアウトを解除すると、中くりぬき
            //CGContextAddArc(context, x, y, radius/2,  end_angle, start_angle, 1);
            
            //CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
            
            context.setFillColor(color.cgColor)
            
            context.closePath();
            context.fillPath();
            start_angle = end_angle;
        }
        
    }

}
