class ProductTransferModel {
  String transferDate;
  String prosCentreWhId;
  String prosCentreWh;
  String trckNumber;
  String driverName;
  String groupNameId;
  String groupName;
  String farmerId;
  String farmerName;
  String varietyId;
  String variety;
  String grade;
  String productId;
  String product;
  String avlNoOfBoxBags;
  String avlNetWgtKgs;
  String transNoOfBoxBags;
  String transNetWgtKgs;
  bool edited;

  ProductTransferModel(
      this.transferDate,
      this.prosCentreWhId,
      this.prosCentreWh,
      this.trckNumber,
      this.driverName,
      this.groupNameId,
      this.groupName,
      this.farmerId,
      this.farmerName,
      this.varietyId,
      this.variety,
      this.grade,
      this.productId,
      this.product,
      this.avlNoOfBoxBags,
      this.avlNetWgtKgs,
      this.transNoOfBoxBags,
      this.transNetWgtKgs,
      this.edited);
}
