// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
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
  final GeneratedDatabase _db;
  final String? _alias;
  $DbContainerTable(this._db, [this._alias]);
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
    return $DbContainerTable(_db, alias);
  }
}

class DbItemData extends DataClass implements Insertable<DbItemData> {
  final String uniqueId;
  final String? container;
  final String title;
  final String? description;
  final String date;
  DbItemData(
      {required this.uniqueId,
      this.container,
      required this.title,
      this.description,
      required this.date});
  factory DbItemData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbItemData(
      uniqueId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      container: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}container']),
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
    if (!nullToAbsent || container != null) {
      map['container'] = Variable<String?>(container);
    }
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
      container: container == null && nullToAbsent
          ? const Value.absent()
          : Value(container),
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
      container: serializer.fromJson<String?>(json['container']),
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
      'container': serializer.toJson<String?>(container),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<String>(date),
    };
  }

  DbItemData copyWith(
          {String? uniqueId,
          String? container,
          String? title,
          String? description,
          String? date}) =>
      DbItemData(
        uniqueId: uniqueId ?? this.uniqueId,
        container: container ?? this.container,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DbItemData(')
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
      Object.hash(uniqueId, container, title, description, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbItemData &&
          other.uniqueId == this.uniqueId &&
          other.container == this.container &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date);
}

class DbItemCompanion extends UpdateCompanion<DbItemData> {
  final Value<String> uniqueId;
  final Value<String?> container;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> date;
  const DbItemCompanion({
    this.uniqueId = const Value.absent(),
    this.container = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
  });
  DbItemCompanion.insert({
    required String uniqueId,
    this.container = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String date,
  })  : uniqueId = Value(uniqueId),
        title = Value(title),
        date = Value(date);
  static Insertable<DbItemData> custom({
    Expression<String>? uniqueId,
    Expression<String?>? container,
    Expression<String>? title,
    Expression<String?>? description,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (container != null) 'container': container,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
    });
  }

  DbItemCompanion copyWith(
      {Value<String>? uniqueId,
      Value<String?>? container,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? date}) {
    return DbItemCompanion(
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
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (container.present) {
      map['container'] = Variable<String?>(container.value);
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
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String?> uniqueId = GeneratedColumn<String?>(
      'unique_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _containerMeta = const VerificationMeta('container');
  @override
  late final GeneratedColumn<String?> container = GeneratedColumn<String?>(
      'container', aliasedName, true,
      type: const StringType(),
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
      'description', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [uniqueId, container, title, description, date];
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
