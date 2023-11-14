class inpRetDetModel {
  String productCode;
  String quantity;
  String pricePerUnit;
  String subTotal;
  String batchNo;
  //String returnid;

  inpRetDetModel(
    this.productCode,
    this.quantity,
    this.pricePerUnit,
    this.subTotal,
    this.batchNo,
    //this.returnid,
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["productid"] = productCode;
    map["quantity"] = quantity;
    map["price"] = pricePerUnit;
    map["subtotal"] = subTotal;
    map["batchNo"] = batchNo;
    //map["returnId"] = returnid;
    return map;
  }
}
