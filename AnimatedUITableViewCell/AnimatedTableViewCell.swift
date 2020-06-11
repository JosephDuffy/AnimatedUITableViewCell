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
        let prepare = {}
        let perform = {
            self.footerViewBottomConstraint.isActive = false
            self.titlesStackViewBottomConstraint.isActive = true
        }
        let finalise = {
            self.footerView.isHidden = true
        }
        return Animation(prepare: prepare, perform: perform, finalise: finalise)
    }

    func makeFooterShowAnimation() -> Animation {
        let prepare = {
            self.footerView.isHidden = false
            self.titlesStackViewBottomToFooterViewConstraint.isActive = false
        }
        let perform = {
            self.footerViewBottomConstraint.isActive = false
            self.titlesStackViewBottomConstraint.isActive = true
        }
        let finalise = {
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
        titlesStackView.addArrangedSubview(label)
    }

    func removeLastTitle() {
        titlesStackView.arrangedSubviews.last.map { subview in
            titlesStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
}
