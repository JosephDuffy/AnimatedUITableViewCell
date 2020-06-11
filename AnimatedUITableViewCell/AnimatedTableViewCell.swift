import UIKit

final class AnimatedTableViewCell: UITableViewCell {

    struct Animation {
        var prepare: () -> Void
        var perform: () -> Void
        var finalise: () -> Void
    }

    @IBOutlet
    private(set) var footerView: UIView!

    @IBOutlet
    private(set) var titlesStackView: UIStackView!

    @IBOutlet
    private var titlesStackViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet
    private var titlesStackViewBottomToFooterViewConstraint: NSLayoutConstraint!

    @IBOutlet
    private var footerViewBottomConstraint: NSLayoutConstraint!

    override func prepareForReuse() {
        super.prepareForReuse()

        titlesStackView.arrangedSubviews.forEach { subview in
            titlesStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

    override func layoutSubviews() {
        footerView.layoutIfNeeded()

//        titlesStackViewBottomConstraint.constant = footerView.isHidden ? -footerView.frame.height : 0

        super.layoutSubviews()
    }

    func makeFooterHiddenAnimation(_ isHidden: Bool) -> Animation {
        return isHidden ? makeFooterHideAnimation() : makeFooterShowAnimation()
    }

    func makeFooterHideAnimation() -> Animation {
        let prepare = {
            print("Preparing hide")
        }
        let perform = {
            print("Performing hide")
            self.footerViewBottomConstraint.isActive = false
        }
        let finalise = {
            print("Finalising hide")
            self.footerView.isHidden = true
        }
        return Animation(prepare: prepare, perform: perform, finalise: finalise)
    }

    func makeFooterShowAnimation() -> Animation {
        let prepare = {
            print("Preparing show")
            self.footerView.isHidden = false
            self.footerViewBottomConstraint.isActive = false
        }
        let perform = {
            print("Performing show")
            self.footerViewBottomConstraint.isActive = true
        }
        let finalise = {
            print("Finalising show")
        }
        return Animation(prepare: prepare, perform: perform, finalise: finalise)
    }

    func makeAppendLabelAnimation(label: UILabel) -> Animation {
        let prepare = {
            print("Preparing append")
            self.titlesStackViewBottomToFooterViewConstraint.isActive = false
//            self.titlesStackViewBottomConstraint.isActive = false
            self.titlesStackView.addArrangedSubview(label)
            self.titlesStackView.layoutIfNeeded()
        }
        let perform = {
            print("Performing append")

            self.titlesStackViewBottomConstraint.isActive = true
        }
        let finalise = {
//            self.titlesStackViewBottomToFooterViewConstraint.isActive = true
            print("Finalising append")
        }
        return Animation(prepare: prepare, perform: perform, finalise: finalise)
    }

    func setFooterHidden(_ isHidden: Bool) {
        footerView.isHidden = isHidden
        footerViewBottomConstraint.isActive = !isHidden
    }

    func showTitles(_ titles: [String]) {
        titlesStackView.arrangedSubviews.forEach { subview in
            titlesStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        titles.forEach(appendTitle(_:))
    }

    func appendTitle(_ title: String) {
        let label = UILabel(frame: .zero)
        label.text = title
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        titlesStackView.addArrangedSubview(label)
    }

    func removeLastTitle() {
        titlesStackView.arrangedSubviews.last.map { subview in
            titlesStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
}
