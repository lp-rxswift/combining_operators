import Foundation
import PlaygroundSupport
import RxSwift

PlaygroundPage.current.needsIndefiniteExecution = true


example(of: "start with") {
  let bag = DisposeBag()
  let numbers = Observable.of("2","3","4")
  let observable = numbers.startWith("1")
  observable
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)
}
