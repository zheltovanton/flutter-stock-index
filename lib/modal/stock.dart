
class StockModal {

  String name;
  String val;
  String last;

  StockModal({
    this.last,
    this.name,
    this.val
  });

  StockModal.fromFields(Map<String,dynamic> fields) {
    //fields.forEach((key, value) => print("$key=$value"));
    last = fields["last"].toString();
    name = fields["name"].toString();
    val = fields["val"].toString();
  }
}



