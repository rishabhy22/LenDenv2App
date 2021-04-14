import 'package:se_len_den/Models/Memo.dart';

class MemoResponse {
  String status, error;
  Memo memo;

  MemoResponse.fromJson(Map<String, dynamic> data) {
    this.status = data["status"];
    this.error = data["error"];
    this.memo = Memo.fromJson(data["data"]);
  }

  Map<String, dynamic> toJson() {
    return {"status": this.status, "error": this.error, "memo": this.memo};
  }
}

class JoinMemoResponse {
  String status, error;
  List<Memo> memoList = List<Memo>.empty(growable: true);

  JoinMemoResponse.fromJson(Map<String, dynamic> data) {
    this.status = data["status"];
    this.error = data["error"];
    for (var memoJson in data["data"]) {
      this.memoList.add(Memo.fromJson(memoJson));
    }
    this.memoList.sort((a, b) {
      if (a.sentTime < b.sentTime)
        return -1;
      else
        return 1;
    });
  }
}
