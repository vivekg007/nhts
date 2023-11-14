class TransactionHistoryResponseModel {
    Response? response;

    TransactionHistoryResponseModel({this.response});

    factory TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
        return TransactionHistoryResponseModel(
            response: json['response'] != '' ? Response.fromJson(json['response']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.response != '') {
            data['response'] = this.response!.toJson();
        }
        return data;
    }
}

class Response {
    Body? body;
    Status? status;

    Response({this.body, this.status});

    factory Response.fromJson(Map<String, dynamic> json) {
        return Response(
            body: json['body'] != '' ? Body.fromJson(json['body']) : null,
            status: json['status'] != '' ? Status.fromJson(json['status']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.body != '') {
            data['body'] = this.body!.toJson();
        }
        if (this.status != '') {
            data['status'] = this.status!.toJson();
        }
        return data;
    }
}

class Status {
    String? code;
    String? message;

    Status({this.code, this.message});

    factory Status.fromJson(Map<String, dynamic> json) {
        return Status(
            code: json['code'],
            message: json['message'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['code'] = this.code;
        data['message'] = this.message;
        return data;
    }
}

class Body {
    List<TxnHistory>? txnHistory;

    Body({this.txnHistory});

    factory Body.fromJson(Map<String, dynamic> json) {
        return Body(
            txnHistory: json['txnHistory'] != '' ? (json['txnHistory'] as List).map((i) => TxnHistory.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.txnHistory != '') {
            data['txnHistory'] = this.txnHistory!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class TxnHistory {
    String? txnAmt;
    String? txnTime;
    String? txnType;

    TxnHistory({this.txnAmt, this.txnTime, this.txnType});

    factory TxnHistory.fromJson(Map<String, dynamic> json) {
        return TxnHistory(
            txnAmt: json['txnAmt'],
            txnTime: json['txnTime'],
            txnType: json['txnType'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['txnAmt'] = this.txnAmt;
        data['txnTime'] = this.txnTime;
        data['txnType'] = this.txnType;
        return data;
    }
}