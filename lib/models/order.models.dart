enum OrderFieldOption{
  NAME,
  RATING,
  DATE,
  UPDATEDDATE
}
enum OrderDirectionOption{
  ASC,
  DESC
}

class OrderField{
  final OrderFieldOption key;
  final String value;
  OrderField(this.key, this.value);
}
class OrderDirection{
  final OrderDirectionOption key;
  final String value;
  OrderDirection(this.key, this.value);
}