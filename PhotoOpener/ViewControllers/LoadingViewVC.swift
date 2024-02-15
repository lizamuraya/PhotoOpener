import UIKit

class LoadingViewVC: UIViewController {

    var containerView: UIView?
    
    func presentErrorAlert(message: String) {
         let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
     }
     

    func showLoadingView() {
        guard containerView == nil else { return }
        let newContainerView = UIView(frame: view.bounds)
        view.addSubview(newContainerView)
        newContainerView.backgroundColor = .systemBackground
        newContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { newContainerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        newContainerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: newContainerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: newContainerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        containerView = newContainerView
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            guard let containerView = self.containerView else { return }
            containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
}
