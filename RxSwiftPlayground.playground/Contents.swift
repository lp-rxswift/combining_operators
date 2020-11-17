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

example(of: "observable.concat") {
  let first = Observable.of(1, 2, 3)
  let second = Observable.of(4, 5, 6)

  let observable = Observable.concat([first, second])

  observable.subscribe(onNext: { print($0) })
}

example(of: "concat") {
  let germanCities = Observable.of("Berlim", "Munich", "Frankfurt")
  let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")

  let observable = germanCities.concat(spanishCities)
  _ = observable.subscribe(onNext:{ print($0) })
}
