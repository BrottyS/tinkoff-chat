//
//  LogoView.swift
//  TinkoffChat
//
//  Created by BrottyS on 27.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class LogoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImageView(image: UIImage(named: "tinkoff"))
        image.contentMode = .scaleAspectFit
        image.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        /*
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.alpha = 0.0
            self.center = self.randomPoint(radius: 100.0)
        }, completion: { _ in
            self.removeFromSuperview()
        })*/
        
         UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
            self.center = self.randomPoint(radius: 100.0)
         }, completion: { _ in
            self.removeFromSuperview()
         })
    }
    
    private func randomPoint(radius: Float) -> CGPoint {
        let angle = Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max - 1) * Float.pi * 2.0
        let x = radius * cos(angle)
        let y = radius * sin(angle)
        return CGPoint(x: CGFloat(x) + center.x, y: CGFloat(y) + center.y)
    }
    
}
