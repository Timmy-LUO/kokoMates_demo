//
//  TabFriendViewController.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/25.
//

import UIKit
import SnapKit

public final class TabFriendViewController: BaseViewController {
    
    private weak var viewModel: HomeViewModel!
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .compactMap { ($0.object as? UITextField)?.text } // 提取输入内容
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // 防抖，减少频繁触发
            .removeDuplicates()
            .sink { [weak self] query in
                self?.viewModel.onKeyword.send(query)
            }
            .store(in: &cancellables)
        
        viewModel.$friendList
            .sink { [weak self] list in
                self?.friendTableView.setData(list)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.tag = 0
        
        searchInputView.backgroundColor = "steel_light_grey".color
        searchInputView.layer.cornerRadius = 10
        searchIconImageView.image = "ic_search".image
        searchTextField.placeholder = "想轉一筆給誰呢？"
        searchTextField.font = .systemFont(ofSize: 14)
        searchTextField.textColor = "steel_grey".color
        addFriendButton.setImage("ic_add_friends".image, for: .normal)
    }
    
    private func setupLayout() {
        view.addSubview(addFriendButton) { make in
            make.size.equalTo(25)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview()
        }
        view.addSubview(searchInputView) { make in
            make.centerY.equalTo(addFriendButton.snp.centerY)
            make.leading.equalToSuperview()
            make.trailing.equalTo(addFriendButton.snp.leading).offset(-15)
        }
        searchInputView.addSubview(searchIconImageView) { make in
            make.size.equalTo(15)
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        searchInputView.addSubview(searchTextField) { make in
            make.centerY.equalTo(searchIconImageView.snp.centerY)
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        view.addSubview(friendTableView) { make in
            make.leading.equalToSuperview()
            make.top.equalTo(searchInputView.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private let searchInputView = UIView()
    private let searchIconImageView = UIImageView()
    private let searchTextField = UITextField()
    private let addFriendButton = UIButton()
    private let friendTableView = TabFriendTableView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
