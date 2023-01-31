set export

crate := "native"

@codegen:
  flutter pub get
  flutter_rust_bridge_codegen \
    -r $crate/src/api.rs \
    -d lib/bridge_generated.dart \
    -c ios/Runner/bridge_generated.h \
    -e macos/Runner/ \
    --dart-decl-output lib/bridge_definitions.dart

remove-gen:
  fd -tf bridge_generated -x rm -rf

remove-build:
  # rm -rf $crate/target
  cd $crate && cargo clean

clean: remove-gen remove-build
  flutter clean

run-no-cache: clean codegen
  flutter run
