//
//  LoggedUserVC.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 3.09.2024.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class LoggedUserVC: UIViewController, CLLocationManagerDelegate {
    private var mapViewManager: MapViewManager?

    let scrollView = UIScrollView()
    let mainView = UIView()
    let contentView = UIView()


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        setupTopPanelViewContainer()

        mapViewManager = MapViewManager(mapView: mapView)
        mapView.delegate = mapViewManager
        scrollView.bounces = false
            scrollView.alwaysBounceVertical = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAddressCount()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    private let purpleUserTopPanelViewContainer: UIView = {
        let topPanelView = UIView()
        topPanelView.backgroundColor = UIColor(named: "purple11")
        topPanelView.translatesAutoresizingMaskIntoConstraints = false

        return topPanelView
    }()

    private let topPanelAboutUserView: UIView = {
        let topPanelAboutUserView = UIView()
        topPanelAboutUserView.backgroundColor = .white
        topPanelAboutUserView.layer.cornerRadius = 6
        topPanelAboutUserView.translatesAutoresizingMaskIntoConstraints = false

        return topPanelAboutUserView
    }()

    private let addressPanelView: UIView = {
        let addressPanelView = UIView()
        addressPanelView.translatesAutoresizingMaskIntoConstraints = false
        addressPanelView.layer.cornerRadius = 6
        addressPanelView.backgroundColor = .white

        return addressPanelView
    }()

    private let couponPanelView: UIView = {
        let couponPanelView = UIView()
        couponPanelView.translatesAutoresizingMaskIntoConstraints = false
        couponPanelView.layer.cornerRadius = 6
        couponPanelView.backgroundColor = .white

        return couponPanelView
    }()

    private let shortcutsContainerView: UIStackView = {
        let shortcutsContainer = UIStackView()
        shortcutsContainer.translatesAutoresizingMaskIntoConstraints = false
        shortcutsContainer.axis = .horizontal
        shortcutsContainer.distribution = .fillEqually
        shortcutsContainer.spacing = 10
        shortcutsContainer.alignment = .fill
        return shortcutsContainer
    }()

    private let ordersContainerView: UIView = {
        let orderView = UIView()
        orderView.translatesAutoresizingMaskIntoConstraints = false
        orderView.backgroundColor = .white

        return orderView
    }()

    private let questionToStore: UIView = {
        let questionToStore = UIView()
        questionToStore.translatesAutoresizingMaskIntoConstraints = false
        questionToStore.backgroundColor = .white

        return questionToStore
    }()

    private let userCapitalLetterNameView: UIView = {
        let capitalView = UIView()
        capitalView.translatesAutoresizingMaskIntoConstraints = false
        capitalView.backgroundColor = UIColor(named: "lightpurple11")
        capitalView.layer.cornerRadius = 25

        return capitalView
    }()

    private let capitalLetterNameCenteredLabel: UILabel = {
        let capitalLetterCenteredLabel = UILabel()
        capitalLetterCenteredLabel.translatesAutoresizingMaskIntoConstraints = false
        capitalLetterCenteredLabel.textColor = UIColor(named: "purple11")
        capitalLetterCenteredLabel.font = .systemFont(ofSize: 20, weight: .bold)

        return capitalLetterCenteredLabel
    }()

    //MARK: WelcomeSection
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let welcomeLabelEmail: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let userPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let tapToUserSettingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "gearshape")?.withTintColor(Constants.generalGrayColor)
        button.setImage(image, for: .normal)
        button.tintColor = Constants.generalGrayColor

        return button
    }()

    //MARK: AddressSection
    private let addressTitle = UIComponentsFactory.createLabel(
        text: "Adreslerim",
        fontSize: 15,
        fontWeight: .semibold
    )

    private let addressPanelPaddedBadge = UIComponentsFactory.createPaddedBadge(
        text: "YENİ",
        fontSize: 11,
        textColor: UIColor(hex: "#F7CE46"),
        backgroundColor: UIColor(named: "purple11")!
    )

    private let arrowButton2 = UIComponentsFactory.createArrowButton()

    //MARK: Address SubView First
    private let addressLeftView: UIView = {
        let addressView = UIView()
        addressView.translatesAutoresizingMaskIntoConstraints = false
        addressView.backgroundColor = .white

        return addressView
    }()

    private let totalAddressLabel: UILabel = {
        let totalAddressLabel = UILabel()
        totalAddressLabel.text = "Kayıtlı Adreslerim"
        totalAddressLabel.textColor = Constants.generalGrayColor
        totalAddressLabel.font = .systemFont(ofSize: 13, weight: .medium)
        totalAddressLabel.translatesAutoresizingMaskIntoConstraints = false

        return totalAddressLabel
    }()

    private let totalAddressCountLabel: UILabel = {
        let totalAddressCount = UILabel()
        totalAddressCount.textColor = UIColor(named: "purple11")
        totalAddressCount.font = .systemFont(ofSize: 50, weight: .bold)
        totalAddressCount.translatesAutoresizingMaskIntoConstraints = false

        return totalAddressCount
    }()

    private let totalAddressCountAdviceLabel: UILabel = {
        let adviceLabelForAddress = UILabel()
        adviceLabelForAddress.text = "Artık dilediğin kadar adres kaydedebilirsin!"
        adviceLabelForAddress.numberOfLines = 2
        adviceLabelForAddress.font = .systemFont(ofSize: 13, weight: .bold)
        adviceLabelForAddress.translatesAutoresizingMaskIntoConstraints = false
        adviceLabelForAddress.textColor = Constants.generalGrayColor

        return adviceLabelForAddress
    }()

    //MARK: Address SubView Second

    private let addressRightView: UIView = {
        let addressDisplayView = UIView()
        addressDisplayView.translatesAutoresizingMaskIntoConstraints = false
        addressDisplayView.backgroundColor = .white

        return addressDisplayView
    }()

    private let currentLocationLabel: UILabel = {
        let currentLocationLabel = UILabel()
        currentLocationLabel.text = "Mevcut Konumum📍"
        currentLocationLabel.textColor = Constants.generalGrayColor
        currentLocationLabel.font = .systemFont(ofSize: 11, weight: .medium)
        currentLocationLabel.translatesAutoresizingMaskIntoConstraints = false

        return currentLocationLabel
    }()

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 6
        return mapView
    }()

    private let currentLocationDescriptionLabel: UILabel = {
        let currentLocationDescriptionLabel = UILabel()
        currentLocationDescriptionLabel.text = "Kargolarını Ulaştırmak İçin Sabırsızlanıyoruz!"
        currentLocationDescriptionLabel.numberOfLines = 2
        currentLocationDescriptionLabel.textColor = Constants.generalGrayColor
        currentLocationDescriptionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        currentLocationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        return currentLocationDescriptionLabel
    }()

    private func createDividerNextToIt() -> UIView{
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .separator
        return divider
    }

    //MARK: CouponSection
    private let couponPanelTitle = UIComponentsFactory.createLabel(
        text: "Kuponlarım",
        fontSize: 15,
        fontWeight: .semibold
    )

    private let couponPanelBadge = UIComponentsFactory.createPaddedBadge(
        text: "YAKINDA!",
        fontSize: 11,
        textColor: UIColor(hex: "#F7CE46"),
        backgroundColor: UIColor(named: "purple11")!
    )

    private let arrowButtonForCoupon = UIComponentsFactory.createArrowButton()

    //MARK: CouponLeftView
    private let couponLeftView: UIView = {
        let couponLeftView = UIView()
        couponLeftView.translatesAutoresizingMaskIntoConstraints = false

        return couponLeftView
    }()

    private let totalCouponTextLabel: UILabel = {
        let totalCouponTextLabel = UILabel()
        totalCouponTextLabel.text = "Toplam Kuponum"
        totalCouponTextLabel.textColor = Constants.generalGrayColor
        totalCouponTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
        totalCouponTextLabel.translatesAutoresizingMaskIntoConstraints = false

        return totalCouponTextLabel
    }()

    private let totalCouponNumberLabel: UILabel = {
        let totalCouponNumberLabel = UILabel()
        totalCouponNumberLabel.text = "0"
        totalCouponNumberLabel.textColor = UIColor(named: "purple11")
        totalCouponNumberLabel.font = .systemFont(ofSize: 40, weight: .bold)
        totalCouponNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        return totalCouponNumberLabel
    }()

    private let totalCouponAdviceTextLabel: UILabel = {
        let totalCouponAdviceTextLabel = UILabel()
        totalCouponAdviceTextLabel.text = "Kupon kodunla yeni bir tane ekle!"
        totalCouponAdviceTextLabel.numberOfLines = 2
        totalCouponAdviceTextLabel.font = .systemFont(ofSize: 13, weight: .bold)
        totalCouponAdviceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCouponAdviceTextLabel.textColor = Constants.generalGrayColor

        return totalCouponAdviceTextLabel
    }()

    //MARK: CouponRightView
    private let couponRightView: UIView = {
        let couponRightView = UIView()
        couponRightView.translatesAutoresizingMaskIntoConstraints = false

        return couponRightView
    }()

    private let couponPointTextLabel: UILabel = {
        let couponPointTextLabel = UILabel()
        couponPointTextLabel.text = "UçUç Puanım"
        couponPointTextLabel.textColor = Constants.generalGrayColor
        couponPointTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
        couponPointTextLabel.translatesAutoresizingMaskIntoConstraints = false

        return couponPointTextLabel
    }()

    private let couponPointNumberLabel: UILabel = {
        let couponPointNumberLabel = UILabel()
        couponPointNumberLabel.text = "0"
        couponPointNumberLabel.textColor = UIColor(named: "purple11")
        couponPointNumberLabel.font = .systemFont(ofSize: 40, weight: .bold)
        couponPointNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        return couponPointNumberLabel
    }()

    private let couponPointAdviceTextLabel: UILabel = {
        let couponPointAdviceTextLabel = UILabel()
        couponPointAdviceTextLabel.text = "UçUç Puanlarını kullanarak kupon oluştur."
        couponPointAdviceTextLabel.numberOfLines = 2
        couponPointAdviceTextLabel.font = .systemFont(ofSize: 13, weight: .bold)
        couponPointAdviceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        couponPointAdviceTextLabel.textColor = Constants.generalGrayColor

        return couponPointAdviceTextLabel
    }()

    //MARK: OrderSection Out Purple
    private let orderMainLabel: UILabel = {
        let orderMainLabel = UILabel()
        orderMainLabel.text = "Siparişlerim & İadelerim"
        orderMainLabel.textColor = UIColor(named: "purple11")
        orderMainLabel.font = .systemFont(ofSize: 16, weight: .bold)
        orderMainLabel.translatesAutoresizingMaskIntoConstraints = false

        return orderMainLabel
    }()

    private let orderSubLabel: UILabel = {
        let orderSubLabel = UILabel()
        orderSubLabel.text = "Henüz hiç sipariş vermedin."
        orderSubLabel.textColor = .gray
        orderSubLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        orderSubLabel.translatesAutoresizingMaskIntoConstraints = false

        return orderSubLabel
    }()

    //MARK: QuestionSection
    private let questionMainLabel: UILabel = {
        let questionMainLabel = UILabel()
        questionMainLabel.text = "Mağazaya Sorularım"
        questionMainLabel.textColor = UIColor(named: "purple11")
        questionMainLabel.font = .systemFont(ofSize: 16, weight: .bold)
        questionMainLabel.translatesAutoresizingMaskIntoConstraints = false

        return questionMainLabel
    }()

    private let questionSubLabel: UILabel = {
        let questionSubLabel = UILabel()
        questionSubLabel.text = "Sorduğun sorulara ve gelen cevaplara ulaş."
        questionSubLabel.textColor = .gray
        questionSubLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        questionSubLabel.translatesAutoresizingMaskIntoConstraints = false

        return questionSubLabel
    }()

    private func setupTopPanelViewContainer() {
        view.backgroundColor = .purple11
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = UIColor(hex: "#F5F5F5")

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(hex: "#F5F5F5")

        view.addSubview(mainView)
        mainView.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let dividerFirst = createDividerNextToIt()
        let dividerSecond = createDividerNextToIt()
        let shortcutView1Container = createShortcutViewContainer(withImageName: "heart.fill")
        let shortcutView2Container = createShortcutViewContainer(withImageName: "location.fill")
        let shortcutView3Container = createShortcutViewContainer(withImageName: "clock.fill")
        let shortcutView4Container = createShortcutViewContainer(withImageName: "xmark.square.fill")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutButtonTapped))
        let tapGestureFavorites = UITapGestureRecognizer(target: self, action: #selector(favouritesButtonTapped))
        let tapGestureAddress = UITapGestureRecognizer(target: self, action: #selector(redirectToAddress))
        let tapGestureAddresses = UITapGestureRecognizer(target: self, action: #selector(redirectToAddress))
        let tapGestureProductHistory = UITapGestureRecognizer(target: self, action: #selector(redirectToAddress))
        let tapOrdersGesture = UITapGestureRecognizer(target: self, action: #selector(redirectToOrders))

        shortcutView4Container.addGestureRecognizer(tapGesture)
        shortcutView4Container.isUserInteractionEnabled = true

        shortcutView3Container.addGestureRecognizer(tapGestureProductHistory)
        shortcutView3Container.isUserInteractionEnabled = true

        shortcutView2Container.addGestureRecognizer(tapGestureAddresses)
        shortcutView2Container.isUserInteractionEnabled = true

        shortcutView1Container.addGestureRecognizer(tapGestureFavorites)
        shortcutView1Container.isUserInteractionEnabled = true

        addressPanelView.isUserInteractionEnabled = true
        addressPanelView.addGestureRecognizer(tapGestureAddress)

        ordersContainerView.isUserInteractionEnabled = true
        ordersContainerView.addGestureRecognizer(tapOrdersGesture)

        addLabel(to: shortcutView1Container, withText: "Favorilerim")
        addLabel(to: shortcutView2Container, withText: "Adreslerim")
        addLabel(to: shortcutView3Container, withText: "Baktıklarım")
        addLabel(to: shortcutView4Container, withText: "Çıkış Yap")

        contentView.addSubview(purpleUserTopPanelViewContainer)
        purpleUserTopPanelViewContainer.addSubview(topPanelAboutUserView)
        purpleUserTopPanelViewContainer.addSubview(addressPanelView)
        purpleUserTopPanelViewContainer.addSubview(couponPanelView)
        purpleUserTopPanelViewContainer.addSubview(shortcutsContainerView)

        topPanelAboutUserView.addSubview(userCapitalLetterNameView)
        topPanelAboutUserView.addSubview(capitalLetterNameCenteredLabel)
        topPanelAboutUserView.addSubview(welcomeLabel)
        topPanelAboutUserView.addSubview(welcomeLabelEmail)
        topPanelAboutUserView.addSubview(userPhoneNumberLabel)
        topPanelAboutUserView.addSubview(tapToUserSettingsButton)

        addressPanelView.addSubview(addressTitle)
        addressPanelView.addSubview(addressPanelPaddedBadge)
        addressPanelView.addSubview(arrowButton2)
        addressPanelView.addSubview(addressLeftView)

        addressLeftView.addSubview(totalAddressLabel)
        addressLeftView.addSubview(totalAddressCountLabel)
        addressLeftView.addSubview(totalAddressCountAdviceLabel)

        addressPanelView.addSubview(dividerFirst)
        addressPanelView.addSubview(addressRightView)
        addressRightView.addSubview(currentLocationLabel)
        addressRightView.addSubview(mapView)
        addressRightView.addSubview(currentLocationDescriptionLabel)

        couponPanelView.addSubview(couponPanelTitle)
        couponPanelView.addSubview(couponPanelBadge)
        couponPanelView.addSubview(arrowButtonForCoupon)

        couponPanelView.addSubview(dividerSecond)
        couponPanelView.addSubview(couponLeftView)
        couponPanelView.addSubview(couponRightView)

        couponLeftView.addSubview(totalCouponTextLabel)
        couponLeftView.addSubview(totalCouponNumberLabel)
        couponLeftView.addSubview(totalCouponAdviceTextLabel)

        couponRightView.addSubview(couponPointTextLabel)
        couponRightView.addSubview(couponPointNumberLabel)
        couponRightView.addSubview(couponPointAdviceTextLabel)

        shortcutsContainerView.addArrangedSubview(shortcutView1Container)
        shortcutsContainerView.addArrangedSubview(shortcutView2Container)
        shortcutsContainerView.addArrangedSubview(shortcutView3Container)
        shortcutsContainerView.addArrangedSubview(shortcutView4Container)

        contentView.addSubview(ordersContainerView)
        ordersContainerView.addSubview(orderMainLabel)
        ordersContainerView.addSubview(orderSubLabel)

        contentView.addSubview(questionToStore)
        questionToStore.addSubview(questionMainLabel)
        questionToStore.addSubview(questionSubLabel)
        var constantValue = 0
        if view.bounds.height < 800 {
            constantValue = 180
        } else if view.bounds.height < 840{
            constantValue = 80
        } else {
            constantValue = 25
        }

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: mainView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: CGFloat(constantValue))

        ])

        NSLayoutConstraint.activate([
            purpleUserTopPanelViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            purpleUserTopPanelViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            purpleUserTopPanelViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            purpleUserTopPanelViewContainer.bottomAnchor.constraint(equalTo: shortcutsContainerView.bottomAnchor, constant: 5)
        ])

        NSLayoutConstraint.activate([
            topPanelAboutUserView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            topPanelAboutUserView.leadingAnchor.constraint(equalTo: purpleUserTopPanelViewContainer.leadingAnchor, constant: 20),
            topPanelAboutUserView.trailingAnchor.constraint(equalTo: purpleUserTopPanelViewContainer.trailingAnchor, constant: -20),
            topPanelAboutUserView.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            tapToUserSettingsButton.centerYAnchor.constraint(equalTo: topPanelAboutUserView.centerYAnchor),
            tapToUserSettingsButton.trailingAnchor.constraint(equalTo: topPanelAboutUserView.trailingAnchor, constant: -10),
            tapToUserSettingsButton.widthAnchor.constraint(equalToConstant: 30),
            tapToUserSettingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            userCapitalLetterNameView.centerYAnchor.constraint(equalTo: topPanelAboutUserView.centerYAnchor),
            userCapitalLetterNameView.leadingAnchor.constraint(equalTo: topPanelAboutUserView.leadingAnchor, constant: 10),
            userCapitalLetterNameView.widthAnchor.constraint(equalToConstant: 50),
            userCapitalLetterNameView.heightAnchor.constraint(equalToConstant: 50),

            capitalLetterNameCenteredLabel.centerXAnchor.constraint(equalTo: userCapitalLetterNameView.centerXAnchor),
            capitalLetterNameCenteredLabel.centerYAnchor.constraint(equalTo: userCapitalLetterNameView.centerYAnchor),

            welcomeLabel.topAnchor.constraint(equalTo: userCapitalLetterNameView.topAnchor, constant: 0),
            welcomeLabel.leadingAnchor.constraint(equalTo: userCapitalLetterNameView.trailingAnchor, constant: 10),

            welcomeLabelEmail.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5),
            welcomeLabelEmail.leadingAnchor.constraint(equalTo: userCapitalLetterNameView.trailingAnchor, constant: 10),

            userPhoneNumberLabel.topAnchor.constraint(equalTo: welcomeLabelEmail.bottomAnchor, constant: 5),
            userPhoneNumberLabel.leadingAnchor.constraint(equalTo: userCapitalLetterNameView.trailingAnchor, constant: 10),
        ])

        NSLayoutConstraint.activate([
            addressPanelView.topAnchor.constraint(equalTo: topPanelAboutUserView.bottomAnchor, constant: 10),
            addressPanelView.leadingAnchor.constraint(equalTo: topPanelAboutUserView.leadingAnchor),
            addressPanelView.trailingAnchor.constraint(equalTo: topPanelAboutUserView.trailingAnchor),
            addressPanelView.heightAnchor.constraint(equalToConstant: 190),

            arrowButton2.topAnchor.constraint(equalTo: addressPanelView.topAnchor, constant: Constants.contentPaddingFrameVertical),
            arrowButton2.trailingAnchor.constraint(equalTo: addressPanelView.trailingAnchor, constant: -10),
            arrowButton2.widthAnchor.constraint(equalToConstant: 24),
            arrowButton2.heightAnchor.constraint(equalToConstant: 24),

            addressTitle.topAnchor.constraint(equalTo: addressPanelView.topAnchor, constant: Constants.contentPaddingFrameVertical),
            addressTitle.leadingAnchor.constraint(equalTo: addressPanelView.leadingAnchor,constant: Constants.contentPaddingFrameHorizontal),
            addressTitle.heightAnchor.constraint(equalToConstant: 20),

            addressPanelPaddedBadge.topAnchor.constraint(equalTo: addressTitle.topAnchor),
            addressPanelPaddedBadge.leadingAnchor.constraint(equalTo: addressTitle.trailingAnchor, constant: 5),
            addressPanelPaddedBadge.bottomAnchor.constraint(equalTo: addressTitle.bottomAnchor),

            //MARK: AddressLeftView

            addressLeftView.leadingAnchor.constraint(equalTo: addressTitle.leadingAnchor),
            addressLeftView.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 12),
            addressLeftView.widthAnchor.constraint(equalTo: addressPanelView.widthAnchor, multiplier: 1/2.5),
            addressLeftView.bottomAnchor.constraint(equalTo: addressPanelView.bottomAnchor, constant: -10),

            totalAddressLabel.topAnchor.constraint(equalTo: addressLeftView.topAnchor, constant: 0),
            totalAddressLabel.leadingAnchor.constraint(equalTo: addressLeftView.leadingAnchor, constant: 0),
            totalAddressLabel.trailingAnchor.constraint(equalTo: addressLeftView.trailingAnchor, constant: 0),
            totalAddressLabel.heightAnchor.constraint(equalToConstant: 12),

            totalAddressCountLabel.topAnchor.constraint(equalTo: totalAddressLabel.bottomAnchor, constant: 5),
            totalAddressCountLabel.leadingAnchor.constraint(equalTo: totalAddressLabel.leadingAnchor),
            totalAddressCountLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -5),

            totalAddressCountAdviceLabel.bottomAnchor.constraint(equalTo: addressLeftView.bottomAnchor, constant: -5),
            totalAddressCountAdviceLabel.leadingAnchor.constraint(equalTo: totalAddressLabel.leadingAnchor),
            totalAddressCountAdviceLabel.trailingAnchor.constraint(equalTo: totalAddressLabel.trailingAnchor),

            dividerFirst.widthAnchor.constraint(equalToConstant: 0.5),
            dividerFirst.leadingAnchor.constraint(equalTo: addressLeftView.trailingAnchor, constant: 5),
            dividerFirst.topAnchor.constraint(equalTo: addressLeftView.topAnchor),
            dividerFirst.bottomAnchor.constraint(equalTo: addressLeftView.bottomAnchor, constant: -10),
        ])

        //MARK: AddressRightView
        NSLayoutConstraint.activate([
            addressRightView.topAnchor.constraint(equalTo: addressLeftView.topAnchor),
            addressRightView.leadingAnchor.constraint(equalTo: dividerFirst.leadingAnchor, constant: 10),
            addressRightView.trailingAnchor.constraint(equalTo: addressPanelView.trailingAnchor, constant: -Constants.contentPaddingFrameHorizontal),
            addressRightView.bottomAnchor.constraint(equalTo: addressLeftView.bottomAnchor),

            currentLocationLabel.topAnchor.constraint(equalTo: addressRightView.topAnchor, constant: 0),
            currentLocationLabel.leadingAnchor.constraint(equalTo: addressRightView.leadingAnchor, constant: 2),

            mapView.topAnchor.constraint(equalTo: currentLocationLabel.bottomAnchor, constant: 8),
            mapView.bottomAnchor.constraint(equalTo: currentLocationDescriptionLabel.topAnchor, constant: -4),
            mapView.leadingAnchor.constraint(equalTo: currentLocationLabel.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: addressRightView.trailingAnchor, constant: 0),

            currentLocationDescriptionLabel.topAnchor.constraint(equalTo: totalAddressCountAdviceLabel.topAnchor),
            currentLocationDescriptionLabel.bottomAnchor.constraint(equalTo: totalAddressCountAdviceLabel.bottomAnchor),
            currentLocationDescriptionLabel.leadingAnchor.constraint(equalTo: currentLocationLabel.leadingAnchor),
            currentLocationDescriptionLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            couponPanelView.topAnchor.constraint(equalTo: addressPanelView.bottomAnchor, constant: 10),
            couponPanelView.leadingAnchor.constraint(equalTo: addressPanelView.leadingAnchor),
            couponPanelView.trailingAnchor.constraint(equalTo: addressPanelView.trailingAnchor),
            couponPanelView.heightAnchor.constraint(equalToConstant: 160),

            arrowButtonForCoupon.topAnchor.constraint(equalTo: couponPanelView.topAnchor, constant: Constants.contentPaddingFrameVertical),
            arrowButtonForCoupon.trailingAnchor.constraint(equalTo: couponPanelView.trailingAnchor, constant: -10),
            arrowButtonForCoupon.widthAnchor.constraint(equalToConstant: 24),
            arrowButtonForCoupon.heightAnchor.constraint(equalToConstant: 24),

            couponPanelTitle.leadingAnchor.constraint(equalTo: couponPanelView.leadingAnchor, constant: Constants.contentPaddingFrameHorizontal),
            couponPanelTitle.topAnchor.constraint(equalTo: couponPanelView.topAnchor, constant: Constants.contentPaddingFrameVertical),
            couponPanelTitle.heightAnchor.constraint(equalToConstant: 20),

            couponPanelBadge.leadingAnchor.constraint(equalTo: couponPanelTitle.trailingAnchor, constant: 5),
            couponPanelBadge.centerYAnchor.constraint(equalTo: couponPanelTitle.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            couponLeftView.topAnchor.constraint(equalTo: couponPanelTitle.bottomAnchor, constant: 10),
            couponLeftView.leadingAnchor.constraint(equalTo: couponPanelTitle.leadingAnchor),
            couponLeftView.bottomAnchor.constraint(equalTo: couponPanelView.bottomAnchor, constant: -10),
            couponLeftView.widthAnchor.constraint(equalTo: couponPanelView.widthAnchor, multiplier: 1/3),

            totalCouponTextLabel.topAnchor.constraint(equalTo: couponLeftView.topAnchor, constant: 0),
            totalCouponTextLabel.leadingAnchor.constraint(equalTo: couponLeftView.leadingAnchor, constant: 0),
            totalCouponTextLabel.trailingAnchor.constraint(equalTo: couponLeftView.trailingAnchor, constant: 0),
            totalCouponTextLabel.heightAnchor.constraint(equalToConstant: 15),

            totalCouponNumberLabel.topAnchor.constraint(equalTo: totalCouponTextLabel.bottomAnchor, constant: -10),
            totalCouponNumberLabel.leadingAnchor.constraint(equalTo: totalCouponTextLabel.leadingAnchor),
            totalCouponNumberLabel.trailingAnchor.constraint(equalTo: totalCouponTextLabel.trailingAnchor),
            totalCouponNumberLabel.bottomAnchor.constraint(equalTo: totalCouponAdviceTextLabel.topAnchor, constant: 10),

            totalCouponAdviceTextLabel.bottomAnchor.constraint(equalTo: couponLeftView.bottomAnchor, constant: 0),
            totalCouponAdviceTextLabel.leadingAnchor.constraint(equalTo: totalCouponTextLabel.leadingAnchor),
            totalCouponAdviceTextLabel.trailingAnchor.constraint(equalTo: totalCouponTextLabel.trailingAnchor),
            totalCouponAdviceTextLabel.heightAnchor.constraint(equalToConstant:40),

            dividerSecond.leadingAnchor.constraint(equalTo: couponLeftView.trailingAnchor, constant: 5),
            dividerSecond.topAnchor.constraint(equalTo: couponLeftView.topAnchor),
            dividerSecond.bottomAnchor.constraint(equalTo: couponLeftView.bottomAnchor, constant: -10),
            dividerSecond.widthAnchor.constraint(equalToConstant: 0.5)
        ])

        NSLayoutConstraint.activate([
            couponRightView.topAnchor.constraint(equalTo: couponLeftView.topAnchor),
            couponRightView.bottomAnchor.constraint(equalTo: couponLeftView.bottomAnchor),
            couponRightView.leadingAnchor.constraint(equalTo: dividerSecond.trailingAnchor, constant: 10),
            couponRightView.trailingAnchor.constraint(equalTo: couponPanelView.trailingAnchor, constant: -Constants.contentPaddingFrameHorizontal),

            couponPointTextLabel.topAnchor.constraint(equalTo: couponRightView.topAnchor, constant: 0),
            couponPointTextLabel.leadingAnchor.constraint(equalTo: couponRightView.leadingAnchor),
            couponPointTextLabel.trailingAnchor.constraint(equalTo: couponRightView.trailingAnchor, constant: 0),
            couponPointTextLabel.heightAnchor.constraint(equalToConstant: 15),

            couponPointNumberLabel.topAnchor.constraint(equalTo: couponPointTextLabel.bottomAnchor, constant: -10),
            couponPointNumberLabel.leadingAnchor.constraint(equalTo: couponPointTextLabel.leadingAnchor),
            couponPointNumberLabel.trailingAnchor.constraint(equalTo: couponPointTextLabel.trailingAnchor),
            couponPointNumberLabel.bottomAnchor.constraint(equalTo: couponPointAdviceTextLabel.topAnchor, constant: 10),

            couponPointAdviceTextLabel.bottomAnchor.constraint(equalTo: couponRightView.bottomAnchor, constant: 0),
            couponPointAdviceTextLabel.leadingAnchor.constraint(equalTo: couponPointTextLabel.leadingAnchor),
            couponPointAdviceTextLabel.trailingAnchor.constraint(equalTo: couponPointTextLabel.trailingAnchor),
            couponPointAdviceTextLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            shortcutsContainerView.topAnchor.constraint(equalTo: couponPanelView.bottomAnchor,constant: 10),
            shortcutsContainerView.leadingAnchor.constraint(equalTo: addressPanelView.leadingAnchor),
            shortcutsContainerView.trailingAnchor.constraint(equalTo: addressPanelView.trailingAnchor),
            shortcutsContainerView.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            ordersContainerView.topAnchor.constraint(equalTo: purpleUserTopPanelViewContainer.bottomAnchor, constant: 10),
            ordersContainerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            ordersContainerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            ordersContainerView.bottomAnchor.constraint(equalTo: orderSubLabel.bottomAnchor, constant: Constants.bottomContainerPaddings),

            orderMainLabel.topAnchor.constraint(equalTo: ordersContainerView.topAnchor, constant: Constants.bottomContainerPaddings),
            orderMainLabel.leadingAnchor.constraint(equalTo: ordersContainerView.leadingAnchor, constant: Constants.contentPaddingFrameHorizontal),

            orderSubLabel.topAnchor.constraint(equalTo: orderMainLabel.bottomAnchor, constant: 4),
            orderSubLabel.leadingAnchor.constraint(equalTo: orderMainLabel.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            questionToStore.topAnchor.constraint(equalTo: ordersContainerView.bottomAnchor, constant: 10),
            questionToStore.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            questionToStore.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            questionToStore.bottomAnchor.constraint(equalTo: questionSubLabel.bottomAnchor, constant: Constants.bottomContainerPaddings),

            questionMainLabel.topAnchor.constraint(equalTo: questionToStore.topAnchor, constant: Constants.bottomContainerPaddings),
            questionMainLabel.leadingAnchor.constraint(equalTo: questionToStore.leadingAnchor, constant: Constants.contentPaddingFrameHorizontal),

            questionSubLabel.topAnchor.constraint(equalTo: questionMainLabel.bottomAnchor, constant: 4),
            questionSubLabel.leadingAnchor.constraint(equalTo: questionMainLabel.leadingAnchor),
        ])
    }

    private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()

        // Fetch user data
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists, let data = document.data() else {
                print("Document does not exist or an error occurred")
                return
            }

            let firstName = data["firstName"] as? String ?? "Kullanıcı"
            let lastName = data["lastName"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""

            Task
            {
                @MainActor in
                self.welcomeLabel.text = "Merhaba, \(firstName) 👋🏻"
                self.welcomeLabelEmail.text = "\(email)"
                self.userPhoneNumberLabel.text = "\(phoneNumber)"

                let firstNamePrefixed = firstName.prefix(1).uppercased()
                let lastNamePrefixed = lastName.prefix(1).uppercased()
                let mergedPrefix = "\(firstNamePrefixed)\(lastNamePrefixed)"

                self.capitalLetterNameCenteredLabel.text = mergedPrefix
            }
        }
    }

    private func fetchAddressCount() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("addresses").getDocuments { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents, error == nil else {
                print("Error fetching addresses: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let addressCount = documents.count
            Task
            {
                @MainActor in
                UIView.animate(withDuration:0.3) {
                    self.totalAddressCountLabel.text = "\(addressCount)"
                }
            }
        }
    }

    @objc private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: .userDidSignOut, object: nil)
            print("User logged out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    @objc private func favouritesButtonTapped() {
        print("Redirecting to Favorites")
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 3
        }
    }

    @objc private func redirectToAddress() {
        print("Redirecting to AddressViewController")

        if let navigationController = self.navigationController {
            print("Navigation Controller is available")
            let addressVC = AddressViewController()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            backButton.tintColor = .white
            navigationItem.backBarButtonItem = backButton

            navigationController.pushViewController(addressVC, animated: true)
        } else {
            print("Navigation Controller is not available")
        }
    }

    @objc private func redirectToOrders() {
        if let navigationController = self.navigationController {
            print("Navigation Controller is available")
            let orderModule = OrderModuleBuilder.createModule()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            backButton.tintColor = .white
            navigationItem.backBarButtonItem = backButton

            navigationController.pushViewController(orderModule, animated: true)
        } else {
            print("Navigation Controller is not available")
        }
    }
}


extension LoggedUserVC {
    enum Constants {
        static let contentPaddingFrameVertical: CGFloat = 10
        static let contentPaddingFrameHorizontal: CGFloat = 16

        static let bottomContainerPaddings: CGFloat = 20

        static let generalGrayColor: UIColor = .gray
        static let shortcutBackgroundColor: UIColor = UIColor(named: "orange11")!
    }
}
