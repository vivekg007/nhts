class ProductSaleModel{
   String? saleDate;
   String? salevillName;
   String? saleFarmerName;
   String? saleFarmName;
   String? buyerName;
   String? prodcrop;
   String? cropType;
   String varietyType;
   String gradeType;
   String batchNo;
   String prodQty;
   String prodprice;
   String prodtotal;
   String txtcroptype;
   String txtvarietytype;
   String txtgradetype;


  ProductSaleModel(this.saleDate, this.salevillName, this.saleFarmerName, this.saleFarmName,  this.buyerName, this.prodcrop, this.cropType, this.varietyType, this.gradeType, this.batchNo, this.prodQty, this.prodprice, this.prodtotal,this.txtcroptype,this.txtvarietytype,this.txtgradetype);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'saleDate': saleDate,
      'saleVillName': salevillName,
      'saleFarmerName': saleFarmerName,
      'saleFarmName': saleFarmName,
      'buyerName': buyerName,
      'productCrop': prodcrop,
      'cropType': cropType,
      'varietyType': varietyType,
      'gradeTpe': gradeType,
      'batchNo': batchNo,
      'salePrice': prodprice,
      'quantity':prodQty ,
      'product_Total': prodtotal,
    };
  }
}