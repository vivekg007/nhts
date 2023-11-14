class DistributionProductDetail {
  String? price;
  String? subtotal;
  String? quantity;
  String? productid;
  String? distributionId;
  String? sellPrice;
  String? Batchno;

  DistributionProductDetail(this.price, this.subtotal, this.quantity,
      this.productid, this.distributionId, this.sellPrice, this.Batchno);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["price"] = price;
    map["subtotal"] = subtotal;
    map["quantity"] = quantity;
    map["productid"] = productid;
    map["distributionId"] = distributionId;
    map["sellPrice"] = sellPrice;
    map["bactNo"] = Batchno;

    return map;
  }
}
