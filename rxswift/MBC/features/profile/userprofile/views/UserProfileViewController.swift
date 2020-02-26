//
//  UserProfileViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    private var userProfileCell: UserProfileCell?
    private var userProfileGenderCell: UserProfileGenderCell?
    private var userProfileAddressCell: UserProfileAddressCell?
    
    private var selectedTab: TabUserProfileSelection = TabUserProfileSelection.profile
    private var viewModel = UserProfileViewModel(interactor: Components.userProfileInteractor())
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(UserProfileViewController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        bindEvents()
        self.viewModel.getCountryList()
        self.viewModel.getNationalityList()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.editStatusDisable()
    }
    
    private func setupUI() {
        self.addBackButton()
        addRefreshControl()
        title = R.string.localizable.userProfileTitle()
        
        tableView.register(R.nib.userProfileCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.userProfileCellId.identifier)
        tableView.register(R.nib.profileHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.profileHeaderCellId.identifier)
        tableView.register(R.nib.userProfileGenderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.userProfileGenderCellId.identifier)
        tableView.register(R.nib.userProfileAddressCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.userProfileAddressCellId.identifier)
        tableView.register(R.nib.userProfileChangePasswordCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.userProfileChangePasswordCellId.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    private func addRefreshControl() {
        if refreshControl.superview == nil {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc
    private func refreshData(_ refreshControl: UIRefreshControl) {
        refreshData()
    }
    
    private func refreshData() {
        viewModel.refreshAccountInfo()
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        let viewTapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(viewTapGesture)
        
        disposeBag.addDisposables([
            viewTapGesture.rx.event.bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            }),
            
            viewModel.onWillStartGetCityList.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),
            
            viewModel.onWillStopGetCityList.subscribe(onNext: { [unowned self] _ in
                self.hideLoading(showInView: nil)
            }),
            
            viewModel.onWillStartUpdateAccountInfo.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),
            
            viewModel.onWillStopUpdateAccountInfo.subscribe(onNext: { [unowned self] _ in
                self.hideLoading(showInView: nil)
            }),
            
            viewModel.onWillStartUpdateUserAvatar.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),
            
            viewModel.onWillStopUpdateUserAvatar.subscribe(onNext: { [unowned self] _ in
                self.hideLoading(showInView: nil)
            }),
            
            viewModel.onWillStopRefreshAccountInfo.subscribe(onNext: { [unowned self] _ in
                self.refreshControl.endRefreshing()
            }),
            
            viewModel.onDidGetNationalityList.subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }),
            
            viewModel.onDidGetCountryList.subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }),
            
            viewModel.onDidGetCityList.subscribe(onNext: { [unowned self] _ in
                if let cell = self.userProfileAddressCell {
                    cell.bindData(item: cell.profileItem, user: self.viewModel.user,
                                  arrayCountry: self.viewModel.arrayCountry,
                                  arrayCity: self.viewModel.arrayCity)
                }
            }),
            
            viewModel.onDidUpdateAccountInfo.subscribe(onNext: { [unowned self] _ in
                print("Updated account info")
                self.tableView.reloadData()
            }),
            
            viewModel.onDidUpdateUserAvatar.subscribe(onNext: { [unowned self] _ in
                print("Updated user avatar")
                self.tableView.reloadData()
            }),
            
            viewModel.onDidRefreshAccountInfo.subscribe(onNext: { [unowned self] _ in
                print("Refreshed account info")
                self.tableView.reloadData()
            }),
            
            viewModel.onShowError.subscribe(onNext: { [unowned self] error in
                if let text = error.errorString(), !text.isEmpty {
                    self.showMessage(message: self.getErrorMessage(errorMessage: text))
                    self.tableView.reloadData()
                }
            })
        ])
    }
    
    // MARK: - Overwrite methods
    
    override func imagePicker(didSelect image: UIImage) {
        self.viewModel.updateUserAvatar(image: image)
    }
    
    // MARK: - Private methods
    
    private func getErrorMessage(errorMessage: String) -> String {
        var errorMessage = errorMessage
        
        guard let type = self.viewModel.type else { return errorMessage }
        switch type {
        case .password:
            if errorMessage == R.string.localizable.errorInvalidLoginID() {
                errorMessage = R.string.localizable.errorWrongOldPassword()
            } else if errorMessage == R.string.localizable.errorInvalidParameterValue() {
                errorMessage = R.string.localizable.errorNewPassIsTheSameWithOldPass()
            }
        default:
            break
        }
        
        return errorMessage
    }
    
    private func profileHeaderCell() -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.profileHeaderCellId.identifier) as? ProfileHeaderCell {
            cell.bindData(user: viewModel.user, selectedTab: selectedTab)
            cell.disposeBag.addDisposables([
                cell.onProfileButtonClicked.subscribe(onNext: { [unowned self] _ in
                    self.selectedTab = TabUserProfileSelection.profile
                    self.tableView.reloadData()
                }),
                cell.onSettingButtonClicked.subscribe(onNext: { [unowned self] _ in
                    self.selectedTab = TabUserProfileSelection.setting
                    self.tableView.reloadData()
                }),
                cell.onActivityButtonClicked.subscribe(onNext: { [unowned self] _ in
                    self.selectedTab = TabUserProfileSelection.activityLog
                    self.tableView.reloadData()
                }),
                cell.onAvatarButtonClicked.subscribe(onNext: { [unowned self] _ in
                    self.openActionSheet()
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    private func userProfileCell(item: ProfileItem) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.userProfileCellId.identifier) as? UserProfileCell {
            cell.bindData(item: item, user: viewModel.user, arrayNationality: viewModel.arrayNationality)
            cell.disposeBag.addDisposables([
                cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] countryCodeTuple in
                    print("\(countryCodeTuple.text) - \(countryCodeTuple.value)")
                    if item.type == .nationality {
                        self.viewModel.user?.nationality = countryCodeTuple.value
                    } else if item.type == .marriedStatus {
                        self.viewModel.user?.marriedStatus = countryCodeTuple.value
                    } else if item.type == .phoneNumber {
                        self.viewModel.user?.phoneNumber = countryCodeTuple.text
                    } else if item.type == .marriedStatus {
                        self.viewModel.user?.marriedStatus = countryCodeTuple.value
                    } else if item.type == .fullName {
                        self.viewModel.user?.name = countryCodeTuple.text
                    } else if item.type == .email {
                        self.viewModel.user?.email = countryCodeTuple.text
                    } else if item.type == .birthday {
                        self.viewModel.user?.birthday =
                            Date.dateFromString(string: countryCodeTuple.text,
                                                format: Constants.DateFormater.DateMonthYear)
                    }
                    self.viewModel.updateAccountInfo(type: item.type)
                    self.tableView.reloadData()
                }),
                cell.onNeedReloadCell.subscribe(onNext: { _ in
                    self.tableView.reloadData()
                }),
                cell.onEditButtonClicked.subscribe(onNext: { _ in
                    cell.bindData(item: item, user: self.viewModel.user,
                                  arrayNationality: self.viewModel.arrayNationality)
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    private func userProfileGenderCell(item: ProfileGenderItem) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.userProfileGenderCellId.identifier) as? UserProfileGenderCell {
            cell.bindData(item: item, user: viewModel.user)
            cell.disposeBag.addDisposables([
                cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] value in
                    print(value.rawValue)
                    self.viewModel.user?.gender = value
                    self.viewModel.updateAccountInfo(type: item.type)
                    self.tableView.reloadData()
                }),
                cell.onNeedReloadCell.subscribe(onNext: { _ in
                    self.tableView.reloadData()
                }),
                cell.onEditButtonClicked.subscribe(onNext: { [unowned self] cell in
                    self.userProfileGenderCell = cell
                    cell.bindData(item: item, user: self.viewModel.user)
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    private func userProfileAddressCell(item: ProfileAddressItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.userProfileAddressCellId.identifier) as? UserProfileAddressCell {
            cell.bindData(item: item, user: viewModel.user, arrayCountry: viewModel.arrayCountry,
                          arrayCity: viewModel.arrayCity)
            cell.disposeBag.addDisposables([
                cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] valueTuple in
                    print("Addr: \(valueTuple.strAddress) - City code: \(valueTuple.cityCode) - City name: " +
                        "\(valueTuple.cityName) - Country code: \(valueTuple.countryCode) - Country name: " +
                        "\(valueTuple.countryName)")
                    self.viewModel.user?.address = valueTuple.strAddress
                    self.viewModel.user?.city = valueTuple.cityCode
                    self.viewModel.user?.country = valueTuple.countryCode
                    self.viewModel.updateAccountInfo(type: item.type)
                    self.tableView.reloadData()
                }),
                cell.onNeedReloadCell.subscribe(onNext: { _ in
                    self.tableView.reloadData()
                }),
                cell.onEditButtonClicked.subscribe(onNext: { [unowned self] in
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }),
                cell.onDidSelectCoutry.subscribe(onNext: { [unowned self] valueTuple in
                    self.userProfileAddressCell = valueTuple.cell
                    self.viewModel.user?.city = ""
                    self.viewModel.removeArrayCityList()
                    self.viewModel.getCityList(countryCode: valueTuple.countryCode)
                }),
                cell.onShouldBeginSelectingCity.subscribe(onNext: { [unowned self] valueTuple in
                    self.userProfileAddressCell = valueTuple.cell
                    if self.viewModel.arrayCity.isEmpty {
                        self.viewModel.getCityList(countryCode: valueTuple.countryCode)
                    } else {
                        cell.bindData(item: item, user: self.viewModel.user,
                                      arrayCountry: self.viewModel.arrayCountry,
                                      arrayCity: self.viewModel.arrayCity)
                    }
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    private func userProfileChangePasswordCell(item: ProfilePasswordItem) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.userProfileChangePasswordCellId.identifier) as? UserProfileChangePasswordCell {
            cell.bindData(item: item)
            cell.disposeBag.addDisposables([
                cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] valueTuple in
                    print("Old pass: \(valueTuple.oldPassword) - New Pass: \(valueTuple.newPassword)")
                    self.viewModel.user?.oldPassword = valueTuple.oldPassword
                    self.viewModel.user?.newPassword = valueTuple.newPassword
                    self.viewModel.updateAccountInfo(type: item.type)
                    self.tableView.reloadData()
                }),
                cell.onNeedReloadCell.subscribe(onNext: { [unowned self] in
                    self.tableView.reloadData()
                }),
                cell.onEditButtonClicked.subscribe({ [unowned self] _ in
                    self.tableView.reloadData()
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
}

public enum TabUserProfileSelection: Int {
    case profile = 0
    case setting = 1
    case activityLog = 2
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == TabUserProfileSelection.profile { return viewModel.totalProfileItems }
        if selectedTab == TabUserProfileSelection.setting { return 0 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return profileHeaderCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 155.0 //222.0 when we need to show Tab bar.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedTab == TabUserProfileSelection.profile {
            if let item = viewModel.profileItemAt(index: indexPath.row) as? ProfileItem {
                return self.userProfileCell(item: item)
            }
            if let item = viewModel.profileItemAt(index: indexPath.row) as? ProfileGenderItem {
                return self.userProfileGenderCell(item: item)
            }
            if let item = viewModel.profileItemAt(index: indexPath.row) as? ProfileAddressItem {
                return self.userProfileAddressCell(item: item, indexPath: indexPath)
            }
            if let item = viewModel.profileItemAt(index: indexPath.row) as? ProfilePasswordItem {
                return self.userProfileChangePasswordCell(item: item)
            }
        }
        
        if selectedTab == TabUserProfileSelection.setting {
            
        }
        
        if selectedTab == TabUserProfileSelection.activityLog {
            
        }
        return UITableViewCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
}
