//
//  LoadingScreenViewController.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import UIKit

final class LoadingScreenViewController: UIViewController {
    
    let animationView = UIView()
    let maskLayer = CAShapeLayer()
    let cloudIndicator = UIBezierPath()
    
    var presenterProtocol: LoadingScreenPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenterProtocol.updateListOfCities()
        presenterProtocol.loadFavoritesWeatherInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView.frame = CGRect(x: self.view.center.x - 200, y: UIScreen.main.bounds.height - 100, width: 400, height: 200)
        animationView.backgroundColor = .clear
        self.view.addSubview(animationView)
        
        maskLayer.fillColor = UIColor.blue.cgColor
        maskLayer.strokeColor = UIColor.blue.cgColor
        maskLayer.lineWidth = 2
        
        let rect = self.animationView.frame
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/3
        
        cloudIndicator.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 320.degreesToRadians, clockwise: true)
        cloudIndicator.addArc(withCenter: CGPoint(x: rect.width * 0.5, y: rect.height * 0.35), radius: arcRadius, startAngle: 227.degreesToRadians, endAngle: 320.degreesToRadians, clockwise: true)
        cloudIndicator.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 227.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        cloudIndicator.close()
        cloudIndicator.stroke()
        
        maskLayer.path = cloudIndicator.cgPath
        self.animationView.layer.mask = maskLayer
        self.animationView.layer.addSublayer(maskLayer)
        
        animateLoading()
    }
    
    //MARK: - Private functions
    
    private func animateLoading () {
        let circleLayer = CAShapeLayer()
        circleLayer.backgroundColor = UIColor.yellow.cgColor
        circleLayer.opacity = 0.5
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        circleLayer.position = CGPoint(x: 40, y: 20)
        circleLayer.cornerRadius = 40
        let followPathAnimation = CAKeyframeAnimation(keyPath: "position")
        followPathAnimation.path = self.cloudIndicator.cgPath
        followPathAnimation.calculationMode = CAAnimationCalculationMode.paced
        followPathAnimation.speed = 0.01
        followPathAnimation.repeatCount = 1

        circleLayer.add(followPathAnimation, forKey: nil)
        
        maskLayer.addSublayer(circleLayer)
        
        
        UIView.animateKeyframes(withDuration: 4,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 4, animations: { [ weak self] in
                                        self?.view.backgroundColor = UIColor.white
                                    })
                                    
                                }) { _ in
                                    UIView.animate(withDuration: 3, delay: 8) {
                                        self.view.backgroundColor = UIColor.black
                                    }
                                }
    }

}

//MARK: - Presenter protocol

extension LoadingScreenViewController: LoadingScreenViewprotocol {
    func presentNetworkAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateCitiesWeather() {
        
    }
}
