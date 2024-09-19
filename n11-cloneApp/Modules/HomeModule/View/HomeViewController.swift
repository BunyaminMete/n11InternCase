// MARK: - HomeViewController

import UIKit
import Lottie
import FirebaseAuth

enum HeaderType {
    case productCard
    case conceptArea
    case none
}

protocol UserAuthenticationProtocol: AnyObject {
    func userDismissedAuthenticaionScreen()
}

final class HomeViewController: UIViewController {

    var homeCollectionView: UICollectionView!
    var dataSource: HomeCollectionViewDataSource!
    var presenter: HomePresenter!
    var userExist: Bool {
        return Auth.auth().currentUser != nil
    }

    private lazy var refreshControl  = UIRefreshControl()
    private var customNavBar: CustomNavigationBar2!
    private var customLabel: SubLabelProgrammaticCollectionViewCell!

    private var visitedConceptAreaSections: [Int] = []
    private var conceptAreaImages: [UIImage] = []
    private var selectedImageFrame: CGRect?
    private var currentIndex: Int = 0
    private var showTabBarTimer: Timer?

    private var loadingLottie: LottieAnimationView?
    var navigationDelegate = CustomNavigationControllerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.delegate = navigationDelegate
        buildLottieForHomeVC()
        setNavigationControllerUI()
        buildCollectionView()
        buildLottieForHomeVC()
        loadingLottie?.play()
        setCompositionalLayout()

        presenter.requestAPI { [weak self] in
            print("API request completed and UI updated.")
            self?.loadingLottie?.stop()
        }
        presenter.didViewCalledPresenterToGetImages()
    }

    // MARK: --REFRESH EVENT

    @objc private func handleRefreshEvent() {
        presenter.stopSlider()
        loadingLottie!.play()

        presenter.requestAPI { [weak self] in
            self?.presenter.didViewCalledPresenterToGetImages()
            self?.loadingLottie?.stop()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupCustomNavBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customNavBar.removeFromSuperview()
        customLabel.removeFromSuperview()
    }

    private func buildLottieForHomeVC(){
        let lottieSize: Float = 80
        loadingLottie = .init(name: "loadingIcon")
        loadingLottie?.frame = CGRect(x: view.bounds.width / 2 - (CGFloat(lottieSize) / 2),
                                      y: view.bounds.height / 2 ,
                                      width: CGFloat(lottieSize),
                                      height: CGFloat(lottieSize))

        loadingLottie?.contentMode = .scaleAspectFit
        loadingLottie?.animationSpeed = 0.5
        loadingLottie?.loopMode = .loop
        view.addSubview(loadingLottie!)
    }

    private func setupCustomNavBar() {
        customNavBar?.removeFromSuperview()
        customLabel?.removeFromSuperview()

        customNavBar = CustomNavigationBar2()
        customNavBar.backgroundColor = .purple11
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBar)
        view.backgroundColor = .purple11

        customLabel = SubLabelProgrammaticCollectionViewCell(frame: .zero)
        customLabel.delegate = self
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.backgroundColor = .white
        view.addSubview(customLabel)

        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customNavBar.heightAnchor.constraint(equalToConstant: 80),

            customLabel.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            customLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customLabel.bottomAnchor.constraint(equalTo: homeCollectionView.topAnchor)
        ])
    }

    private func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        homeCollectionView.backgroundColor = .white
        homeCollectionView.delegate = self

        refreshControl.addTarget(self, action: #selector(handleRefreshEvent), for: .valueChanged)
        homeCollectionView.refreshControl = refreshControl

        view.addSubview(homeCollectionView)
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                    constant: 120),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setCompositionalLayout() {

        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionType = self.presenter.getSectionType(for: sectionIndex)

            return HomeModuleCollectionLayoutMaker.sharedInstance.layoutSection(for: sectionType)
        }

        layout.register(ShortcutSectionBgView.self, forDecorationViewOfKind: "shortcutBackground")
        layout.register(ProductSectionWithCounterBgView.self, forDecorationViewOfKind: "productCounterBackground")

        layout.register(ConceptEx1.self, forDecorationViewOfKind: "conceptBackgroundEx1")
        layout.register(ConceptEx2.self, forDecorationViewOfKind: "conceptBackgroundEx2")
        layout.register(ConceptEx3.self, forDecorationViewOfKind: "conceptBackgroundEx3")
        layout.register(ConceptEx4.self, forDecorationViewOfKind: "conceptBackgroundEx4")
        layout.register(ConceptEx5.self, forDecorationViewOfKind: "conceptBackgroundEx5")

        homeCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
    }
}

extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hidden: true, animated: true)
        } else {
            changeTabBar(hidden: false, animated: true)
        }

        if contentOffsetY + scrollViewHeight >= contentHeight - 50 {
            changeTabBar(hidden: false, animated: true)
        }

        // Eğer zamanlayıcı varsa, iptal et
        showTabBarTimer?.invalidate()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startShowTabBarTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startShowTabBarTimer()
        }
    }

    private func startShowTabBarTimer() {
        showTabBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showTabBar), userInfo: nil, repeats: false)
    }

    @objc private func showTabBar() {
        changeTabBar(hidden: false, animated: true)
    }

    func changeTabBar(hidden: Bool, animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        let offset = hidden ? UIScreen.main.bounds.size.height
        : UIScreen.main.bounds.size.height - tabBar.frame.size.height

        if offset == tabBar.frame.origin.y { return }
        let duration: TimeInterval = animated ? 0.5 : 0.0

        UIView.animate(withDuration: duration, animations: {
            tabBar.frame.origin.y = offset
        }, completion: nil)
    }
}

