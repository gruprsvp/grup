enum Flavor {
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'AppFor.it (Dev)';
      case Flavor.prod:
        return 'AppFor.it';
      default:
        return 'title';
    }
  }

}
