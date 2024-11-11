class CategoryItem {
  final String title;
  final String image;

  CategoryItem({required this.title, required this.image});
}

List<CategoryItem> categoryList = [
  CategoryItem(title: "Fruits", image: "assets/img/apple.png"),
  CategoryItem(title: "Vegetables", image: "assets/img/broccoli.png"),
  CategoryItem(title: "Diary", image: "assets/img/cheese.png"),
  CategoryItem(title: "Meat", image: "assets/img/meat.png"),
];
