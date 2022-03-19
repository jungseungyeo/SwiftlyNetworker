# SwiftlyNetworker


[![Version](https://img.shields.io/cocoapods/v/SwiftlyNetworker.svg?style=flat)](https://cocoapods.org/pods/SwiftlyNetworker)
[![License](https://img.shields.io/cocoapods/l/SwiftlyNetworker.svg?style=flat)](https://cocoapods.org/pods/SwiftlyNetworker)
[![Platform](https://img.shields.io/cocoapods/p/SwiftlyNetworker.svg?style=flat)](https://cocoapods.org/pods/SwiftlyNetworker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SwiftlyNetworker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

``` ruby
pod 'SwiftlyNetworker'
```

## How to use

``` Swift
enum SojuAPI {
    case list
}

extension SojuAPI: APIable {
    var params: [String : Any]? {
        nil
    }

    var path: String {
        "/TestJSONfile/main/JSON/Test.json"
    }

    var method: HttpMethod {
        .get
    }

    var log: Bool { return false }
}

```

``` Swift

import SwiftlyNetworker

// ViewModel
class ViewModel {

    init(
        networker: NetworkerLogic = SwiftlyNetworker(componet: NetworkerLogicDependency)
    ) {
        self.networker = networker
    }

    func request() -> AnyPublisher<Model, Error> {
        return networker.request(SojuAPI.list).eraseToAnyPublisher()
    }

    func request(complete: @escaping ((Result<Model, Error>) -> Void)) {
        networker.request(SojuAPI.list, complete: complete)
    }
}


// UIViewController
class ViewController: UIViewController {

    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Combine
        viewModel.request()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { (model: Model) in
                print("model \(model)")
            }.store(in: &cancellables)


        // MARK: - Closure
        viewModel.request { (result: Result<Model, Error>) in
            switch result {
            case .success(let model):
                print("model \(model)")
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
}


```


## Author

linsaeng, duwjdtmd91@gmail.com

## License

SwiftlyNetworker is available under the MIT license. See the LICENSE file for more info.
