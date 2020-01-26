enum TerritoryStates {
  Black, White, Unknown, None, ProbablyBlack, ProbablyWhite, WhiteTerritory, BlackTerritory, Verified
}
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

T decodeTerritory<T>(
    Map<T, dynamic> enumValues,
    dynamic source, {
      T unknownValue,
    }) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const territoryMap = {
  TerritoryStates.Black: 'Black',
  TerritoryStates.White: 'White',
  TerritoryStates.Unknown: 'Unknown',
  TerritoryStates.None: 'None',
  TerritoryStates.ProbablyBlack: 'ProbablyBlack',
  TerritoryStates.ProbablyWhite: 'ProbablyWhite',
  TerritoryStates.WhiteTerritory: 'WhiteTerritory',
  TerritoryStates.BlackTerritory: 'BlackTerritory',
  TerritoryStates.Verified: 'Verified',


};