extension HomeViewController {
    func setNavigationControllerUI(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationController.self])
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -20
                                                                          ,vertical: 0)
                                                                 ,for: .default)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18,
                                                      weight: .semibold)

        let arrowImage = UIImage(systemName: "chevron.left",
                                 withConfiguration: imageConfig)?
            .withTintColor(.darkGray, renderingMode: .alwaysOriginal)

        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.backIndicatorImage = arrowImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = arrowImage
    }
}

extension HomeViewController {
    func scrollToTop() {
        homeCollectionView.setContentOffset(.zero, animated: true)
    }
}

extension HomeViewController: SubLabelProgrammaticCollectionViewCellDelegate {
    func didTapCreateOrRegister() {
        if userExist {
            print("This feature is not available right now.")
        } else {
            let authViewController = FormViewController()
            authViewController.delegate = self
            present(authViewController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: UserAuthenticationProtocol {
    func userDismissedAuthenticaionScreen() {
        setupCustomNavBar()
    }
}

extension HomeViewController: HomeViewProtocol {
    func scrollToItem(at index: Int) {
        guard let sectionIndex = presenter.indexOfSliderSection() else {
            print("Slider section not found")
            return
        }
        var indexPath = IndexPath(item: index, section: sectionIndex)
        let visibleIndexPaths = homeCollectionView.indexPathsForVisibleItems.filter { $0.section == sectionIndex }
        guard let firstVisibleIndexPath = visibleIndexPaths.first else { return }
        var currentIndex = firstVisibleIndexPath.item

        currentIndex = (currentIndex < 4) ? (currentIndex + 1) : 0
        indexPath[1] = currentIndex

        homeCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func displayImages(_ images: [UIImage]) {
        self.conceptAreaImages = images
    }

    func numberOfItemsInSliderSection() -> Int {
        guard let sectionIndex = presenter.indexOfSliderSection() else {
            return 0
        }
        return homeCollectionView.numberOfItems(inSection: sectionIndex)
    }

    func configureDataSource() {
        dataSource = HomeCollectionViewDataSource(collectionView: homeCollectionView)
        homeCollectionView.dataSource = dataSource

        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }

            guard kind == UICollectionView.elementKindSectionHeader else {
                fatalError("Unexpected element kind")
            }

            let headerType = self.presenter.headerTypeForSection(indexPath.section)
            guard let headerIdentifier = self.presenter.headerIdentifier(for: headerType) else {
                return nil
            }

            switch headerType {
            case .productCard:
                let headerView = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: headerIdentifier,
                                                      for: indexPath) as! HomeModuleProductCardHeaderReusableView
                return headerView

            case .conceptArea:
                let headerView = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: headerIdentifier,
                                                      for: indexPath) as! HomeModuleConceptImageHeaderReusableView

                let sectionIndex = indexPath.section

                let visitedConceptAreas = self.visitedConceptAreaSections
                if let sectionPosition = visitedConceptAreas.firstIndex(of: sectionIndex) {
                    //
                    let conceptImageIndex = sectionPosition % self.conceptAreaImages.count
                    //
                    let conceptImage = self.conceptAreaImages[conceptImageIndex]
                    headerView.configure(with: conceptImage)
                } else {
                    self.visitedConceptAreaSections.append(sectionIndex)
                    if !self.conceptAreaImages.isEmpty {
                        let conceptImageIndex = (self.visitedConceptAreaSections.count - 1) % self.conceptAreaImages.count
                        let conceptImage = self.conceptAreaImages[conceptImageIndex]
                        headerView.configure(with: conceptImage)
                    } else {
                        print("No Concept Images Available")
                    }
                }
                return headerView
            case .none:
                return nil
            }
        }
    }
    
    func endRefreshEvent() {
        homeCollectionView.refreshControl?.endRefreshing()
    }

    func showProductDetail(product: HomeModuleProductCardPresentationModel)
    {
        let pdpModule = PDPBuilder.createModule()

        guard let selectedIndexPath = homeCollectionView
            .indexPathsForSelectedItems?.first,
              let selectedCell = homeCollectionView
            .cellForItem(at: selectedIndexPath) as? HomeModuleProductCardCell else
        {
            print("No selected cell found.")
            return
        }

        let calculateYAxisDistance = view.safeAreaInsets.top

        let targetFrame = CGRect(x: 0, y: calculateYAxisDistance, width: view.bounds.width, height: view.bounds.width * 1.36)
        let originFrame = selectedCell.productCardImageView.convert(selectedCell.productCardImageView.bounds,to: view)

        navigationDelegate.image = selectedCell.productCardImageView.image
        navigationDelegate.originFrame = originFrame
        navigationDelegate.targetFrame = targetFrame
        navigationDelegate.isBasket = false

        navigationController?.delegate = navigationDelegate

        if let productDetailVC = pdpModule as? ProductDetailViewController
        {
            productDetailVC.product = product
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
        else
        {
            print("Casting module PDP failed.")
        }
    }

    func sendCurrentDataSource() -> HomeScreenDataSource? {
        return self.dataSource
    }

}

