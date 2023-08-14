import 'package:drift/drift.dart';

class Schedules extends Table {
  // id
  IntColumn get id => integer().autoIncrement()();

  // 스케쥴 완료 여부
  BoolColumn get done => boolean()();

  // 스케쥴 내용
  TextColumn get content => text()();

  // 스케쥴 날짜
  DateTimeColumn get date => dateTime()();

  // 작성 날짜
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
