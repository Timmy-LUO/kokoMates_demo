//
//  FriendViewController.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/19.
//

import UIKit
import SnapKit

public final class FriendViewController: BaseViewController {
    
    private weak var viewModel: HomeViewModel!
    private let pageType: HomeViewModel.PageType!
    
    private lazy var viewControllers: [UIViewController] = [
        (pageType == .noFriends) ? TabNoFriendViewController() : TabFriendViewController(viewModel: viewModel),
        TabChatViewController()
    ]
    private var pageViewIndex: Int = 0
    
    public init(
        viewModel: HomeViewModel,
        pageType: HomeViewModel.PageType
    ) {
        self.viewModel = viewModel
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupPageViewController()
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.$userData
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.nameLabel.text = user.userName
                self?.kokoIdLabel.text = user.userId
            }
            .store(in: &cancellables)
        
        viewModel.$friendrequestList
            .sink { [weak self] list in
                self?.friendRequestTableView.setData(list)
            }
            .store(in: &cancellables)
        
        viewModel.$subTabList
            .sink { [weak self] list in
                guard let self = self else { return }
                self.tabCollectionView.setData(list)
                self.tabCollectionView.selectItem(
                    at: IndexPath(item: pageViewIndex, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
            }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .sink { [weak self] message in
                self?.promptAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        atmButton.setImage("ic_atm".image, for: .normal)
        atmButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        transferButton.setImage("ic_transfer".image, for: .normal)
        scanButton.setImage("ic_scan".image, for: .normal)
        
        kokoIdTitleLabel.text = "KOKO ID: "
        kokoIdIconImageView.image = "ic_info_back".image
        userPhotoImageView.image = "img_user_default".image
                
        tabCollectionView.tabCollectionViewDelegate = self
    }
    
    private func setupLayout() {
        safeEdgesView.addSubview(atmButton) { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview()
        }
        safeEdgesView.addSubview(transferButton) { make in
            make.centerY.equalTo(atmButton.snp.centerY)
            make.leading.equalTo(atmButton.snp.trailing).offset(20)
        }
        safeEdgesView.addSubview(scanButton) { make in
            make.centerY.equalTo(atmButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        infoContainerView.addSubview(nameLabel) { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        infoContainerView.addSubview(kokoIdTitleLabel) { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        infoContainerView.addSubview(kokoIdLabel) { make in
            make.centerY.equalTo(kokoIdTitleLabel.snp.centerY)
            make.leading.equalTo(kokoIdTitleLabel.snp.trailing).offset(8)
        }
        infoContainerView.addSubview(kokoIdIconImageView) { make in
            make.centerY.equalTo(kokoIdTitleLabel.snp.centerY)
            make.leading.equalTo(kokoIdLabel.snp.trailing)
        }
        infoContainerView.addSubview(notificationDot) { make in
            make.centerY.equalTo(kokoIdIconImageView.snp.centerY)
            make.leading.equalTo(kokoIdIconImageView.snp.trailing).offset(15)
        }
        infoContainerView.addSubview(userPhotoImageView) { make in
            make.width.height.equalTo(52)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        safeEdgesView.addSubview(infoContainerView) { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(atmButton.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        if pageType == .hasInvites {
            safeEdgesView.addSubview(friendRequestTableView) { make in
                make.height.equalTo(180)
                make.leading.equalToSuperview().offset(30)
                make.top.equalTo(infoContainerView.snp.bottom).offset(10)
                make.trailing.equalToSuperview().offset(-30)
            }
        }
        
        let lastView = safeEdgesView.subviews.last!
        safeEdgesView.addSubview(tabCollectionView) { make in
            make.height.equalTo(35)
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(lastView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-30)
        }
        safeEdgesView.addSubview(tabBgView) { make in
            make.leading.equalTo(tabCollectionView.snp.leading)
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.trailing.equalTo(tabCollectionView.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupPageViewController() {
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(tabBgView)
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewControllers[pageViewIndex]], direction: .forward, animated: true)
    }
    
    private func pageViewChange(index: Int) -> UIViewController? {
        if index < 0 {
            return viewControllers.last
        } else if index > (viewControllers.count - 1) {
            return viewControllers.first
        } else {
            return viewControllers[index]
        }
    }
    
    private let atmButton = UIButton()
    private let transferButton = UIButton()
    private let scanButton = UIButton()
    private let infoContainerView = UIView()
    private let nameLabel = UILabel()
    private let kokoIdTitleLabel = UILabel()
    private let kokoIdLabel = UILabel()
    private let kokoIdIconImageView = UIImageView()
    private let notificationDot = NotificationDot()
    private let userPhotoImageView = UIImageView()
    private let friendRequestTableView = FriendRequestTableView()
    private let tabCollectionView = TabCollectionView()
    private let tabBgView = UIView()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendViewController: TabCollectionViewDelegate {
    public func clickTab(onIndex: Int) {
        if onIndex > pageViewIndex {
            pageViewIndex = onIndex
            pageViewController.setViewControllers([viewControllers[pageViewIndex]], direction: .forward, animated: true)
        }
        
        if onIndex < pageViewIndex {
            pageViewIndex = onIndex
            pageViewController.setViewControllers([viewControllers[pageViewIndex]], direction: .reverse, animated: true)
        }
    }
}

// MARK: - PageVC Delegate
extension FriendViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllers[index - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[index + 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let visibleViewController = pageViewController.viewControllers?.first else { return }
        
        pageViewIndex = visibleViewController.view.tag
        tabCollectionView.selectItem(
            at: IndexPath(item: pageViewIndex, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
}

// MARK: - Tab Collection View
public protocol TabCollectionViewDelegate: AnyObject {
    func clickTab(onIndex: Int)
}

public final class TabCollectionView: UICollectionView {
    
    public weak var tabCollectionViewDelegate: TabCollectionViewDelegate?
    private var tabList = [SubTabUiModel]()
    
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 35)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 0)
        layout.scrollDirection = .vertical
        self.init(frame: .zero, collectionViewLayout: layout)
        register(TabCollectionViewCell.self, forCellWithReuseIdentifier: TabCollectionViewCell.identifier)
        dataSource = self
        delegate = self
    }
    
    public func setData(_ list: [SubTabUiModel]) {
        tabList = list
        reloadData()
    }
}

// MARK: - Collection Delegate
extension TabCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.identifier, for: indexPath) as! TabCollectionViewCell
        cell.bind(tabList[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabCollectionViewDelegate?.clickTab(onIndex: indexPath.row)
    }
}

// MARK: - Tab Collection View Cell
public final class TabCollectionViewCell: UICollectionViewCell {
    
    override public var isSelected: Bool {
        didSet { setCurrentView() }
    }
    
    public static let identifier = "TabCollectionViewCell"
    
    public func bind(_ item: SubTabUiModel) {
        titleLabel.text = item.title
        badgeView.count = item.badgeCount
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = .boldSystemFont(ofSize: 13)
        titleLabel.textColor = "greyish_brown".color
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel) { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        contentView.addSubview(badgeView) { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(titleLabel.snp.top).offset(9)
        }
        contentView.addSubview(currentView) { make in
            make.height.equalTo(3)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setCurrentView() {
        UIView.animate(withDuration: 0.3) {
            self.currentView.backgroundColor = self.isSelected ? "hot_pink".color : UIColor.clear
            self.layoutIfNeeded()
        }
    }
    
    private let titleLabel = UILabel()
    private let badgeView = BadgeView()
    private let currentView = UIView()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//public final class TabSwitchingContainer: UIView {
//
//    private var collectionView = UICollectionView()
//    private let bgView = UIView()
//    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//
//    private var tabList: [String]!
//    private var viewControllerList: [UIViewController]!
//    private var pageViewIndex: Int = 0
//
//    public convenience init(
//        tabList: [String],
//        viewControllerList: [UIViewController]
//    ) {
//        self.init(frame: .zero)
//        self.tabList = tabList
//        self.viewControllerList = viewControllerList
//        setupLayout()
//        setupCollectionView()
//        setupPageViewController()
//    }
//
//    private func setupLayout() {
//        addSubview(collectionView) { make in
//            make.height.equalTo(50)
//            make.leading.top.trailing.equalToSuperview()
//        }
//        addSubview(bgView) { make in
//            make.top.equalTo(collectionView.snp.bottom)
//            make.bottom.leading.trailing.equalToSuperview()
//        }
//    }
//
//    private func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 100, height: 50)
//        layout.minimumLineSpacing = 0
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: TabCollectionViewCell.identifier)
//        collectionView.backgroundColor = .white
//    }
//
//    private func setupPageViewController() {
//        addSubview(pageViewController.view)
////        addChild(pageViewController)
//        pageViewController.didMove(toParent: self)
//
//        pageViewController.view.snp.makeConstraints { make in
//            make.edges.equalTo(bgView)
//        }
//
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//        pageViewController.setViewControllers([viewControllerList[pageViewIndex]], direction: .forward, animated: true)
//    }
//
//    private func pageViewChange(index: Int) -> UIViewController? {
//        if index < 0 {
//            return viewControllerList.last
//        } else if index > viewControllerList.count - 1 {
//            return viewControllerList.first
//        } else {
//            return viewControllerList[index]
//        }
//    }
//}
