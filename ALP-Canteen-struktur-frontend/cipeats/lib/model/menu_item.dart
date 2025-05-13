class MenuItem {
  final String name;
  final String description;
  final String imageUrl;
  final int price;
  final String vendor; // "Chick on Cup" or "Warung AW"
  final bool available;

  MenuItem({
    required this.name,
     required this.description,
    required this.imageUrl,
    required this.price,
    required this.vendor,
    required this.available,
  });
}
