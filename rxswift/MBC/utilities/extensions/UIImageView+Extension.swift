//
//  UIImageView+Extension.swift
//  MBC
//
//  Created by Dao Le Quang on 12/13/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Kingfisher
import MisterFusion
import UIKit

extension UIImageView {
    
    class func setMaxDiskCacheSize(_ value: UInt) {
        ImageCache.default.maxDiskCacheSize = value
    }
    
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
    }
    
    func setSquareImage(imageUrl: String?, gifSupport: Bool = true) {
        setSquareImage(imageUrl: imageUrl, placeholderImage: R.image.iconNoLogo(), gifSupport: gifSupport)
    }
    
    func setSquareImage(imageUrl: String?, placeholderImage: UIImage?, gifSupport: Bool = true) {
        var placeHolderImg = R.image.iconNoLogo()
        if let placeholderImage = placeholderImage {
            placeHolderImg = placeholderImage
        }
        guard let url = imageUrl else {
            self.image = placeHolderImg
            setGifImageWithWatermark(toRemove: true)
            return
        }
        
        guard let gifUrl = URL(string: url) else {
            self.image = placeHolderImg
            setGifImageWithWatermark(toRemove: true)
            return
        }
        
        if url.isGifFileName {
            setGifImageWithWatermark(toRemove: gifSupport)
            self.setGifImage(url: gifUrl, autoPlay: gifSupport)
        } else {
            setGifImageWithWatermark(toRemove: true)
            self.setImage(gifUrl, placeholder: placeHolderImg)
        }
    }
    
    // Support for Cloudinary image
    func setImage(from image: Media, resolution: ImageResolution, gifSupport: Bool = true,
                  placeholder: UIImage? = nil) {
        guard image.imageUrlWithId != nil,
            let thumbnailUrl = ImageHelper.shared.thumbnailImageURL(from: image, resolution),
            let url = UIImageView.fullImageURL(from: image, resolution, gifSupport: gifSupport) else {
                if let video = image as? Video, let thumbnailUrl = URL(string: video.videoThumbnail ?? "") {
                    if video.thumbnailIsAGif {
                        if !gifSupport {
                            setImage(thumbnailUrl, placeholder: placeholder ?? R.image.iconPhotoPlaceholder())
                            self.setGifImageWithWatermark()
                            return
                        }
                        self.setGifImage(url: thumbnailUrl, autoPlay: true)
                    } else {
                        self.gifImage = nil
                        setImage(thumbnailUrl, placeholder: placeholder ?? R.image.iconPhotoPlaceholder())
                    }
                } else {
                    setSquareImage(imageUrl: image.originalLink, gifSupport: gifSupport)
                }
                
            	return
        }
        self.setImage(thumbnailUrl, placeholder: placeholder ?? R.image.iconPhotoPlaceholder()) { [weak self] in
            self?.setGifImageWithWatermark(toRemove: true)
            
            if image.isAGif {
                if !gifSupport {
                    // if not supporting gif, we just need the static image + GIF watermark
                    self?.setImage(url, placeholder: self?.image)
                    self?.setGifImageWithWatermark()
                    return
                }
                self?.setGifImage(url: url, autoPlay: false)
            } else {
                self?.gifImage = nil
                self?.setImage(url, placeholder: self?.image)
            }
        }
    }
    
    // When cell is reuse, we need to call this function to clear the Gif image to avoid side effect
    func handleGifReuse() {
        stopAnimatingGif()
        setGifImageWithWatermark(toRemove: true)
        SwiftyGifManager.defaultManager.deleteImageView(self)
        image = nil
    }
    
    func addRemoveVideoWatermark(toRemove: Bool) {
        guard let videoWatermark = R.image.iconVideoPlay() else { return }
        let playIconTag = 1009
        if toRemove {
            for subView in subviews where subView is UIImageView && subView.tag == playIconTag {
                subView.removeFromSuperview()
            }
            return
        }
        
        guard subviews.filter({ $0.tag == playIconTag }).isEmpty else { return }
        
        let watermark = UIImageView()
        watermark.image = videoWatermark
        watermark.tag = playIconTag
        addSubview(watermark)
        
        watermark.translatesAutoresizingMaskIntoConstraints = false
        self.addLayoutConstraints(
            watermark.width |==| videoWatermark.size.width,
            watermark.height |==| videoWatermark.size.height,
            watermark.centerX |==| self.centerX,
            watermark.centerY |==| self.centerY
        )
    }
    
    private func setGifImage(url: URL, autoPlay: Bool) {
        self.handleGifReuse()
        let setGifClosure = { [weak self] (gif: UIImage) in
            self?.setGifImage(gif, manager: SwiftyGifManager.defaultManager)
            if !autoPlay { self?.stopAnimatingGif() }
        }
        
        ImageCache.default.retrieveImage(forKey: url.absoluteString, options: nil) { cachedImage, _ in
            DispatchQueue.global().async {
                if let image = cachedImage, let data = UIImagePNGRepresentation(image) {
                    setGifClosure(UIImage(gifData: data))
                    return
                }
                ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) { _, _, _, data in
                    guard let gifData = data else { return }
                    setGifClosure(UIImage(gifData: gifData))
                }
            }
        }
    }
    
    private func setGifImageWithWatermark(toRemove: Bool = false) {
        guard let gifWatermark = R.image.iconGif() else { return }
        let gifIconTag = 1008
        if toRemove {
            for subView in subviews where subView is UIImageView && subView.tag == gifIconTag {
                subView.removeFromSuperview()
            }
            return
        }
        
        guard subviews.filter({ $0.tag == gifIconTag }).isEmpty else { return }

        let padding = CGFloat(8)
        let watermark = UIImageView()
        watermark.image = gifWatermark
        watermark.tag = gifIconTag
        addSubview(watermark)
        
        watermark.translatesAutoresizingMaskIntoConstraints = false
        self.addLayoutConstraints(
            watermark.width |==| gifWatermark.size.width,
            watermark.height |==| gifWatermark.size.height,
            watermark.left |==| self.left |+| padding,
            watermark.bottom |==| self.bottom |-| padding
        )
    }
        
    func pauseGifAnimation() {
        if gifImage == nil { return }
        stopAnimatingGif()
        setGifImageWithWatermark()
    }
    
    func resumeGifAnimation() {
        if gifImage == nil { return }
        startAnimatingGif()
        setGifImageWithWatermark(toRemove: true)
    }
    
    private func setImage(_ url: URL, placeholder: UIImage? = R.image.iconPhotoPlaceholder(),
                          completionHandler: (() -> Void)? = nil) {
        self.kf.setImage(with: url,
                         placeholder: placeholder,
                         options: [.transition(.fade(0.25)), .backgroundDecode],
                         completionHandler: { _, _, _, _ in
                            completionHandler?()
        })
    }
    
    private static func fullImageURL(from image: Media, _ resolution: ImageResolution,
                                     gifSupport: Bool = true) -> URL? {
        guard let versionId = image.imageUrlWithId else { return nil }
        
        let ext = gifSupport ? image.originalLink.fileExtension() : Constants.DefaultValue.ImageExtension
        let apiUrl = Components.config.apiImageUrl
        let urlString = "\(apiUrl)c_fill,g_auto,\(resolution.rawValue),dpr_2,w_600/c_fill,g_auto," +
                        "\(resolution.rawValue),dpr_2,w_600/\(versionId).\(ext)"
        
        return URL(string: urlString)
    }
}
