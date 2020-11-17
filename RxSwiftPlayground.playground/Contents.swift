import Foundation
import PlaygroundSupport
import RxSwift

PlaygroundPage.current.needsIndefiniteExecution = true


example(of: "start with") {
  let numbers = Observable.of("2","3","4")
  let observable = numbers.startWith("1")
  _ = observable
    .subscribe(onNext: { print($0) })
}
