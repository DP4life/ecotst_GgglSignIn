//
//  PinPhoto.swift
//  Eco
//
//  Created by Porcescu Artiom on 10/15/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import Foundation
import UIKit

class PinPhotoPreview: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemGreen
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        setupViews()
    }
    
    func setData(img: UIImage) {
        imgView.image = img
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imgView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "usrGreen")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error has occured")
    }
}
