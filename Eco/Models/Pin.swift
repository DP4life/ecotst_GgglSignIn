//
//  Pin.swift
//  Eco
//
//  Created by Porcescu Artiom on 10/15/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import Foundation
import UIKit

class customPin: UIView {
    var img: UIImage!
    var borderColor: UIColor!
        
        init(frame: CGRect, image: UIImage, borderColor: UIColor) {
            super.init(frame: frame)
            self.img = image
            self.borderColor = borderColor
//            self.tag = tag
            setupViews()
        }
        
        func setupViews() {
            let imageView = UIImageView(image: img)
            imageView.frame=CGRect(x: 0, y: 0, width: 50, height: 50)
            imageView.layer.cornerRadius = 25
            imageView.layer.borderColor = borderColor?.cgColor
            imageView.layer.borderWidth = 4
            imageView.clipsToBounds = true
            let label = UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
            label.text = "▾"
            label.font = UIFont.systemFont(ofSize: 24)
            label.textColor = borderColor
            label.textAlignment = .center
            
            self.addSubview(imageView)
            self.addSubview(label)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("Error has occured")
        }
}
