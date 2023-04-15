import 'dart:async';
import 'package:gql_codegen/src/graphql_file.dart';
import 'package:gql_codegen/src/graphql_processor.dart';
import 'package:build/build.dart';

class GraphqlBuilder implements Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    // currently matched asset
    final _inputId = buildStep.inputId;
    final _resultFile = _inputId.changeExtension('.g.dart');

    final _fileBaseName = buildStep.inputId.pathSegments.last;
    final _fileContents = await buildStep.readAsString(_inputId);

    final _result = await processGraphqlFile(GraphqlFile(
      fileContents: _fileContents,
      fileName: _fileBaseName,
    ));

    final _classString = await getClassDefinition(_result);

    await buildStep.writeAsString(_resultFile, _classString);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.graphql': ['.g.dart'],
        '.gql': ['.g.dart'],
      };
}
