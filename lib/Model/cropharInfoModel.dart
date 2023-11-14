class CropInformation {
  String selectedcrop;
  String quantity;
  String slctCrop;
  String slctVty;
  String slctGrade;
  String valCrop;
  String valVrt;
  String valGrade;

  CropInformation(this.selectedcrop, this.quantity, this.slctCrop, this.slctVty,
      this.slctGrade, this.valCrop, this.valVrt, this.valGrade);

  Map<String, dynamic> toMap() {
    return {
      'selectedcrop': selectedcrop,
      'Quantity': quantity,
      'Crop': slctCrop,
      'Variety': slctVty,
      'Grade': slctGrade,
      'valCrop': valCrop,
      'valVrt': valVrt,
      'valGrade': valGrade,
    };
  }
}
