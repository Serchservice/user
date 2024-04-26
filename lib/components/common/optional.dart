import 'package:user/library.dart';

class Optional<T> {
  final T? _value;
  final List<T> _values;

  const Optional._internal(this._value, this._values);

  factory Optional.empty() {
    return const Optional._internal(null, []);
  }

  factory Optional.of(T value) {
    if (value == null) {
      throw SerchException("$T cannot be null");
    }
    return Optional._internal(value, []);
  }

  factory Optional.ofList(List<T> values) {
    if (values.isEmpty) {
      throw SerchException("$values cannot be null or empty");
    }
    return Optional._internal(null as T, values);
  }

  factory Optional.ofNullable(T value) {
    return Optional._internal(value, []);
  }

  T get() {
    if (_value == null) {
      throw SerchException('$T is not present');
    }
    return _value;
  }

  bool isPresent() {
    return _value != null;
  }

  void ifPresent(void Function(T value) consumer) {
    if (isPresent()) {
      consumer(_value as T);
    }
  }

  void ifPresentInList(void Function(T value) consumer) {
    _values.forEach(consumer);
  }

  Optional<T> filter(bool Function(T value) predicate) {
    return isPresent() && predicate(_value as T) ? this : Optional.empty();
  }

  List<U> mapToList<U>(U Function(T value) mapper) {
    return _values.map(mapper).toList();
  }

  List<T> filterList(bool Function(T value) predicate) {
    return _values.where(predicate).toList();
  }

  Optional<U> map<U>(U Function(T value) mapper) {
    return isPresent() ? Optional.ofNullable(mapper(_value as T)) : Optional.empty();
  }

  Optional<U> flatMap<U>(Optional<U> Function(T value) mapper) {
    return isPresent() ? mapper(_value as T) : Optional.empty();
  }

  T orElse(T other) {
    return _value ?? other;
  }

  T orElseGet(T Function() other) {
    return _value ?? other();
  }

  T orElseThrow(Object Function() exceptionSupplier) {
    if (isPresent()) {
      return _value as T;
    } else {
      throw exceptionSupplier();
    }
  }

  void ifPresentOrElse(void Function(T value) ifPresentCallback, void Function() elseCallback) {
    if (_value != null) {
      ifPresentCallback(_value as T);
    } else {
      elseCallback();
    }
  }

  void ifPresentInListOrElse(void Function(T value) ifPresentCallback, void Function() elseCallback) {
    if (_values.isNotEmpty) {
      _values.forEach(ifPresentCallback);
    } else {
      elseCallback();
    }
  }

  T firstIf(bool Function(T value) condition) {
    if (_values.isNotEmpty) {
      for(var item in _values) {
        if (condition(item)) {
          return item;
        }
      }
    }
    return orElseThrow(() => SerchException("$condition item is not in list"));
  }

  @override
  bool operator == (Object other) =>
    identical(this, other) || other is Optional && runtimeType == other.runtimeType && (
      _value == other._value || (_value != null && _value == other._value)
    );

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return isPresent() ? 'Optional[$_value]' : 'Optional.empty';
  }
}