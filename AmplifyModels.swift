// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "4a7d36613e6d589ce39fd4ddc311fb03"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Game.self)
    ModelRegistry.register(modelType: Player.self)
  }
}