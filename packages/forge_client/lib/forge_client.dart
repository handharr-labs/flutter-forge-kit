/// Flutter Forge Kit — IO layer.
///
/// Transport and storage adapters consumed only by the Data layer. Depends on
/// [forge_core] for [Result]/[DomainError]; holds no domain or feature logic.
library;

export 'src/api_client.dart';
export 'src/local_data_source.dart';
export 'src/web_socket_client.dart';
