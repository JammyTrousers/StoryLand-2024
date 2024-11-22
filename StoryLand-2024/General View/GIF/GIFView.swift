//
//  GIFView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import UIKit

class GIFView: UIView {
    
    private let imageView = UIImageView()
    var gifName: String?
    
    convenience init(gifName: String) {
        self.init()
        let gif = UIImage.gif(name: gifName)
        imageView.image = gif
        imageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.backgroundColor = .clear
        imageView.frame = bounds
        self.addSubview(imageView)
    }
    
    func loadGIF(gifName: String) {
        imageView.loadGif(name: gifName)
    }
}
