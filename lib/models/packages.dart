import 'package:intl/intl.dart';

enum PackType {
  normal,
  halfYear,
  annual,
  redSandal;

  String toApiString() {
    switch (this) {
      case PackType.normal:
        return 'NORMAL';
      case PackType.halfYear:
        return 'HALF_YEAR';
      case PackType.annual:
        return 'ANNUAL';
      case PackType.redSandal:
        return 'RED_SANDAL';
    }
  }

  static PackType fromApiString(String val) {
    switch (val) {
      case 'NORMAL':
        return PackType.normal;
      case 'HALF_YEAR':
        return PackType.halfYear;
      case 'ANNUAL':
        return PackType.annual;
      case 'RED_SANDAL':
        return PackType.redSandal;
      default:
        return PackType.normal;
    }
  }
}

class PackageConfig {
  final String label;
  final int soapsPerBox;
  final int pricePerBox;
  final int? mrpPerBox;
  final bool isKit;
  final String emoji;
  final bool highlight;
  final String? tag;
  final String description;

  const PackageConfig({
    required this.label,
    required this.soapsPerBox,
    required this.pricePerBox,
    this.mrpPerBox,
    required this.isKit,
    required this.emoji,
    required this.highlight,
    this.tag,
    required this.description,
  });
}

const Map<PackType, PackageConfig> packConfig = {
  PackType.normal: PackageConfig(
    label: 'Starter Pack',
    soapsPerBox: 1,
    pricePerBox: 300,
    mrpPerBox: null,
    isKit: false,
    emoji: '📦',
    highlight: false,
    description: 'Perfect for trying out',
  ),
  PackType.halfYear: PackageConfig(
    label: 'Value Pack',
    soapsPerBox: 3,
    pricePerBox: 600,
    mrpPerBox: 900,
    isKit: false,
    emoji: '⭐',
    highlight: false,
    description: 'Great value — 3 premium soaps',
  ),
  PackType.annual: PackageConfig(
    label: 'Bumper Pack',
    soapsPerBox: 6,
    pricePerBox: 900,
    mrpPerBox: 1800,
    isKit: false,
    emoji: '🎉',
    highlight: true,
    tag: 'BEST OFFER',
    description: 'Maximum savings — 6 premium soaps',
  ),
  PackType.redSandal: PackageConfig(
    label: 'Red Sandal Premium Kit',
    soapsPerBox: 14,
    pricePerBox: 50000,
    mrpPerBox: null,
    isKit: true,
    emoji: '🌿',
    highlight: false,
    description: '14 premium products in one kit',
  ),
};

class PackageDetails {
  final String label;
  final int soaps;
  final int price;
  final int? mrp;
  final int savings;
  final bool isKit;

  PackageDetails({
    required this.label,
    required this.soaps,
    required this.price,
    this.mrp,
    required this.savings,
    required this.isKit,
  });
}

PackageDetails getPackageDetails(int qty, PackType packType) {
  final cfg = packConfig[packType]!;
  final count = qty > 0 ? qty : 1;

  if (cfg.isKit) {
    return PackageDetails(
      label: cfg.label,
      soaps: cfg.soapsPerBox * count,
      price: cfg.pricePerBox * count,
      mrp: null,
      savings: 0,
      isKit: true,
    );
  }

  final price = cfg.pricePerBox * count;
  final mrp = cfg.mrpPerBox != null ? cfg.mrpPerBox! * count : null;
  final savings = mrp != null ? mrp - price : 0;

  return PackageDetails(
    label: cfg.label,
    soaps: cfg.soapsPerBox * count,
    price: price,
    mrp: mrp,
    savings: savings,
    isKit: false,
  );
}

String formatPrice(int amount) {
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  return formatter.format(amount);
}
