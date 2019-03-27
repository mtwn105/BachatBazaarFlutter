import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productID;
  String productDescShort;
  bool productFeatured;
  String productImage;
  int productMinPrice;
  int productMinStock;
  String productName;
  bool productOffer;
  int productOfferPrice;
  int productPrice;
  String productSellerId;
  int productStock;
  String productSellerName;
  String productCategoryId;
  String productDesc;
  String productCategoryName;
  Product(
      {this.productID,this.productDescShort,
      this.productFeatured,
      this.productImage,
      this.productMinPrice,
      this.productMinStock,
      this.productName,
      this.productOffer,
      this.productOfferPrice,
      this.productPrice,
      this.productSellerId,
      this.productStock,
      this.productSellerName,
      this.productCategoryId,
      this.productDesc,
      this.productCategoryName});

  Product.fromJson(Map<dynamic, dynamic> json) {
    productID = json['product_id'];
    productDescShort = json['product_desc_short'];
    productFeatured = json['product_featured'];
    productImage = json['product_image'];
    productMinPrice = json['product_min_price'];
    productMinStock = json['product_min_stock'];
    productName = json['product_name'];
    productOffer = json['product_offer'];
    productOfferPrice = json['product_offer_price'];
    productPrice = json['product_price'];
    productSellerId = json['product_seller_id'];
    productStock = json['product_stock'];
    productSellerName = json['product_seller_name'];
    productCategoryId = json['product_category_id'];
    productDesc = json['product_desc'];
    productCategoryName = json['product_category_name'];
  }

  Product.fromDocument(DocumentSnapshot document) {
    productID = document['product_id'];
    productDescShort = document['product_desc_short'];
    productFeatured = document['product_featured'];
    productImage = document['product_image'];
    productMinPrice = document['product_min_price'];
    productMinStock = document['product_min_stock'];
    productName = document['product_name'];
    productOffer = document['product_offer'];
    productOfferPrice = document['product_offer_price'];
    productPrice = document['product_price'];
    productSellerId = document['product_seller_id'];
    productStock = document['product_stock'];
    productSellerName = document['product_seller_name'];
    productCategoryId = document['product_category_id'];
    productDesc = document['product_desc'];
    productCategoryName = document['product_category_name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_desc_short'] = this.productDescShort;
    data['product_featured'] = this.productFeatured;
    data['product_image'] = this.productImage;
    data['product_min_price'] = this.productMinPrice;
    data['product_min_stock'] = this.productMinStock;
    data['product_name'] = this.productName;
    data['product_offer'] = this.productOffer;
    data['product_offer_price'] = this.productOfferPrice;
    data['product_price'] = this.productPrice;
    data['product_seller_id'] = this.productSellerId;
    data['product_stock'] = this.productStock;
    data['product_seller_name'] = this.productSellerName;
    data['product_category_id'] = this.productCategoryId;
    data['product_desc'] = this.productDesc;
    data['product_category_name'] = this.productCategoryName;
    data['product_id'] = this.productID;
    return data;
  }
}
