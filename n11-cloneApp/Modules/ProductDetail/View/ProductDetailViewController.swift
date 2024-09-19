import UIKit
import FirebaseAuth

class ProductDetailViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, ProductDetailPageProtocol{
    private var dataSource: UICollectionViewDiffableDataSource<
        Int, String
    >!

    private var footerView: ProductDetailFooterView?
    var presenter: ProductDetailPresenterProtocol?

    var productDetailCollectionView: UICollectionView!
    var product: HomeModuleProductCardPresentationModel?
    let firestoreManager = FirestoreNetworking()
    
    var fetchedProductFavouriteStatus: Bool = false
    let bottomView = BottomView()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        fetchFavouriteStatus()
        setupView()
        setCompositionalLayout()
        configureDataSource()
        setProduct()
        updateData()
    }

    private func setupView() {
        view.backgroundColor = .white
        setupBottomView()
        buildCollectionView()
        setupBackToRootButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func updateFavouriteStatus() {
        fetchedProductFavouriteStatus = false
    }

    func setProduct() {
        presenter?.setProductAtPresenter(product: self.product!)
    }

    func enableButtonAndPushToBasket() {
        self.bottomView.basketButton.isEnabled = true
        (self.navigationController?.delegate as? CustomNavigationControllerDelegate)?.isBasket = true
        let basketModule = BasketModuleBuilder.createModule()

        if let basketVC = basketModule as? BasketViewController
        {
            self.navigationController?.pushViewController(basketVC, animated: true)
        }
    }

    func forceGuestUserToAuthScreen() {
        let formVC = FormViewController()

        bottomView.basketButton.imageView?.alpha = 1
        bottomView.basketButton.isEnabled = true

        tabBarController?.selectedIndex = 4
        present(formVC, animated: true)
    }

    func favouriteStatusUpdate(with status: [String : Bool]?) {
        guard let status = status, let product = product else { return }

        self.fetchedProductFavouriteStatus = status[product.productTitle] ?? false
        self.updateActionButtons(statusDict: status)
        self.setupNavigationItems()

    }

    func fetchFavouriteStatus() {
        presenter?.requestForFavouriteStatusInformation()
    }

    @objc func rightButtonTapped() {
        self.bottomView.basketButton.imageView?.alpha = 0.4
        self.bottomView.basketButton.isEnabled = false
        presenter?.addProductToBasket()
    }

    private func buildCollectionView() {
        productDetailCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout())
        productDetailCollectionView.backgroundColor = .white

        productDetailCollectionView.registerClass(ProductDetailImageCollectionViewCell.self)
        productDetailCollectionView.registerNib(cellClass: HomeModuleProductCardCell.self)
        productDetailCollectionView.registerNib(cellClass: ProductDetailMiniFeaturesCollectionViewCell.self)

        productDetailCollectionView.register(ProductDetailFooterView.self,
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                             withReuseIdentifier: ProductDetailFooterView.reuseIdentifier)

        productDetailCollectionView.delegate = self  // Delegate ayarını yapın

        view.addSubview(productDetailCollectionView)
        productDetailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productDetailCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productDetailCollectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }

    // MARK: -- Layout Configuration --
    private func setCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.layoutSection(for: sectionIndex)
        }
        productDetailCollectionView.setCollectionViewLayout(layout, animated: true)
    }

    private func layoutSection(for section: Int) -> NSCollectionLayoutSection {
        let layoutManager = CompositionalLayoutProductDetailManager()
        let sectionLayout: NSCollectionLayoutSection

        switch section {
        case 0:
            sectionLayout = layoutManager.createTopProductImageLayout()
            sectionLayout.visibleItemsInvalidationHandler = { [weak self] items, point, environment in
                guard let self = self else { return }
                let width = environment.container.contentSize.width
                let scrollOffset = point.x
                let modulo = scrollOffset.truncatingRemainder(dividingBy: width)
                let tolerance = width / 5
                if modulo < tolerance {
                    let currentPage = Int(scrollOffset / width)
                    self.footerView?.pageControl.currentPage = currentPage

                    let totalItems = self.dataSource.snapshot().numberOfItems(inSection: 0)
                    let lastPage = totalItems - 1

                    if currentPage == lastPage {
                        // Set offset to start
                        let indexPath = IndexPath(item: 0, section: 0)
                        self.productDetailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    }
                }
            }
        case 1:
            sectionLayout = layoutManager.createMiniProductFeaturesViewLayout()
        case 2:
            sectionLayout = layoutManager.createProductSlider()
        default:
            fatalError("Unhandled section type")
        }
        return sectionLayout
    }

    //MARK: -- Data Source Configuration --
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let fullScreenVC = FullScreenImageViewController()

            var images: [UIImage] = []
            let dispatchGroup = DispatchGroup()

            for imageName in product?.productImages ?? [] {
                dispatchGroup.enter()
                downloadImage(with: imageName) { image in
                    if let image = image {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                let getCurrentPage = self.footerView?.pageControl.currentPage
                fullScreenVC.images = images
                fullScreenVC.initialIndexPath = [0, getCurrentPage ?? 0]
                fullScreenVC.modalPresentationStyle = .fullScreen
                self.present(fullScreenVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: -- Data Source Configuration --
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<
            Int, String
        >(collectionView: productDetailCollectionView)
        { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0:
                guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: ProductDetailImageCollectionViewCell.reuseIdentifier,
                                         for: indexPath) as? ProductDetailImageCollectionViewCell
                else { return nil }
                cell.configureImageCell(with: item)
                return cell
            case 1:
                guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: ProductDetailMiniFeaturesCollectionViewCell.reuseIdentifier,
                                         for: indexPath) as? ProductDetailMiniFeaturesCollectionViewCell
                else { return nil }

                let isStarExist = self.product!.productRate ? true : false
                cell.configureMiniFeaturesCell(with: item, withStar: isStarExist)
                return cell

            default:
                return nil
            }
        }

        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }

            if kind == UICollectionView.elementKindSectionFooter {
                guard let footerView = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: ProductDetailFooterView.reuseIdentifier,
                                                      for: indexPath) as? ProductDetailFooterView else { return nil }
                self.configureFooterView(footerView)
                return footerView
            }
            return nil
        }
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0, 1, 2])

        if let images = product?.productImages, !images.isEmpty {
            var uniqueImages = images
            uniqueImages.append("")
            //son resimden ilk resme dönmek için boş bir url ekledim.
            snapshot.appendItems(uniqueImages, toSection: 0)
        }

        if let title = product?.productTitle, !title.isEmpty {
            snapshot.appendItems([title], toSection: 1)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureFooterView(_ footerView: ProductDetailFooterView) {
        footerView.pageControl.numberOfPages = self.product?.productImages.count ?? 0
        self.footerView = footerView
    }

    private func setupBottomView() {
        if let price = product?.productPrice {
            bottomView.bottomLabel.text = formattedPrice(from: price)
        } else {
            bottomView.bottomLabel.text = ""
        }
        bottomView.basketButton.addTarget(self, action: #selector(rightButtonTapped),
                                          for: .touchUpInside)


        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 140),
        ])
    }

    // MARK: -- BackToRootButton

    let backToRootButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let arrowImage = UIImage(systemName: "arrow.backward",
                                 withConfiguration: imageConfig)?.withTintColor(.darkGray,
                                                                                renderingMode: .alwaysOriginal)

        button.setImage(arrowImage, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(1)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false

        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.7
        button.layer.masksToBounds = false
        button.isHidden = false

        return button
    }()

    private func setupBackToRootButton() {
        view.addSubview(backToRootButton)
        NSLayoutConstraint.activate([
            backToRootButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backToRootButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backToRootButton.widthAnchor.constraint(equalToConstant: 40),
            backToRootButton.heightAnchor.constraint(equalToConstant: 40),
        ])

        backToRootButton.addTarget(self, action: #selector(returnToRoot), for: .touchUpInside)
    }

    // MARK: -- ActionButtons
    private var actionButtons: [UIButton] = []
    private func createActionButton(systemName: String, action: Selector, tintColor: UIColor = .systemGray) -> UIButton {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let image = UIImage(systemName: systemName,
                            withConfiguration: imageConfig)?.withTintColor(tintColor,
                                                                           renderingMode: .alwaysOriginal)

        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(1)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false

        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.7
        button.layer.masksToBounds = false

        button.addTarget(self, action: action, for: .touchUpInside)
        button.isHidden = false

        return button
    }

    var actionButtonsInfo: [(systemName: String, action: Selector)] = [
        ("heart", #selector(clickToFavouriteProduct)),
        ("list.bullet", #selector(listTapped)),
        ("square.and.arrow.up", #selector(shareTapped)),
        ("cart", #selector(shoppingTapped))
    ]


    private func updateActionButtons(statusDict: [String: Bool]) {
        for (index, info) in self.actionButtonsInfo.enumerated() {
            var systemName = info.systemName
            var action = info.action

            guard let product = product else { return }

            if info.systemName == "heart" {
                let isFavourite = statusDict[product.productTitle] ?? false
                systemName = isFavourite ? "heart.fill" : "heart"
                action = isFavourite ? #selector(self.removeFromFavourites) : #selector(self.clickToFavouriteProduct)
            }

            var button = self.createActionButton(systemName: systemName, action: action)

            if systemName == "heart.fill"
            {
                button = self.createActionButton(systemName: systemName, action: action, tintColor: .purple11)
            }

            self.view.addSubview(button)
            self.actionButtons.append(button)
            button.tag = index + 1

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            button.isHidden = backToRootButton.isHidden

            if index == 0 {
                button.topAnchor.constraint(equalTo: self.backToRootButton.topAnchor, constant: 0).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: self.actionButtons[index - 1].bottomAnchor, constant: 15).isActive = true
            }
        }
    }

    func updateHeartButton() {
        guard let heartButton = actionButtons.first else { return }

        let imageName = fetchedProductFavouriteStatus ? "heart.fill" : "heart"
        let imageTintColor: UIColor = fetchedProductFavouriteStatus ? .purple11 : .systemGray
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)?.withTintColor(imageTintColor, renderingMode: .alwaysOriginal)

        heartButton.setImage(image, for: .normal)
        heartButton.removeTarget(nil, action: nil, for: .allEvents)
        let newAction: Selector = fetchedProductFavouriteStatus ? #selector(removeFromFavourites) : #selector(clickToFavouriteProduct)
        heartButton.addTarget(self, action: newAction, for: .touchUpInside)
    }

    // MARK: --Navigation Item Customization
    func createBarButtonItem(systemName: String, action: Selector, tintColor: UIColor) -> UIBarButtonItem {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: systemName,
                            withConfiguration: imageConfig)?.withTintColor(tintColor,
                                                                           renderingMode: .alwaysOriginal)

        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)

        return UIBarButtonItem(customView: button)
    }

    var shoppingBarButton = UIBarButtonItem()
    var shareBarButton = UIBarButtonItem()
    var listBarButton = UIBarButtonItem()
    var heartBarButton = UIBarButtonItem()

    let fixedSpace: CGFloat = 8
    let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)

    //protocol func
    func setupNavigationItems() {
        if fetchedProductFavouriteStatus
        {
            shoppingBarButton = createBarButtonItem(systemName: "heart.fill", action: #selector(removeFromFavourites), tintColor: .purple11)
        }
        else
        {
            shoppingBarButton = createBarButtonItem(systemName: "heart", action: #selector(clickToFavouriteProduct), tintColor: .systemGray)
        }

        shareBarButton = createBarButtonItem(systemName: "list.bullet", action: #selector(listTapped), tintColor: .systemGray)
        listBarButton = createBarButtonItem(systemName: "square.and.arrow.up", action: #selector(shareTapped), tintColor: .systemGray)
        heartBarButton = createBarButtonItem(systemName: "cart", action: #selector(shoppingTapped), tintColor: .systemGray)

        spacer.width = fixedSpace
        navigationItem.rightBarButtonItems = [shoppingBarButton, spacer, shareBarButton, spacer, listBarButton, spacer, heartBarButton]
    }

    @objc private func shoppingTapped() {
        tabBarController?.selectedIndex = 2
    }

    @objc private func shareTapped() {
        guard let product = product else {
            print("Product bulunamadı")
            return
        }

        let productTitle = product.productTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "urun"
        let deepLinkURL = "n11cloneapp://product?title=\(productTitle)"

        if let imageUrlString = product.productImages.first {
            downloadImage(with: imageUrlString) { image in
                var itemsToShare: [Any] = [deepLinkURL]
                if let image = image {
                    itemsToShare.append(image)
                }

                let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                DispatchQueue.main.async {
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        } else {
            let activityViewController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc private func clickToFavouriteProduct() {
        presenter?.requestForAddToFavourites()
    }

    func updateActionButtonForFavouriteButton() {
        var NewShoppingBarButton = UIBarButtonItem()
        spacer.width = fixedSpace

        NewShoppingBarButton = createBarButtonItem(systemName: "heart.fill", action: #selector(removeFromFavourites), tintColor: .purple11)
        navigationItem.setRightBarButtonItems([NewShoppingBarButton, spacer, shareBarButton, spacer, listBarButton, spacer, heartBarButton], animated: true)

        self.fetchedProductFavouriteStatus = true
        self.updateHeartButton()
    }

    @objc private func removeFromFavourites() {
        presenter?.removeProductFromFavourites()
    }

    @objc private func listTapped() {}

    @objc func returnToRoot() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: -- Extensions
extension ProductDetailViewController {

}

extension ProductDetailViewController: UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let threshold: CGFloat = -100
        let hiddenHandler: CGFloat = 100

        if contentOffsetY <= threshold {
            navigationController?.popViewController(animated: true)
        }

        let shouldHideNavBar = contentOffsetY <= hiddenHandler
        setNavigationBarHidden(shouldHideNavBar)
        backToRootButton.isHidden = !shouldHideNavBar
        actionButtons.forEach {$0.isHidden = !shouldHideNavBar}
    }

    private func setNavigationBarHidden(_ hidden: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: true)
    }
}

