//
//  ImageHelper.swift
//  MBC
//
//  Created by Tram Nguyen on 3/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class ImageHelper {

    static let shared = ImageHelper()

    private init() { }

    public func thumbnailImageURL(from image: Media, _ resolution: ImageResolution) -> URL? {
        guard let versionId = image.imageUrlWithId else { return nil }

        let ext = Constants.DefaultValue.ImageExtension
        let apiUrl = Components.config.apiImageUrl
        let urlString = "\(apiUrl)c_fill,g_auto,\(resolution.rawValue),dpr_2,w_136/c_fill,g_auto," +
        "\(resolution.rawValue),dpr_2,w_136/\(versionId).\(ext)"

        return URL(string: urlString)
    }

}
