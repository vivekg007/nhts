class Quantityproductsmodel{
  int quantity;
  int price;
  int amount;
  String productName;
  String val_Farmermobile;
  String village;
  String farmernameController;
  String mobilenumberController;
  String distributionDate;
  String freeDistribution;
  String farmerCode;

  Quantityproductsmodel(
      this.quantity,
      this.price,
      this.amount,
      this.productName,
      this.val_Farmermobile,
      this.village,
      this.farmernameController,
      this.mobilenumberController,
      this.distributionDate,
      this.freeDistribution,
      this.farmerCode);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["quantity"] = quantity;
    map["price"] = price;
    map["amount"] = amount;
    map["productName"] = productName;
    map["farmerId"] = val_Farmermobile;
    map["village"] = village;
    map["farmerName"] = farmernameController;
    map["mobileNo"] = mobilenumberController;
    map["distributionDate"] = distributionDate;
    map["freeDistribution"] = freeDistribution;
    map["farmerCode"] = farmerCode;
    return map;
  }
}