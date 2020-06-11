import UIKit

final class TableViewController: UITableViewController {

    private var titles: [String] = [
        "Title 1",
        "Title 2",
        "Title 3",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "AnimatedTableViewCell", bundle: .main), forCellReuseIdentifier: "AnimatedTableViewCell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedTableViewCell", for: IndexPath(row: 0, section: 0)) as! AnimatedTableViewCell

        cell.showTitles(titles)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    @IBAction
    private func handleToggleFooterButtonTapped() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AnimatedTableViewCell else { return }

        let animation = cell.makeFooterHiddenAnimation(!cell.footerView.isHidden)

        animation.prepare()

        tableView.performBatchUpdates({
            animation.perform()
        }, completion: { _ in
            animation.finalise()
        })
    }

    @IBAction
    private func handleRemoveButtonTapped() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AnimatedTableViewCell else { return }

        tableView.performBatchUpdates({
            titles.removeLast()

            guard let label = cell.titlesStackView.arrangedSubviews.last else { return }
            // Hiding the label can't be animated here, so manually changing the frame is
            // used to cover the label, which will then be removed in the completion
//            label.alpha = 0
            cell.titlesStackView.frame.size.height -= label.frame.height
        }, completion: { isFinished in
            print("Animated finished", isFinished)
            cell.removeLastTitle()
        })
    }

    @IBAction
    private func handleAddButtonTapped() {
        let title = "Title \(titles.count + 1)"
        titles.append(title)

        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AnimatedTableViewCell else { return }
        let label = UILabel(frame: .zero)
        label.text = title
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        let animation = cell.makeAppendLabelAnimation(label: label)
        animation.prepare()

        tableView.performBatchUpdates({
            animation.perform()
        }, completion: { isFinished in
            animation.finalise()
        })

    }

}
