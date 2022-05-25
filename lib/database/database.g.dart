// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class DbIndexData extends DataClass implements Insertable<DbIndexData> {
  final String uniqueId;
  final int type;
  DbIndexData({required this.uniqueId, required this.type});
  factory DbIndexData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbIndexData(
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unique_id'] = Variable<String>(uniqueId);
    map['type'] = Variable<int>(type);
    return map;
  }

  DbIndexCompanion toCompanion(bool nullToAbsent) {
    return DbIndexCompanion(
      uniqueId: Value(uniqueId),
      type: Value(type),
    );
  }

  factory DbIndexData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbIndexData(
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uniqueId': serializer.toJson<String>(uniqueId),
      'type': serializer.toJson<int>(type),
    };
  }

  DbIndexData copyWith({String? uniqueId, int? type}) => DbIndexData(
        uniqueId: uniqueId ?? this.uniqueId,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('DbIndexData(')
          ..write('uniqueId: $uniqueId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uniqueId, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbIndexData &&
          other.uniqueId == this.uniqueId &&
          other.type == this.type);
}

class DbIndexCompanion extends UpdateCompanion<DbIndexData> {
  final Value<String> uniqueId;
  final Value<int> type;
  const DbIndexCompanion({
    this.uniqueId = const Value.absent(),
    this.type = const Value.absent(),
  });
  DbIndexCompanion.insert({
    required String uniqueId,
    required int type,
  })  : uniqueId = Value(uniqueId),
        type = Value(type);
  static Insertable<DbIndexData> custom({
    Expression<String>? uniqueId,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (type != null) 'type': type,
    });
  }

  DbIndexCompanion copyWith({Value<String>? uniqueId, Value<int>? type}) {
    return DbIndexCompanion(
      uniqueId: uniqueId ?? this.uniqueId,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbIndexCompanion(')
          ..write('uniqueId: $uniqueId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $DbIndexTable extends DbIndex with TableInfo<$DbIndexTable, DbIndexData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbIndexTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [uniqueId, type];
  @override
  String get aliasedName => _alias ?? 'db_index';
  @override
  String get actualTableName => 'db_index';
  @override
  VerificationContext validateIntegrity(Insertable<DbIndexData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uniqueId};
  @override
  DbIndexData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbIndexData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbIndexTable createAlias(String alias) {
    return $DbIndexTable(attachedDatabase, alias);
  }
}

class DbContainerData extends DataClass implements Insertable<DbContainerData> {
  final String uniqueId;
  final String title;
  final String? description;
  final String date;
  DbContainerData(
      {required this.uniqueId,
      required this.title,
      this.description,
      required this.date});
  factory DbContainerData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbContainerData(
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      date: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unique_id'] = Variable<String>(uniqueId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    map['date'] = Variable<String>(date);
    return map;
  }

  DbContainerCompanion toCompanion(bool nullToAbsent) {
    return DbContainerCompanion(
      uniqueId: Value(uniqueId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
    );
  }

  factory DbContainerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbContainerData(
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uniqueId': serializer.toJson<String>(uniqueId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<String>(date),
    };
  }

  DbContainerData copyWith(
          {String? uniqueId,
          String? title,
          String? description,
          String? date}) =>
      DbContainerData(
        uniqueId: uniqueId ?? this.uniqueId,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DbContainerData(')
          ..write('uniqueId: $uniqueId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uniqueId, title, description, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbContainerData &&
          other.uniqueId == this.uniqueId &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date);
}

class DbContainerCompanion extends UpdateCompanion<DbContainerData> {
  final Value<String> uniqueId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> date;
  const DbContainerCompanion({
    this.uniqueId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
  });
  DbContainerCompanion.insert({
    required String uniqueId,
    required String title,
    this.description = const Value.absent(),
    required String date,
  })  : uniqueId = Value(uniqueId),
        title = Value(title),
        date = Value(date);
  static Insertable<DbContainerData> custom({
    Expression<String>? uniqueId,
    Expression<String>? title,
    Expression<String?>? description,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
    });
  }

  DbContainerCompanion copyWith(
      {Value<String>? uniqueId,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? date}) {
    return DbContainerCompanion(
      uniqueId: uniqueId ?? this.uniqueId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbContainerCompanion(')
          ..write('uniqueId: $uniqueId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DbContainerTable extends DbContainer
    with TableInfo<$DbContainerTable, DbContainerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbContainerTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES db_index (unique_id)');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [uniqueId, title, description, date];
  @override
  String get aliasedName => _alias ?? 'db_container';
  @override
  String get actualTableName => 'db_container';
  @override
  VerificationContext validateIntegrity(Insertable<DbContainerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uniqueId};
  @override
  DbContainerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbContainerData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbContainerTable createAlias(String alias) {
    return $DbContainerTable(attachedDatabase, alias);
  }
}

class DbItemData extends DataClass implements Insertable<DbItemData> {
  final String uniqueId;
  final String title;
  final String? description;
  final String date;
  DbItemData(
      {required this.uniqueId,
      required this.title,
      this.description,
      required this.date});
  factory DbItemData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbItemData(
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      date: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unique_id'] = Variable<String>(uniqueId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    map['date'] = Variable<String>(date);
    return map;
  }

  DbItemCompanion toCompanion(bool nullToAbsent) {
    return DbItemCompanion(
      uniqueId: Value(uniqueId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
    );
  }

  factory DbItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbItemData(
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uniqueId': serializer.toJson<String>(uniqueId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<String>(date),
    };
  }

  DbItemData copyWith(
          {String? uniqueId,
          String? title,
          String? description,
          String? date}) =>
      DbItemData(
        uniqueId: uniqueId ?? this.uniqueId,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DbItemData(')
          ..write('uniqueId: $uniqueId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uniqueId, title, description, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbItemData &&
          other.uniqueId == this.uniqueId &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date);
}

class DbItemCompanion extends UpdateCompanion<DbItemData> {
  final Value<String> uniqueId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> date;
  const DbItemCompanion({
    this.uniqueId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
  });
  DbItemCompanion.insert({
    required String uniqueId,
    required String title,
    this.description = const Value.absent(),
    required String date,
  })  : uniqueId = Value(uniqueId),
        title = Value(title),
        date = Value(date);
  static Insertable<DbItemData> custom({
    Expression<String>? uniqueId,
    Expression<String>? title,
    Expression<String?>? description,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
    });
  }

  DbItemCompanion copyWith(
      {Value<String>? uniqueId,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? date}) {
    return DbItemCompanion(
      uniqueId: uniqueId ?? this.uniqueId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbItemCompanion(')
          ..write('uniqueId: $uniqueId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DbItemTable extends DbItem with TableInfo<$DbItemTable, DbItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbItemTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES db_index (unique_id)');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [uniqueId, title, description, date];
  @override
  String get aliasedName => _alias ?? 'db_item';
  @override
  String get actualTableName => 'db_item';
  @override
  VerificationContext validateIntegrity(Insertable<DbItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uniqueId};
  @override
  DbItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbItemData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbItemTable createAlias(String alias) {
    return $DbItemTable(attachedDatabase, alias);
  }
}

class DbLocationData extends DataClass implements Insertable<DbLocationData> {
  final String uniqueId;
  final String? objectId;
  final String? insideId;
  final String date;
  DbLocationData(
      {required this.uniqueId,
      this.objectId,
      this.insideId,
      required this.date});
  factory DbLocationData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbLocationData(
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      objectId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}object_id']),
      insideId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}inside_id']),
      date: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unique_id'] = Variable<String>(uniqueId);
    if (!nullToAbsent || objectId != null) {
      map['object_id'] = Variable<String?>(objectId);
    }
    if (!nullToAbsent || insideId != null) {
      map['inside_id'] = Variable<String?>(insideId);
    }
    map['date'] = Variable<String>(date);
    return map;
  }

  DbLocationCompanion toCompanion(bool nullToAbsent) {
    return DbLocationCompanion(
      uniqueId: Value(uniqueId),
      objectId: objectId == null && nullToAbsent
          ? const Value.absent()
          : Value(objectId),
      insideId: insideId == null && nullToAbsent
          ? const Value.absent()
          : Value(insideId),
      date: Value(date),
    );
  }

  factory DbLocationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbLocationData(
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      objectId: serializer.fromJson<String?>(json['objectId']),
      insideId: serializer.fromJson<String?>(json['insideId']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uniqueId': serializer.toJson<String>(uniqueId),
      'objectId': serializer.toJson<String?>(objectId),
      'insideId': serializer.toJson<String?>(insideId),
      'date': serializer.toJson<String>(date),
    };
  }

  DbLocationData copyWith(
          {String? uniqueId,
          String? objectId,
          String? insideId,
          String? date}) =>
      DbLocationData(
        uniqueId: uniqueId ?? this.uniqueId,
        objectId: objectId ?? this.objectId,
        insideId: insideId ?? this.insideId,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DbLocationData(')
          ..write('uniqueId: $uniqueId, ')
          ..write('objectId: $objectId, ')
          ..write('insideId: $insideId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uniqueId, objectId, insideId, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbLocationData &&
          other.uniqueId == this.uniqueId &&
          other.objectId == this.objectId &&
          other.insideId == this.insideId &&
          other.date == this.date);
}

class DbLocationCompanion extends UpdateCompanion<DbLocationData> {
  final Value<String> uniqueId;
  final Value<String?> objectId;
  final Value<String?> insideId;
  final Value<String> date;
  const DbLocationCompanion({
    this.uniqueId = const Value.absent(),
    this.objectId = const Value.absent(),
    this.insideId = const Value.absent(),
    this.date = const Value.absent(),
  });
  DbLocationCompanion.insert({
    required String uniqueId,
    this.objectId = const Value.absent(),
    this.insideId = const Value.absent(),
    required String date,
  })  : uniqueId = Value(uniqueId),
        date = Value(date);
  static Insertable<DbLocationData> custom({
    Expression<String>? uniqueId,
    Expression<String?>? objectId,
    Expression<String?>? insideId,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (objectId != null) 'object_id': objectId,
      if (insideId != null) 'inside_id': insideId,
      if (date != null) 'date': date,
    });
  }

  DbLocationCompanion copyWith(
      {Value<String>? uniqueId,
      Value<String?>? objectId,
      Value<String?>? insideId,
      Value<String>? date}) {
    return DbLocationCompanion(
      uniqueId: uniqueId ?? this.uniqueId,
      objectId: objectId ?? this.objectId,
      insideId: insideId ?? this.insideId,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<String?>(objectId.value);
    }
    if (insideId.present) {
      map['inside_id'] = Variable<String?>(insideId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbLocationCompanion(')
          ..write('uniqueId: $uniqueId, ')
          ..write('objectId: $objectId, ')
          ..write('insideId: $insideId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DbLocationTable extends DbLocation
    with TableInfo<$DbLocationTable, DbLocationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbLocationTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _objectIdMeta = const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<String?> objectId = GeneratedColumn<String?>(
      'object_id', aliasedName, true,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES db_index (unique_id)');
  final VerificationMeta _insideIdMeta = const VerificationMeta('insideId');
  @override
  late final GeneratedColumn<String?> insideId = GeneratedColumn<String?>(
      'inside_id', aliasedName, true,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES db_index (unique_id)');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [uniqueId, objectId, insideId, date];
  @override
  String get aliasedName => _alias ?? 'db_location';
  @override
  String get actualTableName => 'db_location';
  @override
  VerificationContext validateIntegrity(Insertable<DbLocationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueIdMeta);
    }
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    }
    if (data.containsKey('inside_id')) {
      context.handle(_insideIdMeta,
          insideId.isAcceptableOrUnknown(data['inside_id']!, _insideIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uniqueId};
  @override
  DbLocationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbLocationData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbLocationTable createAlias(String alias) {
    return $DbLocationTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $DbIndexTable dbIndex = $DbIndexTable(this);
  late final $DbContainerTable dbContainer = $DbContainerTable(this);
  late final $DbItemTable dbItem = $DbItemTable(this);
  late final $DbLocationTable dbLocation = $DbLocationTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dbIndex, dbContainer, dbItem, dbLocation];
}
