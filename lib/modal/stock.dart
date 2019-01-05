
class StockModal {

  String name;
  String val;
  String last;
  String id;

  StockModal({
    this.last,
    this.name,
    this.id,
    this.val
  });

  StockModal.fromFields(Map<String,dynamic> fields) {
    //fields.forEach((key, value) => print("$key=$value"));
    last = fields["last"].toString();
    id = fields["id"].toString();
    name = fields["name"].toString();
    val = fields["val"].toString();
  }
}



