import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Output serializing code for all models with the `@_Annotation` annotation.
/// This generator is the annotation that discovers all models in the domain
/// and most commonly invokes sub generators.
///
/// For example, all `@ConnectOfflineFirstWithRest` models may be discovered and passed to
/// subsequent generators.
abstract class AnnotationSuperGenerator<_Annotation> extends GeneratorForAnnotation<_Annotation> {
  const AnnotationSuperGenerator() : super();

  /// Outputs any sub generators with the exception of the adapter.
  /// The adapter _should_ include code generated by this method.
  @override
  String generateForAnnotatedElement(element, annotation, buildStep);

  /// Combine relevant serdes generators for output to a single file: the adapter.
  String generateAdapter(Element element, ConstantReader annotation, BuildStep buildStep);
}
