// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DbContainerData extends DataClass implements Insertable<DbContainerData> {
  final int id;
  final String uniqueId;
  final String title;
  final String description;
  final String date;
  DbContainerData(
      {required this.id,
      required this.uniqueId,
      required this.title,
      required this.description,
      required this.date});
  factory DbContainerData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbContainerData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      date: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unique_id'] = Variable<String>(uniqueId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<String>(date);
    return map;
  }

  DbContainerCompanion toCompanion(bool nullToAbsent) {
    return DbContainerCompanion(
      id: Value(id),
      uniqueId: Value(uniqueId),
      title: Value(title),
      description: Value(description),
      date: Value(date),
    );
  }

  factory DbContainerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbContainerData(
      id: serializer.fromJson<int>(json['id']),
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uniqueId': serializer.toJson<String>(uniqueId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<String>(date),
    };
  }

  DbContainerData copyWith(
          {int? id,
          String? uniqueId,
          String? title,
          String? description,
          String? date}) =>
      DbContainerData(
        id: id ?? this.id,
        uniqueId: uniqueId ?? this.uniqueId,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DbContainerData(')
          ..write('id: $id, ')
          ..write('uniqueId: $uniqueId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uniqueId, title, description, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbContainerData &&
          other.id == this.id &&
          other.uniqueId == this.uniqueId &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date);
}

class DbContainerCompanion extends UpdateCompanion<DbContainerData> {
  final Value<int> id;
  final Value<String> uniqueId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> date;
  const DbContainerCompanion({
    this.id = const Value.absent(),
    this.uniqueId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
  });
  DbContainerCompanion.insert({
    this.id = const Value.absent(),
    required String uniqueId,
    required String title,
    required String description,
    required String date,
  })  : uniqueId = Value(uniqueId),
        title = Value(title),
        description = Value(description),
        date = Value(date);
  static Insertable<DbContainerData> custom({
    Expression<int>? id,
    Expression<String>? uniqueId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uniqueId != null) 'unique_id': uniqueId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
    });
  }

  DbContainerCompanion copyWith(
      {Value<int>? id,
      Value<String>? uniqueId,
      Value<String>? title,
      Value<String>? description,
      Value<String>? date}) {
    return DbContainerCompanion(
      id: id ?? this.id,
      uniqueId: uniqueId ?? this.uniqueId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbContainerCompanion(')
          ..write('id: $id, ')
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
  final GeneratedDatabase _db;
  final String? _alias;
  $DbContainerTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uniqueId, title, description, date];
  @override
  String get aliasedName => _alias ?? 'db_container';
  @override
  String get actualTableName => 'db_container';
  @override
  VerificationContext validateIntegrity(Insertable<DbContainerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
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
    } else if (isInserting) {
      context.missing(_descriptionMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbContainerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbContainerData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbContainerTable createAlias(String alias) {
    return $DbContainerTable(_db, alias);
  }
}

class DbItemData extends DataClass implements Insertable<DbItemData> {
  final int id;
  final String uniqueId;
  final int? container;
  final String title;
  final String description;
  final String date;
  DbItemData(
      {required this.id,
      required this.uniqueId,
      this.container,
      required this.title,
      required this.description,
      required this.date});
  factory DbItemData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbItemData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      container: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}container']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      date: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unique_id'] = Variable<String>(uniqueId);
    if (!nullToAbsent || container != null) {
      map['container'] = Variable<int?>(container);
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<String>(date);
    return map;
  }

  DbItemCompanion toCompanion(bool nullToAbsent) {
    return DbItemCompanion(
      id: Value(id),
      uniqueId: Value(uniqueId),
      container: container == null && nullToAbsent
          ? const Value.absent()
          : Value(container),
      title: Value(title),
      description: Value(description),
      date: Value(date),
    );
  }

  factory DbItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbItemData(
      id: serializer.fromJson<int>(json['id']),
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      container: serializer.fromJson<int?>(json['container']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uniqueId': serializer.toJson<String>(uniqueId),
      'container': serializer.toJson<int?>(container),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<String>(date),
    };
  }

  DbItemData copyWith(
          {int? id,
          String? uniqueId,
          int? container,
          String? title,
          String? description,
          String? date}) =>
      DbItemData(
        id: id ?? this.id,
        uniqueId: uniqueId ?? this.uniqueId,
        container: container ?? this.container,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DbItemData(')
          ..write('id: $id, ')
          ..write('uniqueId: $uniqueId, ')
          ..write('container: $container, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uniqueId, container, title, description, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbItemData &&
          other.id == this.id &&
          other.uniqueId == this.uniqueId &&
          other.container == this.container &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date);
}

class DbItemCompanion extends UpdateCompanion<DbItemData> {
  final Value<int> id;
  final Value<String> uniqueId;
  final Value<int?> container;
  final Value<String> title;
  final Value<String> description;
  final Value<String> date;
  const DbItemCompanion({
    this.id = const Value.absent(),
    this.uniqueId = const Value.absent(),
    this.container = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
  });
  DbItemCompanion.insert({
    this.id = const Value.absent(),
    required String uniqueId,
    this.container = const Value.absent(),
    required String title,
    required String description,
    required String date,
  })  : uniqueId = Value(uniqueId),
        title = Value(title),
        description = Value(description),
        date = Value(date);
  static Insertable<DbItemData> custom({
    Expression<int>? id,
    Expression<String>? uniqueId,
    Expression<int?>? container,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uniqueId != null) 'unique_id': uniqueId,
      if (container != null) 'container': container,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
    });
  }

  DbItemCompanion copyWith(
      {Value<int>? id,
      Value<String>? uniqueId,
      Value<int?>? container,
      Value<String>? title,
      Value<String>? description,
      Value<String>? date}) {
    return DbItemCompanion(
      id: id ?? this.id,
      uniqueId: uniqueId ?? this.uniqueId,
      container: container ?? this.container,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (container.present) {
      map['container'] = Variable<int?>(container.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbItemCompanion(')
          ..write('id: $id, ')
          ..write('uniqueId: $uniqueId, ')
          ..write('container: $container, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DbItemTable extends DbItem with TableInfo<$DbItemTable, DbItemData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DbItemTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _containerMeta = const VerificationMeta('container');
  @override
  late final GeneratedColumn<int?> container = GeneratedColumn<int?>(
      'container', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES db_container (unique_id)');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uniqueId, container, title, description, date];
  @override
  String get aliasedName => _alias ?? 'db_item';
  @override
  String get actualTableName => 'db_item';
  @override
  VerificationContext validateIntegrity(Insertable<DbItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueIdMeta);
    }
    if (data.containsKey('container')) {
      context.handle(_containerMeta,
          container.isAcceptableOrUnknown(data['container']!, _containerMeta));
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
    } else if (isInserting) {
      context.missing(_descriptionMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbItemData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbItemTable createAlias(String alias) {
    return $DbItemTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $DbContainerTable dbContainer = $DbContainerTable(this);
  late final $DbItemTable dbItem = $DbItemTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbContainer, dbItem];
}
