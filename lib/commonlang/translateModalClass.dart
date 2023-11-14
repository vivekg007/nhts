import 'dart:convert';



class LanguageModal {
  String? className;
  String? labelName;

  LanguageModal({
    this.className,
    this.labelName,
  });

  factory LanguageModal.fromMap(Map<String, dynamic> json) => new LanguageModal(
    className: json["className"],
    labelName: json["labelName"],
  );

  Map<String, dynamic> toMap() => {
    "className": className,
    "labelName": labelName,
  };
}