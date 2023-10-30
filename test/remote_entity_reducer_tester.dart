import 'package:redux_entity/redux_entity.dart';
import 'package:test/test.dart';

typedef EntityFactory<T> = T Function();

/// A helper that can test reducers derived from RemoteEntityReducer.
///
/// If you are creating your own reducers based on RemoteEntityReducer,
/// it can be a lot of work to get good test coverage. You not only
/// need to test the reducer against your own actions, but also ensure
/// the existing functionality continues to work.
///
/// This class runs tests for RemoteEntityActions on your reducer
/// to ensure it function as expected.
class RemoteEntityReducerTester<R extends RemoteEntityReducer<S, T>,
    S extends RemoteEntityState<T>, T> {
  testAll(
    R reducer,
    EntityFactory<T> generator,
    S initialState,
  ) {
    group(RemoteEntityReducer, () {
      group(RequestCreateOne, () {
        test('Should set creating true', () {
          final result = reducer.call(
            initialState,
            RequestCreateOne<T>(generator()),
          );
          expect(result.creating, true);
        });

        test('Should clear error', () {
          final S result = reducer.call(
            initialState.copyWith(error: 'some error') as S,
            RequestCreateOne<T>(generator()),
          );
          expect(result.error, false);
        });
      });
      group(SuccessCreateOne, () {
        test('item should be added to store', () {
          T entity = generator();
          final result =
              reducer.call(initialState, SuccessCreateOne<T>(entity));
          expect(result.entities[reducer.adapter.getId(entity)], entity);
        });

        test('creating should be false', () {
          final result = reducer.call(
            initialState.copyWith(creating: true) as S,
            SuccessCreateOne<T>(generator()),
          );
          expect(result.creating, false);
        });
      });
      group(FailCreateOne, () {
        test('creating should be false', () {
          final result = reducer.call(
            initialState.copyWith(creating: true) as S,
            FailCreateOne<T>(
              entity: generator(),
              error: 'Some error',
            ),
          );
          expect(result.creating, false);
        });
        test('sets an error', () {
          final result = reducer.call(
            initialState.copyWith(creating: true) as S,
            FailCreateOne<T>(
              entity: generator(),
              error: 'Some error',
            ),
          );
          expect(result.error, 'Some error');
        });
      });

      group(RequestCreateMany, () {
        test('Should set creating true', () {
          final result = reducer.call(
              initialState,
              RequestCreateMany<T>([
                generator(),
                generator(),
                generator(),
              ]));
          expect(result.creating, true);
        });
        test('Should clear error', () {
          final result = reducer.call(
              initialState,
              RequestCreateMany<T>([
                generator(),
                generator(),
                generator(),
              ]));
          expect(result.error, false);
        });
      });
      group(SuccessCreateMany, () {
        test('items should be added to store', () {
          final e1 = generator();
          final e2 = generator();
          final result = reducer.call(
              initialState.copyWith(creating: true) as S,
              SuccessCreateMany<T>([e1, e2]));
          expect(result.entities[reducer.adapter.getId(e1)], e1);
          expect(result.entities[reducer.adapter.getId(e2)], e2);
        });
        test('creating should be false', () {
          final result = reducer.call(
            initialState.copyWith(creating: true) as S,
            SuccessCreateMany<T>(
              [
                generator(),
                generator(),
              ],
            ),
          );
          expect(result.creating, false);
        });
      });
      group(FailCreateMany, () {
        test('creating should be false', () {
          final result = reducer.call(
            initialState.copyWith(creating: true) as S,
            FailCreateMany<T>(entities: [
              generator(),
              generator(),
            ], error: 'error'),
          );
          expect(result.creating, false);
        });
        test('Should set the error', () {
          final result = reducer.call(
            initialState.copyWith(creating: true) as S,
            FailCreateMany<T>(entities: [
              generator(),
              generator(),
            ], error: 'error'),
          );
          expect(result.error, 'error');
        });
      });
    });

    group(RequestRetrieveOne, () {
      test('Should set loading for element true', () {
        final result = reducer.call(
            initialState.copyWith() as S, RequestRetrieveOne<T>('asdf'));
        expect(result.loadingIds['asdf'], true);
      });
      test('Should clear error', () {
        final result = reducer.call(
            initialState.copyWith() as S, RequestRetrieveOne<T>('asdf'));
        expect(result.error, false);
      });
    });
    group(SuccessRetrieveOne, () {
      test('item should be added to store', () {
        final entity = generator();
        final result = reducer.call(
          initialState.copyWith(loadingIds: {'a': true}) as S,
          SuccessRetrieveOne<T>(entity),
        );
        expect(result.entities[reducer.adapter.getId(entity)], entity);
      });

      test('Should set loading for element false', () {
        final entity = generator();
        final result = reducer.call(
          initialState
              .copyWith(loadingIds: {reducer.adapter.getId(entity): true}) as S,
          SuccessRetrieveOne<T>(entity),
        );
        expect(result.loadingIds[reducer.adapter.getId(entity)], false);
      });
    });
    group(FailRetrieveOne, () {
      test('Should set loading for element false', () {
        final entity = generator();
        final result = reducer.call(
          initialState
              .copyWith(loadingIds: {reducer.adapter.getId(entity): true}) as S,
          FailRetrieveOne<T>(id: reducer.adapter.getId(entity), error: 'error'),
        );
        expect(result.loadingIds[reducer.adapter.getId(entity)], false);
      });
      test('Should set the error', () {
        final result = reducer.call(
          initialState.copyWith(loadingIds: {'a': true}) as S,
          FailRetrieveOne<T>(id: 'a', error: 'error'),
        );
        expect(result.error, 'error');
      });
    });

    group(RequestRetrieveAll, () {
      test('Should set loadingAll true', () {
        final result = reducer.call(initialState, RequestRetrieveAll<T>());
        expect(result.loadingAll, true);
      });
      test('Should clear error', () {
        final result = reducer.call(initialState, RequestRetrieveAll<T>());
        expect(result.error, false);
      });
    });

    group(SuccessRetrieveAll, () {
      test('items should be added to store', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result = reducer.call(
            initialState.copyWith(loadingIds: {'a': true, 'b': true, 'c': true})
                as S,
            SuccessRetrieveAll([
              e1,
              e2,
              e3,
            ]));
        expect(result.entities[reducer.adapter.getId(e1)], e1);
        expect(result.entities[reducer.adapter.getId(e2)], e2);
        expect(result.entities[reducer.adapter.getId(e3)], e3);
      });
      test('Should set loadingAll false', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result = reducer.call(
            initialState.copyWith(
              loadingIds: {
                reducer.adapter.getId(e1): true,
                reducer.adapter.getId(e2): true,
                reducer.adapter.getId(e3): true,
              },
              loadingAll: true,
            ) as S,
            SuccessRetrieveAll([e1, e2, e3]));
        expect(result.loadingAll, false);
      });
    });
    group(FailRetrieveAll, () {
      test('Should set loadingAll false', () {
        final result = reducer.call(
            initialState.copyWith(loadingIds: {'a': true, 'b': true, 'c': true})
                as S,
            const FailRetrieveAll('error'));
        expect(result.loadingAll, false);
      });
      test('Should set the error', () {
        final result = reducer.call(
            initialState.copyWith(loadingIds: {'a': true, 'b': true, 'c': true})
                as S,
            FailRetrieveAll<T>('error'));
        expect(result.error, 'error');
      });
    });

    group('REQUEST UPDATE ONE', () {
      test('Should set loading for element true', () {
        final e1 = generator();
        final result = reducer.call(initialState, RequestUpdateOne<T>(e1));
        expect(result.loadingIds[reducer.adapter.getId(e1)], true);
      });
      test('Should clear error', () {
        final result = reducer.call(
            initialState.copyWith(error: 'testerror') as S,
            RequestUpdateOne<T>(generator()));
        expect(result.error, false);
      });
    });
    group(SuccessUpdateOne, () {
      test('item should be added to store', () {
        final e1 = generator();
        final result = reducer.call(
            initialState.copyWith(
                creating: false,
                loadingAll: false,
                loadingIds: {reducer.adapter.getId(e1): true},
                entities: {reducer.adapter.getId(e1): generator()},
                ids: [reducer.adapter.getId(e1)]) as S,
            SuccessUpdateOne(e1));
        expect(result.entities[reducer.adapter.getId(e1)], e1);
      });
      test('Should set loading for element false', () {
        final e1 = generator();
        final result = reducer.call(
            initialState.copyWith(
                creating: false,
                loadingAll: false,
                loadingIds: {reducer.adapter.getId(e1): true},
                entities: {reducer.adapter.getId(e1): generator()},
                ids: [reducer.adapter.getId(e1)]) as S,
            SuccessUpdateOne(e1));
        expect(result.loadingIds[reducer.adapter.getId(e1)], false);
      });
    });
    group(FailUpdateOne, () {
      test('Should set loading for element false', () {
        final e1 = generator();
        final result = reducer.call(
            initialState.copyWith(
                creating: false,
                loadingAll: false,
                loadingIds: {reducer.adapter.getId(e1): true},
                entities: {reducer.adapter.getId(e1): generator()},
                ids: [reducer.adapter.getId(e1)]) as S,
            FailUpdateOne<T>(entity: e1, error: 'error'));
        expect(result.loadingIds[reducer.adapter.getId(e1)], false);
      });
      test('Should set the error', () {
        final e1 = generator();
        final result = reducer.call(
            initialState.copyWith(
                creating: false,
                loadingAll: false,
                loadingIds: {reducer.adapter.getId(e1): true},
                entities: {reducer.adapter.getId(e1): generator()},
                ids: [reducer.adapter.getId(e1)]) as S,
            FailUpdateOne<T>(entity: e1, error: 'error'));
        expect(result.error, 'error');
      });
    });

    group(RequestUpdateMany, () {
      test('Should set loading for each element true', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result =
            reducer.call(initialState, RequestUpdateMany<T>([e1, e2, e3]));
        expect(result.loadingIds[reducer.adapter.getId(e1)], true);
        expect(result.loadingIds[reducer.adapter.getId(e2)], true);
        expect(result.loadingIds[reducer.adapter.getId(e3)], true);
      });
      test('Should clear error', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result =
            reducer.call(initialState, RequestUpdateMany<T>([e1, e2, e3]));
        expect(result.error, false);
      });
    });
    group(SuccessUpdateMany, () {
      test('items should be added to store', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            reducer.adapter.getId(e1): true,
            reducer.adapter.getId(e2): true,
            reducer.adapter.getId(e3): true
          }, entities: {
            reducer.adapter.getId(e1): generator(),
            reducer.adapter.getId(e2): generator(),
            reducer.adapter.getId(e3): generator()
          }, ids: [
            reducer.adapter.getId(e1),
            reducer.adapter.getId(e2),
            reducer.adapter.getId(e3),
          ]) as S,
          SuccessUpdateMany<T>(
            [
              e1,
              e2,
              e3,
            ],
          ),
        );
        expect(result.entities[reducer.adapter.getId(e1)], e1);
        expect(result.entities[reducer.adapter.getId(e2)], e2);
        expect(result.entities[reducer.adapter.getId(e3)], e3);
      });

      test('Should set loading for each element false', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            reducer.adapter.getId(e1): true,
            reducer.adapter.getId(e2): true,
            reducer.adapter.getId(e3): true
          }, entities: {
            reducer.adapter.getId(e1): generator(),
            reducer.adapter.getId(e2): generator(),
            reducer.adapter.getId(e3): generator()
          }, ids: [
            reducer.adapter.getId(e1),
            reducer.adapter.getId(e2),
            reducer.adapter.getId(e3),
          ]) as S,
          SuccessUpdateMany<T>(
            [
              e1,
              e2,
              e3,
            ],
          ),
        );
        expect(result.loadingIds[reducer.adapter.getId(e1)], false);
        expect(result.loadingIds[reducer.adapter.getId(e2)], false);
        expect(result.loadingIds[reducer.adapter.getId(e3)], false);
      });
    });
    group(FailUpdateMany, () {
      test('Should set loading for each element false', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            reducer.adapter.getId(e1): true,
            reducer.adapter.getId(e2): true,
            reducer.adapter.getId(e3): true
          }, entities: {
            reducer.adapter.getId(e1): generator(),
            reducer.adapter.getId(e2): generator(),
            reducer.adapter.getId(e3): generator()
          }, ids: [
            reducer.adapter.getId(e1),
            reducer.adapter.getId(e2),
            reducer.adapter.getId(e3),
          ]) as S,
          FailUpdateMany<T>(entities: [e1, e2, e3], error: 'error'),
        );
        expect(result.loadingIds[reducer.adapter.getId(e1)], false);
        expect(result.loadingIds[reducer.adapter.getId(e2)], false);
        expect(result.loadingIds[reducer.adapter.getId(e3)], false);
      });
      test('Should set the error', () {
        final e1 = generator();
        final e2 = generator();
        final e3 = generator();
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            reducer.adapter.getId(e1): true,
            reducer.adapter.getId(e2): true,
            reducer.adapter.getId(e3): true
          }, entities: {
            reducer.adapter.getId(e1): generator(),
            reducer.adapter.getId(e2): generator(),
            reducer.adapter.getId(e3): generator()
          }, ids: [
            reducer.adapter.getId(e1),
            reducer.adapter.getId(e2),
            reducer.adapter.getId(e3),
          ]) as S,
          FailUpdateMany<T>(entities: [e1, e2, e3], error: 'error'),
        );
        expect(result.error, 'error');
      });
    });

    group(RequestDeleteOne, () {
      test('Should set loading for element true', () {
        final result = reducer.call(initialState, RequestDeleteOne<T>('a'));
        expect(result.loadingIds['a'], true);
      });
      test('Should clear error', () {
        final result = reducer.call(
            initialState.copyWith(error: 'testerror') as S,
            RequestDeleteOne<T>('a'));
        expect(result.error, false);
      });
    });
    group('SUCCESS DELETE ONE', () {
      test('item should be removed from store', () {
        final result = reducer.call(
            initialState
                .copyWith(creating: false, loadingAll: false, loadingIds: {
              'a': true
            }, entities: {
              'a': generator(),
              'b': generator(),
              'c': generator(),
            }, ids: [
              'a',
              'b',
              'c'
            ]) as S,
            SuccessDeleteOne<T>('a'));
        expect(result.entities['a'], null);
      });
      test('Should set loading for element false', () {
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            'a': true
          }, entities: {
            'a': generator(),
            'b': generator(),
            'c': generator(),
          }, ids: [
            'a',
            'b',
            'c'
          ]) as S,
          SuccessDeleteOne<T>('a'),
        );
        expect(result.loadingIds['a'], false);
      });
    });
    group(FailDeleteOne, () {
      test('Should set loading for element false', () {
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            'a': true
          }, entities: {
            'a': generator(),
            'b': generator(),
            'c': generator(),
          }, ids: [
            'a',
            'b',
            'c'
          ]) as S,
          FailDeleteOne<T>(id: 'a', error: 'error'),
        );
        expect(result.loadingIds['a'], false);
      });
      test('Should set error', () {
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            'a': true
          }, entities: {
            'a': generator(),
            'b': generator(),
            'c': generator(),
          }, ids: [
            'a',
            'b',
            'c'
          ]) as S,
          FailDeleteOne<T>(id: 'a', error: 'error'),
        );
        expect(result.error, 'error');
      });
    });

    group('REQUEST DELETE MANY', () {
      test('Should set loading for each element true', () {
        final result =
            reducer.call(initialState, RequestDeleteMany<T>(['a', 'b', 'c']));
        expect(result.loadingIds['a'], true);
        expect(result.loadingIds['b'], true);
        expect(result.loadingIds['c'], true);
      });
      test('Should clear error', () {
        final result =
            reducer.call(initialState, RequestDeleteMany<T>(['a', 'b', 'c']));
        expect(result.error, false);
      });
    });
    group('SUCCESS DELETE MANY', () {
      test('items should be removed fromstore', () {
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            'a': true
          }, entities: {
            'a': generator(),
            'b': generator(),
            'c': generator(),
          }, ids: [
            'a',
            'b',
            'c'
          ]) as S,
          SuccessDeleteMany<T>(['a', 'b', 'c']),
        );
        expect(result.entities['a'], null);
        expect(result.entities['d'], null);
        expect(result.entities['c'], null);
      });
      test('Should set loading for each element false', () {
        final result = reducer.call(
          initialState
              .copyWith(creating: false, loadingAll: false, loadingIds: {
            'a': true
          }, entities: {
            'a': generator(),
            'b': generator(),
            'c': generator(),
          }, ids: [
            'a',
            'b',
            'c'
          ]) as S,
          SuccessDeleteMany<T>(['a', 'b', 'c']),
        );
        expect(result.loadingIds['a'], false);
        expect(result.loadingIds['b'], false);
        expect(result.loadingIds['c'], false);
      });
    });
    group('FAIL DELETE MANY', () {
      test('Should set loading for each element false', () {
        final result = reducer.call(
            initialState
                .copyWith(creating: false, loadingAll: false, loadingIds: {
              'a': true,
              'b': true,
              'c': true
            }, entities: {
              'a': generator(),
              'b': generator(),
              'c': generator(),
            }, ids: [
              'a',
              'b',
              'c'
            ]) as S,
            FailDeleteMany<T>(ids: ['a', 'b', 'c'], error: 'error'));
        expect(result.loadingIds['a'], false);
        expect(result.loadingIds['b'], false);
        expect(result.loadingIds['c'], false);
      });
      test('Should set error', () {
        final result = reducer.call(
            initialState
                .copyWith(creating: false, loadingAll: false, loadingIds: {
              'a': true,
              'b': true,
              'c': true
            }, entities: {
              'a': generator(),
              'b': generator(),
              'c': generator(),
            }, ids: [
              'a',
              'b',
              'c'
            ]) as S,
            FailDeleteMany<T>(ids: ['a', 'b', 'c'], error: 'error'));
        expect(result.error, 'error');
      });
    });
  }
}
