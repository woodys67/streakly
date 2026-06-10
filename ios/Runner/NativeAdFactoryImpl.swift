import GoogleMobileAds
import google_mobile_ads

class NativeAdFactoryImpl: NSObject, FLTNativeAdFactory {
    func createNativeAd(
        _ nativeAd: NativeAd,
        customOptions: [AnyHashable: Any]? = nil
    ) -> NativeAdView? {
        let adView = NativeAdView()
        adView.backgroundColor = .white

        // Ad badge
        let adBadge = UILabel()
        adBadge.text = "AD"
        adBadge.font = UIFont.boldSystemFont(ofSize: 9)
        adBadge.textColor = .white
        adBadge.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        adBadge.textAlignment = .center
        adBadge.layer.cornerRadius = 3
        adBadge.clipsToBounds = true
        adBadge.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adBadge.widthAnchor.constraint(equalToConstant: 22),
            adBadge.heightAnchor.constraint(equalToConstant: 14),
        ])

        // Headline
        let headlineLabel = UILabel()
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 14)
        headlineLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        headlineLabel.numberOfLines = 1
        headlineLabel.text = nativeAd.headline
        adView.headlineView = headlineLabel

        // Body
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        bodyLabel.numberOfLines = 2
        bodyLabel.text = nativeAd.body
        adView.bodyView = bodyLabel

        // Text stack
        let textStack = UIStackView(arrangedSubviews: [headlineLabel, bodyLabel])
        textStack.axis = .vertical
        textStack.spacing = 3

        // Top row: badge + text
        let topRow = UIStackView(arrangedSubviews: [adBadge, textStack])
        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.alignment = .center

        // CTA button
        let ctaButton = UIButton(type: .system)
        ctaButton.setTitle(nativeAd.callToAction, for: .normal)
        ctaButton.setTitleColor(UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0), for: .normal)
        ctaButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        ctaButton.isUserInteractionEnabled = false
        adView.callToActionView = ctaButton

        // Main stack
        let mainStack = UIStackView(arrangedSubviews: [topRow, ctaButton])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        adView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: adView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -16),
        ])

        adView.nativeAd = nativeAd
        return adView
    }
}
