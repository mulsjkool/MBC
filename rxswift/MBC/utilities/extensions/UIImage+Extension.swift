//
//  UIImage+Extension.swift
//  ShiftMeApp
//
//  Created by Dao Le Quang on 7/20/16.
//  Copyright © 2016 Shift Me App. All rights reserved.
//

import ImageIO
import UIKit

public enum ImageFormat {
	case png
	case jpeg(CGFloat)
}

extension UIImage {

    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be
    /// reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data.
    /// This function may return nil if the image has no data or if the underlying CGImageRef contains data in an
	/// unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be
    /// reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data.
    /// This function may return nil if the image has no data or if the underlying CGImageRef contains data in an
	/// unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }

	// swiftlint:disable:next cyclomatic_complexity
    func fixedOrientation(quality: JPEGQuality = .medium) -> (image: UIImage, size: Int) {
        if imageOrientation == .up {
            return (image: self, size: -1)
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        }

		switch imageOrientation {
		case .upMirrored, .downMirrored:
			transform.translatedBy(x: size.width, y: 0)
			transform.scaledBy(x: -1, y: 1)
		case .leftMirrored, .rightMirrored:
			transform.translatedBy(x: size.height, y: 0)
			transform.scaledBy(x: -1, y: 1)
		case .up, .down, .left, .right:
			break
		}

		// swiftlint:disable:next line_length
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        if
			let data = UIImage(cgImage: ctx.makeImage()!).jpeg(quality),
			let image = UIImage.imageFromData(data, withMaxSize: size) {
            return (image: image, size: data.count)
        }

        return (image: self, size: -1)
    }

    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func resizeImage(_ newSize: CGSize) -> UIImage {
		guard self.size != newSize else { return self }

		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }

    static func imageFromURL(_ url: URL, withMaxSize size: CGSize) -> UIImage? {
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            let options: [NSString: NSObject] = [
                kCGImageSourceThumbnailMaxPixelSize: NSNumber(value: Float(max(size.width, size.height))),
                kCGImageSourceCreateThumbnailFromImageAlways: NSNumber(value: true)
            ]

			return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0) }
        }
        return nil
    }

    static func imageFromData(_ data: Data, withMaxSize size: CGSize) -> UIImage? {
        if let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
            let options: [NSString: NSObject] = [
				kCGImageSourceThumbnailMaxPixelSize: NSNumber(value: Float(max(size.width, size.height))),
				kCGImageSourceCreateThumbnailFromImageAlways: NSNumber(value: true)
            ]
			return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0) }
        }
        return nil
    }
	
	public func base64(format: ImageFormat) -> String? {
		var imageData: Data?
		switch format {
		case .png: imageData = UIImagePNGRepresentation(self)
		case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
		}
		return imageData?.base64EncodedString()
	}
}
