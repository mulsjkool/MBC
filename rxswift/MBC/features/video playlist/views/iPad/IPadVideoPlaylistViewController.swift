//
//  IPadVideoPlaylistViewController.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class IPadVideoPlaylistViewController: BaseViewController {
	@IBOutlet weak private var contentTableView: UITableView!
	@IBOutlet weak private var listVideoTableView: UITableView!
	
	private let viewModel = VideoPlaylistViewModel(interactor: Components.videoPlaylistInteractor())
	
	private lazy var videoPlaylistDataSource: IPadListVideoPlaylistDataSource = {
		return IPadListVideoPlaylistDataSource(viewModel: self.viewModel)
	}()
	private lazy var contentVideoInfoDataSource: IPadContentVideoInfoDataSource = {
		return IPadContentVideoInfoDataSource(viewModel: self.viewModel)
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupTableView()
    }
	
	private func setupTableView() {
		listVideoTableView.dataSource = self
		listVideoTableView.delegate = self
		
		contentTableView.dataSource = self
		contentTableView.delegate = self
	}
}

// MARK: - UITableViewDataSource
extension IPadVideoPlaylistViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		if contentTableView == tableView { return 0 }
		if listVideoTableView == tableView { return videoPlaylistDataSource.numberOfSections() }
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if contentTableView == tableView {
			return 0
		}
		
		if listVideoTableView == tableView {
			return 0
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}

// MARK: - UITableViewDelegate
extension IPadVideoPlaylistViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if listVideoTableView == tableView {
			
		}
		tableView.deselectRow(at: indexPath, animated: false)
	}
}
