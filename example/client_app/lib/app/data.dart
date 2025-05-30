import 'package:common/common.dart';
import 'package:shared_data/shared_data.dart';

class IncrementRepository extends Repository<Increment> {
  IncrementRepository()
      : super(
          SourceList<Increment>(
            sources: [
              LocalMemorySource(),
            ],
            bindings: Increment.bindings,
          ),
        );
}
