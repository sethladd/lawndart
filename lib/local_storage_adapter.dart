//Copyright 2012 Seth Ladd
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

part of lawndart;

// TODO: error handling
class LocalStorageAdapter<K extends String, V> extends Store<K, V> {
  Storage storage;
  
  LocalStorageAdapter() {
    storage = window.localStorage;
  }

  Future open() {
    _isOpen = true;
    return new Future.immediate(true);
  }
  
  Future<Iterable<K>> _keys() {
    return _results(storage.keys);
  }
  
  Future _save(V obj, K key) {
    storage[key] = JSON.stringify(obj);
    return _results(true);
  }
  
  Future _batch(Map<K, V> objs) {
    for (var key in objs.keys) {
      var obj = objs[key];
      storage[key] = JSON.stringify(obj);
    }
    return _results(true);
  }
  
  Future<V> _getByKey(K key) {
    return _results(storage[key]);
  }
  
  Future<Iterable<V>> _getByKeys(Iterable<K> _keys) {
    var values = _keys.mappedBy((key) => storage[key]).where((v) => v != null);
    return _results(values);
  }
  
  Future<bool> _exists(K key) {
    return _results(storage[key] != null);
  }
  
  Future<Iterable<V>> _all() {
    return _results(storage.values);
  }
  
  Future<bool> _removeByKey(K key) {
    storage.remove(key);
    return _results(true);
  }
  
  Future<bool> _removeByKeys(Iterable<K> _keys) {
    _keys.forEach((key) => removeByKey(key));
    return _results(true);
  }
  
  Future<bool> _nuke() {
    storage.clear();
    return _results(true);
  }
}