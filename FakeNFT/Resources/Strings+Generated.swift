// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    internal enum Profile {
        /// Мои NFT
        internal static let myNFT = L10n.tr("Localizable", "Profile.myNFT", fallback: "Мои NFT")
        /// Избранные NFT
        internal static let favoritesNFT = L10n.tr("Localizable", "Profile.favoritesNFT", fallback: "Избранные NFT")
        /// О разработчике
        internal static let aboutDeveloper = L10n.tr("Localizable", "Profile.aboutDeveloper", fallback: "О разработчике")
        /// Имя
        internal static let name = L10n.tr("Localizable", "Profile.name", fallback: "Имя")
        /// Описание
        internal static let description = L10n.tr("Localizable", "Profile.description", fallback: "Описание")
        /// Сайт
        internal static let site = L10n.tr("Localizable", "Profile.site", fallback: "Сайт")
        /// Загрузить изображение
        internal static let loadAvatar = L10n.tr("Localizable", "Profile.loadAvatar", fallback: "Загрузить изображение")
        /// Сменить фото
        internal static let changeImage = L10n.tr("Localizable", "Profile.changeImage", fallback: "Сменить фото")
        /// Цена
        internal static let priceText = L10n.tr("Localizable", "Profile.priceText", fallback: "Цена")
        /// У вас ещё нет NFT
        internal static let emptyNFTLabel = L10n.tr("Localizable", "Profile.emptyNFTLabel", fallback: "У вас ещё нет NFT")
        /// Избранные NFT
        internal static let NFTFavorites = L10n.tr("Localizable", "Profile.NFTFavorites", fallback: "Избранные NFT")
        /// У Вас ещё нет избранных NFT
        internal static let emptyFavouriteNFT = L10n.tr("Localizable", "Profile.emptyFavouriteNFT", fallback: "У Вас ещё нет избранных NFT")
        /// Сортировка
        internal static let filter = L10n.tr("Localizable", "Profile.filter", fallback: "Сортировка")
        /// По цене
        internal static let byPrice = L10n.tr("Localizable", "Profile.byPrice", fallback: "По цене")
        /// По названию
        internal static let byName = L10n.tr("Localizable", "Profile.byName", fallback: "По названию")
        /// По рейтингу
        internal static let byRaiting = L10n.tr("Localizable", "Profile.byRaiting", fallback: "По рейтингу")
        /// Закрыть
        internal static let close = L10n.tr("Localizable", "Profile.close", fallback: "Закрыть")
        /// Загрузить изображение
        internal static let loadImage = L10n.tr("Localizable", "Profile.loadImage", fallback: "Загрузить изображение")
        /// Вставьте ссылку на изображение
        internal static let linkToImage = L10n.tr("Localizable", "Profile.linkToImage", fallback: "Вставьте ссылку на изображение")
        /// Вставьте ссылку:
        internal static let placeLink = L10n.tr("Localizable", "Profile.placeLink", fallback: "Вставьте ссылку: ")
        /// Cсылка недействительна
        internal static let invalidLink = L10n.tr("Localizable", "Profile.invalidLink", fallback: "Cсылка недействительна")
        /// Проверьте верность ссылки
        internal static let checkLink = L10n.tr("Localizable", "Profile.checkLink", fallback: "Проверьте верность ссылки")
    }
  internal enum Error {
    /// Отмена
    internal static let cancel = L10n.tr("Localizable", "Error.cancel", fallback: "Отмена")
    /// Произошла ошибка сети
    internal static let network = L10n.tr("Localizable", "Error.network", fallback: "Произошла ошибка сети")
    /// Повторить
    internal static let `repeat` = L10n.tr("Localizable", "Error.repeat", fallback: "Повторить")
    /// Ошибка
    internal static let title = L10n.tr("Localizable", "Error.title", fallback: "Ошибка")
    /// Произошла неизвестная ошибка
    internal static let unknown = L10n.tr("Localizable", "Error.unknown", fallback: "Произошла неизвестная ошибка")
  }
  internal enum Tab {
    /// Localizable.strings
    ///   FakeNFT
    /// 
    ///   Created by admin on 18.04.2024.
    internal static let catalog = L10n.tr("Localizable", "Tab.catalog", fallback: "Каталог")
  }
  internal enum Catalog {
    /// Закрыть
    internal static let close = L10n.tr("Localizable", "catalog.Close", fallback: "Закрыть")
    /// Открыть Nft
    internal static let openNft = L10n.tr("Localizable", "catalog.openNft", fallback: "Открыть Nft")
    /// По названию
    internal static let sortByName = L10n.tr("Localizable", "catalog.SortByName", fallback: "По названию")
    /// По количеству NFT
    internal static let sortByNFTCount = L10n.tr("Localizable", "catalog.SortByNFTCount", fallback: "По количеству NFT")
    /// Cортировка
    internal static let sorting = L10n.tr("Localizable", "catalog.Sorting", fallback: "Cортировка")
    internal enum Collection {
      /// Автор коллекции:
      internal static let aboutAuthor = L10n.tr("Localizable", "catalog.collection.AboutAuthor", fallback: "Автор коллекции:")
    }
  }
  internal enum OnBoarding {
    /// Присоединяйтесь и откройте новый мир
    /// уникальных NFT для коллекционеров
    internal static let firstDescription = L10n.tr("Localizable", "onBoarding.firstDescription", fallback: "Присоединяйтесь и откройте новый мир\nуникальных NFT для коллекционеров")
    /// Исследуйте
    internal static let firstHeader = L10n.tr("Localizable", "onBoarding.firstHeader", fallback: "Исследуйте")
    /// Что внутри?
    internal static let onboardingButton = L10n.tr("Localizable", "onBoarding.onboardingButton", fallback: "Что внутри?")
    /// Пополняйте свою коллекцию эксклюзивными
    /// картинками, созданными нейросетью!
    internal static let secondDescription = L10n.tr("Localizable", "onBoarding.secondDescription", fallback: "Пополняйте свою коллекцию эксклюзивными\nкартинками, созданными нейросетью!")
    /// Коллекционируйте
    internal static let secondHeader = L10n.tr("Localizable", "onBoarding.secondHeader", fallback: "Коллекционируйте")
    /// Смотрите статистику других и покажите всем,
    /// что у вас самая ценная коллекция
    internal static let thirdDescription = L10n.tr("Localizable", "onBoarding.thirdDescription", fallback: "Смотрите статистику других и покажите всем,\nчто у вас самая ценная коллекция")
    /// Состязайтесь
    internal static let thirdHeader = L10n.tr("Localizable", "onBoarding.thirdHeader", fallback: "Состязайтесь")
  }
  internal enum TabBar {
    /// Корзина
    internal static let cartTabBarTitle = L10n.tr("Localizable", "tabBar.cartTabBarTitle", fallback: "Корзина")
    /// Каталог
    internal static let catalogTabBarTitle = L10n.tr("Localizable", "tabBar.catalogTabBarTitle", fallback: "Каталог")
    /// Профиль
    internal static let profileTabBarTitle = L10n.tr("Localizable", "tabBar.profileTabBarTitle", fallback: "Профиль")
    /// Статистика
    internal static let statisticTabBarTitle = L10n.tr("Localizable", "tabBar.statisticTabBarTitle", fallback: "Статистика")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
