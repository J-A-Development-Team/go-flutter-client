// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPackage _$DataPackageFromJson(Map<String, dynamic> json) {
  return DataPackage(
    json['data'],
    _$enumDecodeNullable(_$InfoEnumMap, json['info']),
  );
}

Map<String, dynamic> _$DataPackageToJson(DataPackage instance) =>
    <String, dynamic>{
      'data': instance.data,
      'info': _$InfoEnumMap[instance.info],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$InfoEnumMap = {
  Info.Stone: 'Stone',
  Info.StoneTable: 'StoneTable',
  Info.PlayerColor: 'PlayerColor',
  Info.InfoMessage: 'InfoMessage',
  Info.Pass: 'Pass',
  Info.Turn: 'Turn',
  Info.Points: 'Points',
  Info.TerritoryTable: 'TerritoryTable',
  Info.GameConfig: 'GameConfig',
  Info.GameResult: 'GameResult',
};
