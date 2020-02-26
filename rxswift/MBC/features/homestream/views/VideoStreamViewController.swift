//
//  VideoStreamViewController.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/31/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class VideoStreamViewController: HomeStreamViewController {
    override func viewDidLoad() {
        let interactor = Components.homeStreamInteractor()
        interactor.setForVideoStream()
        viewModel = HomeStreamViewModel(interactor: interactor, socialService: Components.userSocialService)
        
        super.viewDidLoad()
    }
}
