//
//  CapturingVC.swift
//  AVFoundationDemo
//
//  Created by 刘靖煌 on 2021/7/12.
//

import UIKit

class CapturingVC: UIViewController {
    
    lazy var metalB:UIButton = {
        let b = UIButton()
        b.setTitle("Metal", for: .normal)
        b.backgroundColor = .blue
        b.addTarget(self, action: #selector(metal), for: .touchUpInside)
        return b
    }()
    
    lazy var openglB:UIButton = {
        let b = UIButton()
        b.setTitle("OpenGLB", for: .normal)
        b.backgroundColor = .blue
        b.addTarget(self, action: #selector(opengl), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        view.addSubview(metalB)
        metalB.translatesAutoresizingMaskIntoConstraints = false
        metalB.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        metalB.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        metalB.heightAnchor.constraint(equalToConstant: 50).isActive = true
        metalB.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(openglB)
        openglB.translatesAutoresizingMaskIntoConstraints = false
        openglB.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        openglB.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 100).isActive = true
        openglB.heightAnchor.constraint(equalToConstant: 50).isActive = true
        openglB.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    @objc func metal() {
        self.navigationController?.pushViewController(MetalVC(), animated: true)
    }
    
    @objc func opengl() {
        
        self.navigationController?.pushViewController(OpenGLESVC(), animated: true)
    }
}
