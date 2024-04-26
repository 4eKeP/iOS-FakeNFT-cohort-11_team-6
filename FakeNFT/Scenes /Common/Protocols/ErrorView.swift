import UIKit

struct ErrorModel {
    let rActionText: String
    let lActionText: String
    let rightAction: () -> Void
    
    init(rightAction: @escaping () -> Void) {
        rActionText = NSLocalizedString("Error.repeat", comment: "")
        lActionText = NSLocalizedString("Error.cancel", comment: "")
        self.rightAction = rightAction
    }
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let title = "Не удалось получить данные"
        let alert = UIAlertController(
            title: title,
            message: "",
            preferredStyle: .alert
        )
        let rAction = UIAlertAction(title: model.rActionText, style: UIAlertAction.Style.default) {_ in
            model.rightAction()
        }
        let lAction = UIAlertAction(title: model.lActionText, style: UIAlertAction.Style.cancel)
        alert.addAction(lAction)
        alert.addAction(rAction)
        present(alert, animated: true)
    }
}
