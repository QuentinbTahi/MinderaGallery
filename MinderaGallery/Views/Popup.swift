//
//  Popup
//  Busity
//
//  Created by Quentin BEAUDOUIN on 08/06/2016.
//  Copyright © 2016 Instama. All rights reserved.
//

import UIKit

class Popup: UIView, CAAnimationDelegate {
    
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    
    var tapBackgroundToDismiss = true
    var leftAction:(() -> (Void))?
    var rightAction:(() -> (Void))?

//    var layouted = false
    
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.layer.cornerRadius = 4
        let shadowPath:UIBezierPath  = UIBezierPath.init(roundedRect: (mainView.bounds), cornerRadius: 4)
        
        mainView.layer.shadowRadius = 20
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.shadowOffset = CGSize(width: 0, height: 6)
        mainView.layer.shadowPath = shadowPath.cgPath
        mainView.clipsToBounds = false
        
        leftButton.layer.cornerRadius = 17
        leftButton.layer.borderColor = UIColor.white.cgColor
        leftButton.layer.borderWidth = 1
        
        if rightButton != nil {
            rightButton.layer.cornerRadius = 17
            rightButton.layer.borderColor = UIColor.white.cgColor
            rightButton.layer.borderWidth = 1
        }
        
        
        
    }
    
    func setup(title:String, message:String, leftButtonTitle:String?, rightButtonTitle:String? = nil) {
        
        titleLbl.text = title
        messageLabel.text = message
        
        if leftButtonTitle != nil {
            leftButton.setTitle(leftButtonTitle, for: .normal)
        }
        else {
            buttonView.removeFromSuperview()
        }
        if rightButtonTitle != nil {
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
        else {
            rightButton.removeFromSuperview()
        }
        
        
        
        
    }
    
    
    func showInWindow(_ window:UIWindow, confetti:Bool = false) {

        frame = window.bounds
        
        mainView.transform = CGAffineTransform(translationX: 0, y: -(mainView.frame.size.height + mainView.frame.origin.y / 10))
        
        self.alpha = 0
        
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.alpha = 1
            self.mainView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { _ in
            if confetti {
                self.createParticles()
            }
        })


    }
    
    
    @IBAction func clickLeftButton(_ sender: UIButton) {
        hide(good: true)
        leftAction?()
        
    }

    @IBAction func clickRightButton(_ sender: UIButton) {
        hide(good: false)
        rightAction?()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        if tapBackgroundToDismiss {
            hide(good: false)
            rightAction?()
        }
        
    }
    
    
    func createParticles() {

        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: self.center.x, y: -40)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: self.frame.size.width/2, height: 1)
        
        let red = makeEmitterCell(color: #colorLiteral(red: 1, green: 0.6551469717, blue: 0.7989328296, alpha: 1))
        let green = makeEmitterCell(color: #colorLiteral(red: 1, green: 0.4528310671, blue: 0.1680153346, alpha: 1))
        let blue = makeEmitterCell(color: #colorLiteral(red: 1, green: 0.1965393141, blue: 0.2948422064, alpha: 1))
        
        particleEmitter.emitterCells = [red, green, blue]
        particleEmitter.birthRate = 0
        
        particleEmitter.beginTime = CACurrentMediaTime()
        particleEmitter.birthRate = 100
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            particleEmitter.birthRate = 4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            particleEmitter.birthRate = 0
        }
        
        
        self.layer.addSublayer(particleEmitter)
    }
    
    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 4
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 70
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 3
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        
        cell.contents = confeti(size: 4).cgImage
        
       
        
        return cell
    }
    
    private func confeti(size: Int) -> UIImage {
        
        let floatSize = CGFloat(size)
        let rect = CGRect(x:0,y: 0,width: floatSize,height: floatSize*1.75)
 
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        let ovalPath = UIBezierPath(rect: rect)
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        ovalPath.fill()
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }



    func hide(good:Bool){
        if good {
            
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    self.mainView.transform = CGAffineTransform(translationX: 0, y: self.mainView.frame.size.height / 7)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                    self.mainView.transform = CGAffineTransform(translationX: 0, y: -(self.mainView.frame.size.height + self.mainView.frame.origin.y/4))
                    self.alpha = 0
                })
                }, completion: { (finished) in
                    self.removeFromSuperview()
            })
        }
        else {
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
                
                let rotate = CGFloat.pi / 24.0 * (CGFloat(arc4random_uniform(3)) + 1.5)
                
                
                self.mainView.transform = CGAffineTransform(translationX: 0, y: self.mainView.frame.size.height + self.mainView.frame.origin.y / 4).rotated(by: rotate)
                self.alpha = 0
                }, completion: { (finished) in
                    self.removeFromSuperview()

            })
        }
        
    }

}
