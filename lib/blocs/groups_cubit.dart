import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:parousia/models/models.dart';

class GroupsCubit extends HydratedCubit<List<Group>> {
  GroupsCubit() : super([]);

  void addGroup(Group group) {
    emit([...state, group]);
  }

  void removeGroup(Group group) {
    emit(state.where((g) => g.id != group.id).toList());
  }

  @override
  List<Group>? fromJson(Map<String, dynamic> json) {
    return json['groups']?.map(Group.fromJson) as List<Group>?;
  }

  @override
  Map<String, dynamic>? toJson(List<Group> state) {
    return {'groups': state.map((g) => g.toJson()).toList()};
  }
}
