class Coupon {
  final String imageUrl;
  final String title;
  final double discount;
  final String color;

  Coupon(this.imageUrl, this.title, this.discount, this.color);
}

final List<Coupon> couponList = [
  Coupon("assets/img/coupon.png", "Ramadhan Offers", 25, "23AA49"),
  Coupon("assets/img/coupon.png", "Ramadhan Offers", 25, "FF324B"),
  Coupon("assets/img/coupon.png", "Ramadhan Offers", 25, "3E5959"),
];
