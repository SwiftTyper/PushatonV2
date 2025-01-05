// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "1e142e283499d0d840863fdd6471f8cb"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Game.self)
    ModelRegistry.register(modelType: Player.self)
  }
}